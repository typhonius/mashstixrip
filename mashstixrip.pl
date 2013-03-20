#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Cwd;

my $cwd = getcwd;
my $path = "http://www.mashstix.com/Downloads/download.php?stixnum=";
my $count_404 = 0;
my $writeable = 0;
our $directory = '';

sub download_url_parser($) {
  my $raw = shift;
  my $url = '';
  my $title = '';
  foreach (split("\n", $raw)) {
    if ($_ =~ m/<a href=\"(.*)\" target="_blank">Download Link/) {
      $url = $1;
    }
    elsif ($_ =~ m/<title>(.*)<\/title>/) {
      $title = $1;
    }
  }
  return ($url, $title);
}

sub rip_all_the_things() {
  # currently testing numbers to ensure the pattern matching works
  for (my $i = 0; $count_404 <= 5; $i++) {
    #print "Processing track id " . $i;
    $i = sprintf("%6d", $i);
    $i=~ tr/ /0/;

    # Get the pages, parse them to find the download link (below) and then grab it.
    my $lwp = LWP::UserAgent->new;
    my $response = $lwp->get( $path . $i );
    if (!is_success($response->status_line)) {
      $count_404++;
    }
    else {
      my ($download_url, $title) = download_url_parser($response->content);
      if (is_success(getstore($download_url, $directory . '/' . $title . '.mp3'))) {
        print "Success downloading $title\n";
      }
      else {
        print "Error downloading $title - $download_url - ID: $i\n";
      }
    }
  }
}

# Ask the user for a download directory
until ($writeable) {
  print "The current (and default) download directory is $cwd.
To use this directory type '.' otherwise enter a relative path from
$cwd or absolute path to proceed.
Enter the directory to download to: ";
  # Capture the user input minus any newlines.
  chomp($directory = <>);

  # if it's writeable carry on, otherwise try to create a directory,
  # otherwise just ask again.
  if (-w $directory && opendir(DL, $directory)) {
    # The directory is writeable so we can use it.
    $writeable = 1;
    rip_all_the_things();
  }
  elsif (mkdir $directory) {
    # Directory isn't writeable, can we create the path by making folders?
    print "New directory created!\n";
    $writeable = 1;
    rip_all_the_things();
  }
  else {
    print "Directory not writeable/able to be created. Please specify a new path\n";
  }
}