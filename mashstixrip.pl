#!/usr/bin/perl

use LWP::Simple;

# Ask the user for a download directory?

$path = "http://www.mashstix.com/Downloads/download.php?stixnum=";

$count_404 = 0;

for ($i = 000000; $count_404 <= 5; $i++) {
  # Get the pages, parse them to find the download link (below) and then grab it.
  # <a href="https://soundcloud.com/deem-mashup/oppa-soiree-style/download" target="_blank">Download Link (right click)</a>
}
