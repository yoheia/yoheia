#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my $results={};
my %days;
my ($mon, $day);

print "sga component";

while (defined($_ = <ARGV>)) {
	chomp;
	s/\t//g;
	my @cols = split(/,/, $_);
	if ($#cols >= 4 and ($mon, $day) = $cols[0] =~ /(\d{2})(\d{2})\d{6}/) {
		$days{"$mon-$day"}++;
		$results->{$cols[3]}->{"$mon-$day"} = $cols[4] if ($cols[2] eq 'shared pool');
	}
	close ARGV if eof;
}

map {print "\t$_"} sort keys %days;
print "\n";

foreach (sort keys %{$results}) {
	print $_;
	foreach my $day (sort keys %{$results->{$_}}) {
		print "\t$results->{$_}->{$day}";
	}
	print "\n";
}

__END__
