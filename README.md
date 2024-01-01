File::Utils
===========

Table of Contents
-----------------

  * [NAME](#name)

  * [AUTHOR](#author)

  * [VERSION](#version)

  * [TITLE](#title)

  * [SUBTITLE](#subtitle)

  * [COPYRIGHT](#copyright)

  * [Introduction](#introduction)

  * [CorruptFile](#corruptfile)

  * [symbolic-perms(…)](#symbolic-perms)

  * [format-bytes(…)](#format-bytes)

  * [uid2username(…)](#uid2username)

  * [gid2groupname(…)](#gid2groupname)

NAME
====

File::Utils 

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

0.1.2

TITLE
=====

File::Utils

SUBTITLE
========

A Raku module for converting various File system properties to symbolic form.

COPYRIGHT
=========

LGPL V3.0+ [LICENSE](https://github.com/grizzlysmit/File-Utils/blob/main/LICENSE)

[Top of Document](#table-of-contents)

Introduction
============

A **Raku** module for converting various File system properties to symbolic form. For instance **`symbolic-perms(…)`** will give you the **.rwxr-xr-x** type representation of the file type and permissions like used by **`ls`** and **`exa`**. And **`format-bytes(…)`** will convert the file size from bytes **B** to **TiB**, **GiB** etc.

[Top of Document](#table-of-contents)

### CorruptFile

**`CorruptFile`** is an exception class to be used if a corrupt file is encountered. 

```raku
class CorruptFile is Exception is export {
    has Str:D $.msg = 'Error: File is Corrupt';
    method message( --> Str:D) {
        $!msg;
    }
}
```

[Top of Document](#table-of-contents)

### symbolic-perms(…)

A function for producing the **.rwxrwxrwx** form of a files type and permissions like that used by **ls** and **exa**. It also supports colourising and syntax highlighting of the perms.

```raku
sub symbolic-perms(IO::Path $path,
                   Bool:D :$colour is copy = False,
                   Bool:D :$syntax = False, 
                   Bool:D :$highlighted = False, 
                   Bool:D :$cond = False, 
                   Str:D :$highlight-fg-colour = t.color(255, 0, 0), 
                   Str:D :$fg-colour0 = t.color(255, 0, 0), 
                   Str:D :$fg-colour1 = t.color(255, 0, 0) --> Str:D) is export {
```

  * Where

    * **`$path`** Is the path of the file/directory to describe the perms for.

    * **`$colour`** If True colour the perms.

    * **`$syntax`** If true syntax highlight the perms.

    * **`$highlighted`** If true set the text colour to **`$highlight-fg-colour`**.

    * **`$cond`** If not highlighted and True set the text colour to **`$fg-color0`** else set text to **`$fg-color1`**.

    * **`$highlight-fg-colour`** Colour to set the text to if **`$highlighted`**.

    * **`$fg-colour0`** Colour to set the text to if not **`$highlighted`** and **`$cond`**.

    * **`$fg-colour1`** Colour to set the text to if not **`$highlighted`** and not **`$cond`**.

**NB: Only recognises directory, link and regular file just now.**

### format-bytes(…)

Format a number in bytes into **KiB**, **MiB**, **GiB**, **TiB**, …… also appends the **GiB**, **TiB** designator. 

```raku
sub format-bytes(Int:D $bytes, Int:D :$width = 5,
                 Int:D :$precision = 1 --> Str:D) is export
```

### uid2username(…)

A function to convert a numeric **uid** into a **username**, will only work on a typical ***nix** file system requires **/etc/passwd** to exist, and be readable. Will fail if these conditions are not true.

```raku
sub uid2username(UInt:D $uid --> Str:D) is export
```

### gid2groupname(…)

A function to convert a numeric **gid** into a **groupname**, will only work on a typical ***nix** file system requires **/etc/group** to exist, and be readable. Will fail if these conditions are not true.

```raku
sub gid2groupname(UInt:D $gid --> Str:D) is export
```

