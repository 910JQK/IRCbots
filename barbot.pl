#!/usr/bin/perl

use warnings;
#use utf8;
#use Text::Unidecode;
#use Bot::BasicBot;
#use WWW::Mechanize;


package bot;
use base 'Bot::BasicBot';
use HTML::TreeBuilder;
use Switch;
use Encode;
$used=1;
$TC=0;
$TC2=0;


sub barget {
    $_[0] ~= s/\n//;
    $p = HTML::TreeBuilder -> new_from_url($_[0]);
    my @title= $p->look_down(_tag=>'h1',class=>'core_title_txt ')->as_text;
    my @author= $p->look_down(_tag=>'li',class=>'d_name')->as_text;
    my @content= $p->look_down(_tag=>'div',class=>'d_post_content j_d_post_content ')->as_text;
    if(length($content[0])>=50){
	$content[0]=substr($content[0],0,50).'...';
    }
    undef $p;
    return $_[0]." 【".$title[0]."】 by".$author[0]."\n".$content[0];
}

sub connected {
  my $self = shift;
  print STDERR $self->nick." connected\n";
#  $self->join('#linuxbar');
  $self->say(channel => '#linuxba', body => 'Hello, I am '.$self->nick);
  timer1($self);
}

sub said {
  my $self = shift;
  my $message = shift;
  my $body = $message->{body};
  if($body eq ".help barbot")
  {
  $self->reply($message,"BarBot - 幫助:\n .cnstock/滬深股指 | .cnstock sh|sz股票代碼 (例:.cnstock sh600000) / 查詢個股 | .usstock/美國股指 | .bar 貼吧 條目數 | .bili 搜索字串 條目數 | 有10秒緩衝");
  }

  if($body =~ /^\.cnstock/){
  if($body eq ".cnstock")
  {
  $r=`/home/jqk/IRCbots/cnstock.sh`;
#  $r=decode ('utf-8',$r);
  $self->reply($message,$r);
  }else{
  @sp = split(/ /,$body);
  $r=`/home/jqk/IRCbots/cnstock.sh $sp[1]`;
  $self->reply($message,$r);
  }
  }

  if($body =~ /^\.dict/){
  @sp = split(/ /,$body);
  $r=`/home/jqk/IRCbots/ydcv-cut.sh dict $sp[1]`;
  $self->reply($message,$r);
  }

  if($body =~ /^\.dictweb/){
  @sp = split(/ /,$body);
  $r=`/home/jqk/IRCbots/ydcv-cut.sh web $sp[1]`;
  $self->reply($message,$r);
  }

  if($body eq "\.usstock")
  {
  $r=`/home/jqk/IRCbots/usstock.sh`;
#  $r=decode ('utf-8',$r);
  $self->reply($message,$r);
  }

  if($used==0){
  sleep 20;
  $used=1;
  return;
  }
  if($body =~ /^\.bar/)
  {
  $used=0;
  $body=decode ('utf-8',$body);
  @sp = split(/ /,$body);
  $r=`/home/jqk/IRCbots/bar "$sp[1]" "$sp[2]"`;
#  $r=decode ('utf-8',$r);
  $self->reply($message,$r);
  }else{
    if($body =~ /^\.bili/)
    {
    $used=0;
    $body=decode ('utf-8',$body);
    @sp = split(/ /,$body);
    $r=`'/home/jqk/IRCbots/bili.sh' "$sp[1]" "$sp[2]"`;
#   $r=decode ('utf-8',$r);
    $self->reply($message,$r);
    }else{
    return;
    }
  }
}

sub tick {
    $TC++;
    $TC2++;
#    print "TimeCount1:".$TC."\n";
#    print "TimeCount2:".$TC2."\n";
    if($TC==1800||$TC2==5400){
	my $self = shift;
    if($TC==1800){
	timer1($self);
	$TC=0;
    }
    if($TC2==5400){
	timer2($self);
	$TC2=0;
    }
    }
    return 1;
}

sub timer1 {
    my $r=" ";
    $r=`/home/jqk/IRCbots/barget-no-regexp.sh linux 4`;
    $R=barget($r);
#    $r=decode ('utf-8',$r);
    eval{$_[0]->say(channel => '#linuxbar',body => $R)};
}

sub timer2 {
    my $r=" ";
    my $what;
    my $whichbar;
    srand;
    $what=int(rand(3));
    switch($what){
	case 1 { $whichbar = 'ubuntulinux' }
	case 2 { $whichbar = 'debian' }
	case 3 { $whichbar = 'c%e8%af%ad%e8%a8%80' }
	else { $whichbar = 'archlinux' }
    }
    $r=`/home/jqk/IRCbots/barget-no-regexp.sh $whichbar 4`;
    $R=barget($r);
#    $r=decode ('utf-8',$r);
    eval{$_[0]->say(channel => '#linuxbar',body => $r)};
}

package main;

bot->new( 
channels => ["#linuxbar","#linuxba"] ,
server => "chat.freenode.net" ,
port => "6667",
nick => "barbot_new",
alt_nicks => ["barbot_l1", "barbot_l2"],
username  => "L_barbot-test_new",
name      => "A bot that is testing"
)->run();

