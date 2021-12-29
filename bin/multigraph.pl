#!/usr/bin/perl

my $o;
my @l;


while(<>) {
    if(/^\s*(di)?graph/) {
        push @l, $o;
        $o = '';
    }

    $o .= $_;
}

if($o =~ /graph/) {
    push @l, $o;
}

for(@l) {
    if(fork() == 0) {
        open my $p, '| dot -T x11' or die $!;
        print $p $_;
        close $p;
        exit 0;        
    }
}