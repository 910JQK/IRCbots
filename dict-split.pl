#!/usr/bin/perl

use warnings;
#use utf8;
#use Text::Unidecode;
#use Bot::BasicBot;
#use WWW::Mechanize;


package bot;
use base 'Bot::BasicBot';
use Encode;


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
  if($body =~ /^.dict/){
      @sp = split(/ /,$body);
      $r=`/home/jqk/IRCbots/ydcv-cut.sh dict $sp[1]`;
      $self->reply($message,$r);
  }


if($body =~ /^.dictweb/){
    @sp = split(/ /,$body);
    $r=`/home/jqk/IRCbots/ydcv-cut.sh web $sp[1]`;
    $self->reply($message,$r);
}
  return;
}

package main;

bot->new( 
channels => ["#linuxbar"] ,
server => "irc.freenode.net" ,
port => "6667",
nick => "dictbot_l",
alt_nicks => ["dictbot_l1", "dictbot_l2"],
username  => "L_dictbot-test",
name      => "A bot that is testing"
)->run();

