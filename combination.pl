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

#　組合せの数の計算
#　白黒赤青の4色の中から2色を選び出す場合、
#　（白、黒）（白、赤）（白、青）（黒、赤）（黒、青）（赤、青）
#　C(4,2) = 6
#　0 < r < nのとき、C(n,r) = C(n-1,r-1) + C(n-1,r)
#　r=nのとき、C(n,r) = 1
#　r=0のとき、C(n,r) = 1

#　perl combination.pl n r
