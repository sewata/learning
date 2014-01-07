#!/usr/bin/perl -w

use strict;

# hostgroups.cfg
my $hostgroups_file = "$ARGV[0]";
# list
my $list_file = "$ARGV[1]";
# flag
my $flag = "$ARGV[2]";

# フラグ flipflop
my $ff;

# hostgroup
my @hostgroup;
my @hostgroups;

# 現行ホストグループ設定情報の読み込み
open (FH,"<$hostgroups_file") or die "Error: reading $hostgroups_file $!\n";
while (<FH>) {
    chomp;

    # 空行無視
    if (/^$/ or /^\s*$/) { next; }

    # 定義開始なら読み込みフラグON
    if (/define hostgroup {/) { $ff = 1; next; }

    # 定義終了なら読み込みフラグOFF
    if (/}/) { $ff = 0; }

    # 読み込みフラグONなら一時配列へpush
    if ($ff) { push (@hostgroup, $_); }

    # 読み込みフラグOFFなら一時配列から取り出してハッシュへ格納
    if (!$ff) {
        my %kv = ();
        foreach (@hostgroup) {
            /\s*(\S*)?\s*(.*)/;
            my $k = $1;
            my $v = $2;
            if ($k) { $kv{$k} = $v; }
        }

        # ハッシュのリファラを配列へ格納し、一時配列を初期化
        if (%kv) { push (@hostgroups, \%kv); }
        @hostgroup = ();
    }
}
close (FH);

# 削除処理
if ($flag eq "DELETE") {
  # 削除対象ホストグループ読み込み
  open (FH,"<$list_file") or die "Error: reading $list_file $!\n";
  my @line = <FH>;
  close (FH);
  chomp @line;
  # 削除対象ホストグループ名を既存ホストグループ名から探す
  foreach my $k (@line) {
    print "       $k will be deleted.\n";
    my $i=-1;
    my $found=0;
    foreach my $v (@hostgroups) {
      $i++;
      if($v) {
        if ($$v{hostgroup_name} eq $k) {
          delete ($hostgroups[$i]);
          print "       $$v{hostgroup_name},$$v{alias} deleted.\n";
          $found = 1;
          last;
        }
      }
    }
    if (!$found) {
      print "$k not found.\n";
    }
  }
}

# 追加処理
if ($flag eq "ADD") {
  open (FH,"<$list_file") or die "Error: reading $list_file $!\n";
  while(<FH>) {
    chomp;
    my ($hostgroup_name, $alias) = split(/\t/,$_);
    if (!$alias) {
      $alias = '-';
    }
    print "       $hostgroup_name,$alias will be added.\n";
    my %hostgroup = (
        'hostgroup_name' => $hostgroup_name,
        'alias'          => $alias,
    );
    push (@hostgroups,\%hostgroup);
  }
}

# hostgroups.cfgを上書き
open (FH,">$hostgroups_file") or die "Error: writing $hostgroups_file $!\n";
foreach my $v (@hostgroups) {
    if (!$v) { next; }
    print FH "define hostgroup {\n";
    print FH "        hostgroup_name                          $$v{hostgroup_name}\n";
    print FH "        alias                                   $$v{alias}\n";
    print FH "        hostgroup_members                       $$v{hostgroup_members}\n" if($$v{hostgroup_members});
    print FH "}\n";
    print FH "\n";
}
