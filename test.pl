#!/usr/bin/perl
use HTML::TreeBuilder;
use Encode;

$r=`/home/jqk/IRCbots/barget-no-regexp.sh linux 3`;
#$r=decode ('utf-8',$r);
$p = HTML::TreeBuilder -> new_from_url($r);
my @title= $p->look_down(_tag=>'h1',class=>'core_title_txt ' )->as_text;
my @author= $p->look_down(_tag=>'li',class=>'d_name' )->as_text;
my @content= $p->look_down(_tag=>'div',class=>'d_post_content j_d_post_content ')->as_text;
print $title[0];
print "\n";
print $author[0];
print "\n";
print $content[0];
