#!/usr/bin/perl -w

# http://search.cpan.org/dist/Spreadsheet-WriteExcel/lib/Spreadsheet/WriteExcel.pm
# http://d.hatena.ne.jp/end0tknr/20090112/1231755461

use strict;
use Spreadsheet::WriteExcel;

my $DEBUG = 0;

my $workbook = Spreadsheet::WriteExcel->new('trap-hearing.xls');
my $worksheet = $workbook->add_worksheet();

my $LDflag = 0;
my $VARSflag = 0;
my $VARflag = 0;
my $row = 0;
my $column = 0;
my $longdesc = "";
my $var = "";
my $varnum = 0;
my $varnummax = 0;

$worksheet->write(0, 0, 'EventName');
$worksheet->write(0, 1, 'OID');
$worksheet->write(0, 2, 'Enterprise');
$worksheet->write(0, 3, 'TrapType');
$worksheet->write(0, 4, 'SpecificCode');
$worksheet->write(0, 5, 'LongDescription');

while(<>) {
  my $line = $_;

  if ($line =~ /^EVENT (.*)/) {
    $row++;
    my $name = "";
    my $oid = "";
    ($name, $oid) = split(/ /,$1);
    $oid =~ /(.*)\.0\.(.*)/;
    my $enterprise = $1;
    my $specific = $2;
    $worksheet->write($row, 0, $name);
    print "name write on $row,0 $name\n" if $DEBUG;

    $worksheet->write($row, 1, $oid);
    print "oid write on $row,1 $oid\n" if $DEBUG;

    $worksheet->write($row, 2, $enterprise);
    print "enterprise write on $row,2 $enterprise\n" if $DEBUG;

    $worksheet->write($row, 3, '6:EnterpriseSpecific');
    print "6:EnterpriseSpecific write on $row,3\n" if $DEBUG;

    $worksheet->write($row, 4, $specific);
    print "specific write on $row,4 $specific\n" if $DEBUG;

    next;
  }

  if ($line =~ /^EDESC$/) {
    if (($longdesc) and (!$VARSflag)) {
      chomp $longdesc;
      $worksheet->write($row, 5, $longdesc);
      print "LD write on $row,5 due to EDESC $longdesc\n" if $DEBUG;
    }
    if ($var) {
      chomp $var;
      $worksheet->write($row, $column, $var);
      print "var write on $row,$column due to EDESC $var\n" if $DEBUG;
      $var = "";
    }
    $LDflag = 0;
    $VARSflag = 0;
    next;
  }

  # TODO?
  # /^FORMAT/
  # /^SDESC/

  if ($line =~ /^Long Descr.:$/) {
    $longdesc = "";
    $LDflag = 1;
    next;
  }

  if ($line =~ /^Variables:$/) {
    if ($longdesc) {
      chomp $longdesc;
      $worksheet->write($row, 5, $longdesc);
      print "LD write on $row,5 due to Variables: $longdesc\n" if $DEBUG;
    }
    $LDflag = 0;
    $VARSflag = 1;
    $column = 5;
    $varnum = 0;
    next;
  }

  if ($LDflag) {
    $longdesc .= $line;
  }

  if ($VARSflag) {
    if ($line =~ /^\s+\d+:/) {
      $column++;
      $varnum++;
      if ($varnum > $varnummax) {
        $worksheet->write(0, $column, "Varbind($varnum)");
        $varnummax = $varnum;
        print "Varbind($varnum) write on 0,$column due to new var\n" if $DEBUG;
      }
      if ($var) {
        chomp $var;
        $worksheet->write($row, ($column-1), $var);
        print "var write on $row,",$column-1," due to new var $var\n" if $DEBUG;
        $var = "";
      }
      $var .= $line;
     } else {
      $var .= $line;
    }
  }
}
