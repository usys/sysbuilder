#!/usr/bin/perl
#use bytes;
use constant {MAXREAD => 512};
use Data::Dumper;
my @field = qw/oem bs sc rs fat re s md sf st h hs ls pdn ch sig id vol sys/;
my %mbr = (
    $field[0]=>["OEMID","STR",0x03,8],
    $field[1]=>["Bytes Per Sector","INT",0x0B,2],
    $field[2]=>["Sectors Per Cluster","INT",0x0D,1],
    $field[3]=>["Reserved Sectors","INT",0x0E,2],
    $field[4]=>["FATs","INT",0x10,1],
    $field[5]=>["Root Entries","INT",0x11,2],
    $field[6]=>["Small Sectors","INT",0x13,2],
    $field[7]=>["Media Descriptor","HEX",0x15,1],
    $field[8]=>["Sectors Per FAT","INT",0x16,2],
    $field[9]=>["Sectors Per Track","INT",0x18,2],
    $field[10]=>["Heads","INT",0x1A,2],
    $field[11]=>["Hidden Sectors","INT",0x1C,4],
    $field[12]=>["Large Sectors","INT",0x20,4],
    $field[13]=>["Physical Drive Number","INT",0x24,1],
    $field[14]=>["Current Head","INT",0x25,1],
    $field[15]=>["Signature","INT",0x26,1],
    $field[16]=>["ID","STR",0x27,4],
    $field[17]=>["Volume Label","STR",0x2B,11],
    $field[18]=>["System ID","STR",0x36,8]
);

sub hexdump {
    my @result;
    my $length = scalar(@_);
    push @result,"       0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n";;
    for(my $i = 0;$i<$length;$i+=16) {
        my $count = $i + 16 >= $length ? $length - 1 : $i + 15;
        my @lines = @_[$i..$count];
        push @result,sprintf("%03X0  ",$i/16); 
        push @result,sprintf("%02X "x16,@lines);
        push @result,map {/[\p{IsGraph} ]/ ? $_ : "." } map chr,@lines;
        push @result,"\n";
    }
    push @result,"       0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n";;
    return @result;
}


sub getvalue {
    my $src = shift;
    my $fn  = shift;
    my $type= $mbr{$fn}->[1];
    my $idx = $mbr{$fn}->[2];
    my $len = $mbr{$fn}->[3];
#    print STDERR Dumper($mbr{$fn}),"\n";
    my @data= @{$src}[$idx..$idx+$len-1];
    my $i=0;
    my $result;
    if($type eq "HEX") {
        for($i..($len-1)) {
            $result = sprintf("%02X",$data[$_]) . $result; 
        }
    }
    elsif($type eq "STR") {
        $result = join("",map chr,@data);
    }
    else {
        for($i..($len-1)) {
            $result = $result + $data[$_]*(256**$_);
        }
    }
    return $result;
}
sub setvalue {
    my $dst = shift;
    my $fn  = shift;
    my $value = shift;
    my $type= $mbr{$fn}->[1];
    my $idx = $mbr{$fn}->[2];
    my $len = $mbr{$fn}->[3];
#    print STDERR Dumper($mbr{$fn}),"\n";
    my @data= @{$dst}[$idx..$idx+$len-1];
    my $i=0;
    my $result;
    if($type eq "HEX") {
        $value  = hex($value);
        $type = "INT";
    }
    if($type eq "STR") {
        @data = map ord,split("",substr($value . " "x$len,0,$len));
    }
    else {
        @data = ();
        for($i..($len-1)) {
            my $low = $value % 256;
            $value = $value / 256;
            push @data,$low;
        }
    }
    @{$dst}[$idx..$idx+$len-1]=@data;
    return @data;
}

my $bytes = "";
while(<>) {
    $bytes .= $_;
    last if(length($byte)>MAXREAD);
}
$bytes = substr($bytes,0,MAXREAD);
my @bytes = map ord,split("",$bytes);


setvalue(\@bytes,"oem","MYPL");
setvalue(\@bytes,"sys","FAT12");
setvalue(\@bytes,"bs",1024);
#display_info(@bytes);
foreach(@field) {
    printf "%28s : ",$mbr{$_}->[0];
    print getvalue(\@bytes,$_),"\n";
}
print hexdump(@bytes);
    
