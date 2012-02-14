---
layout: post
title: Basics of Perl web portals
tags:
- perl
- programming
status: publish
type: post
published: true
meta: {}
---
<a href="http://www.ibm.com/developerworks/aix/library/au-perlweb_revision/index.html?ca=drs-">Basics of Perl web portals</a>.
<blockquote>Summary: Perl is a powerful scripting language that can be used to perform small operations from the command line or power a complete web portal. Understanding techniques for making safe and secure Perl CGI scripts is vital to developing a web portal that does not compromise the integrity of a server or the web site's data. This article explains several techniques that will help developers create secure Perl CGI scripts and handle errors, before looking at a simpler method for building web applications like portals using the Plack system.</blockquote>
carp()は最近覚えたので個人的にはホット。 モジュール内ではdie()は使ってはダメだとおもっていたがcarpを使うとしっくりくる、のかな。
