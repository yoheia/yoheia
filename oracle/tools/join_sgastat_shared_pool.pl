#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my $results={};
my ($year, $mon, $date);

print "sga component";

while (defined($_ = <ARGV>)) {
	chomp;
	s/\t{2,}/\t/;
	if ($. == 1) {
		my $filename = basename($ARGV);
		if (($year, $mon, $date) = $filename =~ /[a-z]+_(\d{4})(\d{2})(\d{2})_\d+\.log/) {
			print "\t$year-$mon-$date";
		} else {
			close ARGV;
		}
	}
	my @cols = split(/\t/, $_);
	$results->{$cols[0]}->{"$year-$mon-$date"} = $cols[1] if /^shared pool/;
	close ARGV if eof;
}

print "\n";

foreach (sort keys %{$results}) {
	print $_;
	foreach my $date (sort keys %{$results->{$_}}) {
		my $val = ($results->{$_}->{$date} ne '' ? $results->{$_}->{$date} : 0 );
		$val =~ s/\s//g;
		print "\t$val";
	}
	print "\n";
}

__END__
