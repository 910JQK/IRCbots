#!/usr/bin/perl

use warnings;
#use utf8;
#use Text::Unidecode;
#use Bot::BasicBot;
#use WWW::Mechanize;


package bot;
use base 'Bot::BasicBot';
use Encode;
$used=1;


sub connected {
  my $self = shift;
  print STDERR $self->nick." connected\n";
#  $self->join('#linuxbar');
  $self->say(channel => '#linuxbar', body => 'Hello, I am '.$self->nick);
}

sub said {
  my $self = shift;
  my $message = shift;
  my $body = $message->{body};
  if($body eq ".help barbot")
  {
  $self->reply($message,"BarBot - 幫助:\n .cnstock/滬深股指 | .cnstock sh|sz股票代碼 (例:.cnstock sh600000) / 查詢個股 | .usstock/美國股指 | .bar 貼吧 條目數 | .bili 搜索字串 條目數 | 有10秒緩衝");
  }

  if($body =~ /^.cnstock/){
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

  if($body =~ /^.dict/){
  @sp = split(/ /,$body);
  $r=`/home/jqk/IRCbots/ydcv-cut.sh dict $sp[1]`;
  $self->reply($message,$r);
  }
  }

  if($body =~ /^.dictweb/){
  @sp = split(/ /,$body);
  $r=`/home/jqk/IRCbots/ydcv-cut.sh web $sp[1]`;
  $self->reply($message,$r);
  }
  }

  if($body eq ".usstock")
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

package main;

bot->new( 
channels => ["#linuxbar","#linuxba"] ,
server => "chat.freenode.net" ,
port => "6667",
nick => "barbot_l",
alt_nicks => ["barbot_l1", "barbot_l2"],
username  => "L_barbot-test",
name      => "A bot that is testing"
)->run();

