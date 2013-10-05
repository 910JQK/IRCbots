#!/usr/bin/perl

use warnings;
#use utf8;
#use Text::Unidecode;
#use Bot::BasicBot;
#use WWW::Mechanize;


package bot;
use base 'Bot::BasicBot';
use Encode;
$TC=0;
$TC2=0;

sub connected {
  my $self = shift;
  print STDERR $self->nick." connected\n";
#  $self->join('#linuxbar');
  $self->say(channel => '#linuxbar', body => 'Hello, I am '.$self->nick);
  timer1($self);
}

sub tick {
    $TC++;
    $TC2++;
    print "TimeCount1:".$TC."\n";
    print "TimeCount2:".$TC2."\n";
    if($TC==30){
    my $self = shift;
    timer1($self);
    $TC=0;
    }
    if($TC2==50){
    my $self = shift;
    timer2($self);
    $TC2=0;
    }
    return 1;
}

sub timer1 {
	print "debug:timer1\n";
	$r=`/home/jqk/IRCbots/barget.sh linux 3`;
	$r=decode ('utf-8',$r);
	$_[0]->notice(channel => '#linuxbar',body => $r);
}

sub timer2 {
	print "debug:timer2\n";
	$r=`/home/jqk/IRCbots/barget.sh archlinux 3`;
	$r=decode ('utf-8',$r);
	$_[0]->notice(channel => '#linuxbar',body => $r);
}

package main;

bot->new( 
channels => ["#linuxbar"] ,
server => "irc.freenode.net" ,
port => "6667",
nick => "barget_l",
alt_nicks => ["barget_l1", "barget_l2"],
username  => "L_barget-test",
name      => "A bot that is testing"
)->run();

