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
  if($used==0){
  sleep 8;
  $used=1;
  return;
  }
  my $self = shift;
  my $message = shift;
  my $body = $message->{body};
#  print $body;
  if($body =~ /^\.bili/)
  {
  $used=0;
  $body=decode ('utf-8',$body);
  @sp = split(/ /,$body);
  $r=`'/home/jqk/IRCbots/bili' "$sp[1]" "$sp[2]"`;
#  $r=decode ('utf-8',$r);
  $self->reply($message,$r);
  }else{
  return;
  }
}

package main;

bot->new( 
channels => ["#linuxbar"] ,
server => "irc.freenode.net" ,
port => "6667",
nick => "bilibot_l",
alt_nicks => ["bilibot_l1", "bilibot_l2"],
username  => "L_bili-test",
name      => "A bot that is testing"
)->run();

