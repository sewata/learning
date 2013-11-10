#!/usr/bin/perl -w

use strict;

sub combi{
        my ($n,$r) = @_;
        print "n=$n , r=$r\n";

        if ( 0 lt $r && $r lt $n ) {
                print "combi(",$n - 1,",",$r - 1,") + combi(",$n - 1,",$r)\n";
                return combi(($n - 1),($r - 1)) + combi(($n - 1),$r);
        } else {
                print "else return 1\n";
                return 1;
        }
}

my $ans = combi($ARGV[0],$ARGV[1]);
print "The answer is $ans\n";
