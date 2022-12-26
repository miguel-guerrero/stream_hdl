unless ($MACROS_INCLUDED) {

    $MACROS_INCLUDED = 1; # include this file only once

    # Sign extend a bus to a given width
    sub sextend {
       my ($in_w, $in_lsb, $var, $out_w) = @_;
       my $in_msb = $in_lsb + $in_w - 1;
       if ($in_w < $out_w) {
          my $extl = $out_w - $in_w;
          return "{ {$extl {$var\[$in_msb]}}, $var\[${in_msb}:${in_lsb}] }";
       }
       elsif ($in_w == $out_w) {
          return "$var\[${in_msb}:${in_lsb}]";
       }
       else {
          my $msb = $in_lsb + $out_w - 1;
          return "$var\[${msb}:${in_lsb}]";
       }
    }

    # Another flavor with simpler API - Sign extend a bus to a given width
    sub sext {
       my ($var, $in_w, $out_w) = @_;
       my $in_lsb = 0;
       return sextend ($in_w, $in_lsb, $var, $out_w);
    }

    # Logicaly (zero) extend a bus to a given width
    sub lextend {
       my ($in_w, $in_lsb, $var, $out_w) = @_;
       my $in_msb = $in_lsb + $in_w - 1;
       if ($in_w < $out_w) {
          my $extl = $out_w - $in_w;
          return "{ $extl\'b0, $var\[${in_msb}:${in_lsb}] }";
       }
       elsif ($in_w == $out_w) {
          return "$var\[${in_msb}:${in_lsb}]";
       }
       else {
          my $msb = $in_lsb + $out_w - 1;
          return "$var\[${msb}:${in_lsb}]";
       }
    }

    # Another flavor with simpler API - Logicaly (zero) extend a bus to a given width
    sub lext {
       my ($var, $in_w, $out_w) = @_;
       my $in_lsb = 0;
       return lextend ($in_w, $in_lsb, $var, $out_w);
    }

    #select a range out of a variable given lsb and width
    sub bit_select {
       my ($width, $lsb, $var) = @_;
       my $msb = $lsb + $width - 1;
       return "$var\[${msb}:${lsb}]";
    }

    #output the minimum of 2 values
    sub min {
       my ($a, $b) = @_;
       if ($a < $b) { return $a; }
       return $b;
    }

    #output the maximum of 2 values
    sub max {
       my ($a, $b) = @_;
       if ($a > $b) { return $a; }
       return $b;
    }

    #output the maximum of 3 values
    sub max3 {
       my ($a, $b, $c) = @_;
       if (($a >= $b) && ($a >= $c)) 
         { return $a; }
       elsif (($b >= $a) && ($b >= $c)) 
         { return $b; }
       else { return $c; } 
    }

    #Output the maximum element of an array
    sub max_element {
       my($max) = pop(@_);
       foreach my $foo (@_) {
          $max = $foo if $max <= $foo;
       }
       return $max;
    }

    # 0 log2=0.000000 clog2=ceil_log2=-1.000000
    # 1 log2=1.000000 clog2=ceil_log2=0.000000
    # 2 log2=2.000000 clog2=ceil_log2=1.000000
    # 3 log2=2.000000 clog2=ceil_log2=2.000000
    # 4 log2=3.000000 clog2=ceil_log2=2.000000
    # 5 log2=3.000000 clog2=ceil_log2=3.000000
    # 6 log2=3.000000 clog2=ceil_log2=3.000000
    # 7 log2=3.000000 clog2=ceil_log2=3.000000
    # 8 log2=4.000000 clog2=ceil_log2=3.000000
    # 9 log2=4.000000 clog2=ceil_log2=4.000000
    # 10 log2=4.000000 clog2=ceil_log2=4.000000
    # 11 log2=4.000000 clog2=ceil_log2=4.000000
    # 12 log2=4.000000 clog2=ceil_log2=4.000000
    # 13 log2=4.000000 clog2=ceil_log2=4.000000
    # 14 log2=4.000000 clog2=ceil_log2=4.000000
    # 15 log2=4.000000 clog2=ceil_log2=4.000000
    # 16 log2=5.000000 clog2=ceil_log2=4.000000

    # equivalent to ceil_log2(x+1)
    # bits necessay to hold the value passed-in other than for 0 that it returns 0
    sub log2 { 
        my ($x)=@_; 
        my $y=0; 
        while ($x != 0) { 
            $x=$x>> 1; 
            $y++; 
        } 
        $y; 
    }

    sub clog2 { 
        my ($x)=@_; 
        if ($x <= 0) { 
            return -1; 
        }
        return log2($x-1);
    }

    use POSIX;
    sub ceil_log2 { 
        my ($x)=@_; 
        if ($x <= 0) { 
            return -1; 
        }
        my $y=ceil(log($x)/log(2.0));
        $y; 
    }

    sub get_array_byname {
        my ($array_name)  = @_;
        return @${array_name};
    }

    sub get_val {
        my ($var_name) = @_;
        return ${$var_name};
    }

}

# some defaults
my $g_clk = "clk";
my $g_rst = "rst_n";
my $g_rst_pol = "~";
my $g_rst_async = "negedge";

sub set_clk         { $g_clk = $_ }
sub set_reset       { $g_rst = $_ }
sub set_reset_pol   { $g_rst_pol = $_ }
sub set_reset_async { $g_rst_async = $_ }
sub set_reset_val   { my ($sig, $val) = @_; $g_rst_val{$sig} = $val }


sub flop_with_reset {
    my ($x_r, $x_c, $x_rst_val) = @_;
    $x_c = "${x}_c"     unless defined $x_c;
    $x_rst_val = "1'b0" unless defined $g_rst_val{$x_r};
print<<EOM
reg $x_r;
always @(posedge $g_clk or $g_rst_async $g_rst) begin
   if (${g_rst_pol}${g_rst})
      $x_r <= $x_rst_val;
   else
      $x_r <= $x_c;
end
EOM
}

sub cond_term {
    my ($cond, $expr) = @_;
    if (defined $cond && $cond != 0) {
        return $expr;
    }
    return "";
}

sub or_reduce {
    my ($dst, @sig_list) = @_;
    print    "assign $dst = 1'b0\n";
    foreach my $sig (@sig_list) {
       $sig =~ s/^\s+//;
       $sig =~ s/\s+$//;
       print "            | $sig\n" unless $sig eq "";
    }
    print    "            ;\n";
}

sub and_reduce {
    my ($dst, @sig_list) = @_;
    print    "assign $dst = 1'b1\n";
    foreach my $sig (@sig_list) {
       $sig =~ s/^\s+//;
       $sig =~ s/\s+$//;
       print "            | $sig\n" unless $sig eq "";
    }
    print    "            ;\n";
}

# Samples of use
#
# $x=&sextend(10, 2, x, 20);
# print "$x\n";
# $x=&sextend(10, 2, x, 10);
# print "$x\n";
# $x=&sextend(10, 2, x, 3);
# print "$x\n";

