#!/usr/bin/perl

use strict;
use warnings;
use feature qw/switch say/;
no warnings qw/experimental/;

unless(defined $ARGV[0] && -f $ARGV[0])
{
	die('!!');
}


my ($group, $sub, $key, $value) = 'a';
my $ini = {};
my @sort = ();
open(FILE, '<', $ARGV[0]) or die('!!!');
while(<FILE>)
{
	chomp;
	next if /^$/;
	next if /^;/;

	($sub, $key, $value) = (undef, undef, undef);

	given($_)
	{
		when(/^\[([\w\s]+)\]\s*$/)
		{
			$group = $1;
			push(@sort, $group);
		}
		when(/^([\w\.]+)\s*=\s*(\w*)$/)
		{
			$key = $1;
			$value = $2;
			$ini->{$group}->{$key} = $value;
		}
	}
}
close(FILE);

say 'php_ini:';
foreach(@sort)
{
	next unless defined $ini->{$_};
	printf("  - group_name: '%s'\n", $_);
	printf("    conf:\n");
	while(my ($k, $v) = each %{$ini->{$_}})
	{
		printf("      - key: '%s'\n", $k);
		printf("        value: '%s'\n", $v);
	}
}
