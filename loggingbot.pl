#!/usr/bin/perl

use warnings;
#use utf8;
#use Text::Unidecode;
#use Bot::BasicBot;
#use WWW::Mechanize;


package bot;
use base 'Bot::BasicBot';
#use Encode;

$logfile="IRClog"

sub connected {
  $ENV{TZ}='UTC';
  my $self = shift;
  print STDERR $self->nick." connected\n";
#  $self->join('#linuxbar');
  $self->say(channel => '#linuxbar', body => 'Hello, I am '.$self->nick);
  open(F,">>$logfile")
}

sub said {
  $datestring = localtime();
  my $self = shift;
  my $message = shift;
  my $channel = $message->{channel};
  my $who = $message->{who};
  my $rawnick = $message->{raw_nick};
  my $body = $message->{body};
  print F "[SAID][$datestring][$channel] $rawnick/$who:$body";
}

sub chanjoin {
  $datestring = localtime();
  my $self = shift;
  my $message = shift;
  my $channel_which = $message->{channel};
  my $whojoin = $message->{who};
  print F "[INFO][$datestring] $whojoin Joined $channel_which";
}

sub userquit {
  $datestring = localtime();
  my $self = shift;
  my $message = shift;
  my $whoquit = $message->{who};
  my $body_what = $message->{body};
  print F "[INFO][$datestring] $whoquit Quit with message $body_what";
}

package main;

bot->new( 
channels => ["#wecase" , "#linuxbar" , "#linuxba" , "##Orz" , "#ubuntu-cn" , "#archlinux-cn" , "#c_lang_cn"] ,
server => "irc.freenode.net" ,
port => "6667",
nick => "JQKbot",
alt_nicks => ["JQKbot1", "JQKbot2"],
username  => "L_logging-test",
name      => "A logging bot belongs to JQK.Generate log only for himself when he is offline."
)->run();
