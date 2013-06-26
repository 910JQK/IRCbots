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
  sleep 20;
  $used=1;
  return;
  }
  my $self = shift;
  my $message = shift;
  my $body = $message->{body};
  if($body =~ /^\.bar/)
  {
  $used=0;
  @sp = split(/ /,$body);
  $r=`/home/jqk/bar "$sp[1]" "$sp[2]"`;
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
nick => "barbot_l",
alt_nicks => ["barbot_l1", "barbot_l2"],
username  => "L_barbot-test",
name      => "A bot that is testing"
)->run();

