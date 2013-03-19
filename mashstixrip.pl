#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

sub download_url_parser($) {
  my $raw = shift;
  my $url = '';
  #print Dumper ($raw);
  foreach (split("\n", $raw)) {
    if ($_ =~ m/<a href=\"(.*)\" target="_blank">Download Link/) {
  #if ($raw =~ /.*<a href="(\S)" target="_blank">Download Link (right click)<\/a>.*/) {
      $url = $1;
    }
    elsif ($_ =~ m/<title>(.*)<\/title>/) {
      print "Found $1\n";
    }
  }
  # <title>MashStix.com Music Mashups - Oki - California Swift (Taylor Swift vs Wolfmother)</title>

  #print Dumper($raw);
  return $url;
}

# Ask the user for a download directory?

my $path = "http://www.mashstix.com/Downloads/download.php?stixnum=";

my $count_404 = 0;
# currently testing numbers to ensure the pattern matching works
for (my $i = 3212; $i <= 3216; $i++) {
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
    #print Dumper ($response->content);
    #print $path . $i;
    my $download_url = download_url_parser($response->content);
  # <a href="https://soundcloud.com/deem-mashup/oppa-soiree-style/download" target="_blank">Download Link (right click)</a>
  }
}