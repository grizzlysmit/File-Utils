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

NAME
====

File::Utils 

AUTHOR
======

Francis Grizzly Smit (grizzly@smit.id.au)

VERSION
=======

0.1.3

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

