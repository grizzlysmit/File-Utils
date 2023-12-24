unit module File::Utils:ver<0.1.1>:auth<Francis Grizzly Smit (grizzlysmit@smit.id.au)>;

=begin pod

=head1 File::Utils

=begin head2

Table of Contents

=end head2

=item1 L<NAME|#name>
=item1 L<AUTHOR|#author>
=item1 L<VERSION|#version>
=item1 L<TITLE|#title>
=item1 L<SUBTITLE|#subtitle>
=item1 L<COPYRIGHT|#copyright>
=item1 L<Introduction|#introduction>
=item1 L<CorruptFile|#corruptfile>
=item1 L<symbolic-perms(…)|#symbolic-perms>
=item1 L<format-bytes(…)|#format-bytes>
=item1 L<uid2username(…)|#uid2username>
=item1 L<gid2groupname(…)|#gid2groupname>

=NAME File::Utils 
=AUTHOR Francis Grizzly Smit (grizzly@smit.id.au)
=VERSION 0.1.1
=TITLE File::Utils
=SUBTITLE A Raku module for converting various File system properties to symbolic form.

=COPYRIGHT
LGPL V3.0+ L<LICENSE|https://github.com/grizzlysmit/File-Utils/blob/main/LICENSE>

L<Top of Document|#table-of-contents>

=head1 Introduction

A B<Raku> module for converting various File system properties to symbolic form. 
For instance B<C<symbolic-perms(…)>> will give you the B<.rwxr-xr-x> type representation
of the file type and permissions like used by B<C<ls>> and B<C<exa>>. 
And B<C<format-bytes(…)>> will convert the file size from bytes B<B> to B<TiB>, B<GiB> etc.

L<Top of Document|#table-of-contents>

=end pod

use Terminal::ANSI::OO :t;
use Gzz::Text::Utils;

=begin pod

=head3 CorruptFile

B<C<CorruptFile>> is an exception class to be used if a corrupt file is encountered. 

=begin code :lang<raku>

class CorruptFile is Exception is export {
    has Str:D $.msg = 'Error: File is Corrupt';
    method message( --> Str:D) {
        $!msg;
    }
}

=end code

L<Top of Document|#table-of-contents>

=end pod

class CorruptFile is Exception is export {
    has Str:D $.msg = 'Error: File is Corrupt';
    method message( --> Str:D) {
        $!msg;
    }
}

=begin pod

=head3 symbolic-perms(…)

A function for producing the B<.rwxrwxrwx> form of a files type and permissions like that used by B<ls> and B<exa>.
It also supports colourising and syntax highlighting of the perms.

=begin code :lang<raku>

sub symbolic-perms(IO::Path $path, Bool:D :$colour is copy = False, Bool:D :$syntax = False) is export

=end code

=end pod

sub symbolic-perms(IO::Path $path, Bool:D :$colour is copy = False, Bool:D :$syntax = False) is export {
    my Str:D $perms = '';
    if $syntax {
        $perms ~= t.color(0, 0, 255);
    } elsif $colour {
        $perms ~= t.color(255, 0, 0);
    }
    if $path ~~ :l {
        $perms ~= 'l';
    } elsif $path ~~ :d {
        $perms ~= 'd';
    } elsif $path ~~ :f {
        $perms ~= '.';
    } else {
        $perms ~= '?';
    }
    my $mode = $path.mode;
    my Int:D $mask = 0b0100_000_000;
    for qw[user group other] -> $groupping {
        for qw[r w x] -> $flag {
            if $syntax {
                given $flag {
                    when 'r' { $perms ~= t.color(255, 255, 0);           }
                    when 'w' { $perms ~= t.color(255, 0, 0); }
                    when 'x' { $perms ~= t.color(0, 0, 255); }
                }
            }
            if $mode +& $mask {
                $perms ~= $flag;
            } else {
                $perms ~= '-';
            }
            $mask +>= 1;
        } # for qw[r w x] -> $flag #
    } # for qw[user group other] -> $groupping #
    return $perms;
} # sub symbolic-perms(IO::Path $path) #

=begin pod

=head3 format-bytes(…)

Format a number in bytes into B<KiB>, B<MiB>, B<GiB>, B<TiB>, ……
also  appends the B<GiB>, B<TiB> designator. 

=begin code :lang<raku>

sub format-bytes(Int:D $bytes, Int:D :$width = 5,
                 Int:D :$precision = 1 --> Str:D) is export 

=end code

=end pod

sub format-bytes(Int:D $bytes, Int:D :$width = 5, Int:D :$precision = 1 --> Str:D) is export {
    if $bytes >= 2 ** 100 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 100).Num), 'QiB';
    } elsif $bytes >= 2 ** 90 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 90).Num), 'RiB';
    } elsif $bytes >= 2 ** 80 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 80).Num), 'YiB';
    } elsif $bytes >= 2 ** 70 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 70).Num), 'ZiB';
    } elsif $bytes >= 2 ** 60 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 60).Num), 'EiB';
    } elsif $bytes >= 2 ** 50 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 50).Num), 'PiB';
    } elsif $bytes >= 2 ** 40 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 40).Num), 'TiB';
    } elsif $bytes >= 2 ** 30 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 30).Num), 'GiB';
    } elsif $bytes >= 2 ** 20 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 20).Num), 'MiB';
    } elsif $bytes >= 2 ** 10 {
        return Sprintf "%-*.*f%s", $width, $precision, ($bytes.Num / (2 ** 10).Num), 'KiB';
    } else {
        return Sprintf "%-*.*f%s", $width, $precision, $bytes, 'B';
    }
} # sub format-bytes(Int:D $bytes --> Str:D) #

=begin pod

=head3 uid2username(…)

A function to convert a numeric B<uid> into a B<username>, will only work on a typical 
B<*nix> file system requires B</etc/passwd> to exist, and be readable. Will fail if
these conditions are not true.

=begin code :lang<raku>

sub uid2username(UInt:D $uid --> Str:D) is export

=end code

=end pod

sub uid2username(UInt:D $uid --> Str:D) is export {
    my @username = "/etc/passwd".IO.slurp().split("\n").grep( { rx/ ^ \w+ ':' <-[:]>+ ':' $uid ':' .* $ / }).map(  {
        ((rx/ ^ ( \w+ ) ':' <-[:]>+ ':' $uid ':' .* $ /) ?? ~$0 !! ~$uid)
    });
    CorruptFile.new(:msg("uid: $uid not found")).throw unless @username.elems == 1;
    return @username[0];
} # sub uid2username(UInt:D $uid --> Str:D) is export #

=begin pod

=head3 gid2groupname(…)

A function to convert a numeric B<gid> into a B<groupname>, will only work on a typical 
B<*nix> file system requires B</etc/group> to exist, and be readable. Will fail if
these conditions are not true.

=begin code :lang<raku>

sub gid2groupname(UInt:D $gid --> Str:D) is export

=end code

=end pod

sub gid2groupname(UInt:D $gid --> Str:D) is export {
    my @groupname = "/etc/group".IO.slurp().split("\n").grep( { rx/ ^ \w+ ':' <-[:]>+ ':' $gid ':' $ / }).map(  {
        ((rx/ ^ ( \w+ ) ':' <-[:]>+ ':' $gid ':' $ /) ?? ~$0 !! ~$gid)
    });
    CorruptFile.new(:msg("gid: $gid not found")).throw unless @groupname.elems == 1;
    return @groupname[0];
} # sub gid2groupname(UInt:D $uid --> Str:D) is export #
