#!/usr/bin/perl -w

use strict;

my $hostgroups_file = "$ARGV[0]";

my $ff;

my @hostgroup;
my @hostgroups;

open (FH,"<$hostgroups_file") or die "Error: reading $hostgroups_file $!\n";
while (<FH>) {
    chomp;
    s/.$//; # for NagiosQL \r
    if (/^$/ or /^\s*$/) { next; }
    if (/define hostgroup {/) { $ff = 1; next; }
    if (/}/) { $ff = 0; }
    if ($ff) { push (@hostgroup, $_); }
    if (!$ff) {
        my %kv = ();
        foreach (@hostgroup) {
            /\s*(\S*)?\s*(.*)/;
            my $k = $1;
            my $v = $2;
            if ($k) { $kv{$k} = $v; }
        }
        if (%kv) { push (@hostgroups, \%kv); }
        @hostgroup = ();
    }
}
close (FH);

sub search {
  my ($hgname, $level) = @_;

  if ($level == 0) {
    print "$hgname\n";
  } else {
    for (my $i = 0; $i < $level; $i++) {
      print "\t";
    }
    print "$hgname\n";
  }

  foreach my $k (@hostgroups) {
    if ($$k{hostgroup_name} eq $hgname) {
      if ($$k{hostgroup_members}) {
        $level++;
        my @hostgroup_members = split(/,/,$$k{hostgroup_members});
        foreach my $v (@hostgroup_members) {
          &search ($v, $level);
        }
      } else {
        return 0;
      }
    }
  }
}

&search ("TOP", 0); # specify TOP hostgroup
