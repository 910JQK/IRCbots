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
  }else{
  return;
  }
}

package main;

bot->new( 
channels => ["#linuxbar"] ,
server => "irc.freenode.net" ,
port => "6667",
nick => "stockbot_l",
alt_nicks => ["stockbot_l1", "stockbot_l2"],
username  => "L_stockbot-test",
name      => "A bot that is testing"
)->run();

