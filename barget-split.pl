#!/usr/bin/perl

use warnings;
#use utf8;
#use Text::Unidecode;
#use Bot::BasicBot;
#use WWW::Mechanize;


package bot;
use base 'Bot::BasicBot';
use HTML::TreeBuilder;
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

sub barget {
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
	$r=`/home/jqk/IRCbots/barget-no-regexp.sh linux 3`;
#	$r=decode ('utf-8',$r);
	$R=barget($r);
	$_[0]->notice(channel => '#linuxbar',body => $R);
}

sub timer2 {
	print "debug:timer2\n";
	$r=`/home/jqk/IRCbots/barget-no-regexp.sh archlinux 3`;
#	$r=decode ('utf-8',$r);
	$R=barget($r);
	$_[0]->notice(channel => '#linuxbar',body => $R);
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

