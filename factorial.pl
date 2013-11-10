#!/usr/bin/perl -w

use strict;

sub factorial {
        my $n = $_[0];
        print "n=$n\n";
        if ( $n gt 1 ) {
                print "$n * factorial(", $n - 1, ")\n";
                return $n * factorial($n - 1);
        } else {
                return 1
        }
}

my $ans = factorial($ARGV[0]);
print "The answer is $ans\n";

# 階乗 n!
# n > 1 のとき n! = n * (n-1)!
# n = 1 のとき n! = 1

# perl factorial.pl n
