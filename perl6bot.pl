#!/usr/bin/perl

use warnings;
#use utf8;
#use Text::Unidecode;
#use Bot::BasicBot;
#use WWW::Mechanize;


package bot;
use base 'Bot::BasicBot';
#use Encode;


sub connected {
  my $self = shift;
  print STDERR $self->nick." connected\n";
#  $self->join('#linuxbar');
#  $self->say(channel => '#linuxbar', body => 'Hello, I am '.$self->nick);
}

sub said {
  my $self = shift;
  my $message = shift;
  my $body = $message->{body};
  $self->reply($message,"Perl6 robot: '.perl6 <code>' to run perl6 codes; '.perl6 stop' to make the robot exit.\nExample: .perl6 say 23*\$_ for 1..5") if $body eq '.help perl6bot';
  exit if $body eq '.perl6 stop';
  if($body =~ /^\.perl6/)
  {
#  $body=decode ('utf-8',$body);
  print "$body\n";
  $body =~ s/\.perl6//;
#  $used=0;
#  @sp = split(/ /,$body);
  $r=`perl6 -e '$body'`;
#  $r=decode ('utf-8',$r);
  $self->reply($message,$r) if length($r) < 255;
  }else{
  return;
  }
}

package main;

bot->new( 
channels => ["#linuxbar", "#linuxba"] ,
server => "irc.freenode.net" ,
port => "6667",
nick => "perl6bot_l",
alt_nicks => ["perl6bot_l1", "perl6bot_l2"],
#username  => "L_barbot-test",
name      => "A bot that is testing"
)->run();

