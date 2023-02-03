---
ref: finding-weak-active-directory-passwords
title: Finding Weak Active Directory Passwords
date: 2017-01-11T21:43:55+00:00
layout: post
lang: en
image: /assets/images/thycotic_report1.png
permalink: /en/finding-weak-active-directory-passwords/
---

I recently worked with&nbsp;[Thycotic](https://thycotic.com/) to&nbsp;create a&nbsp;program called [Weak Password Finder for&nbsp;Active Directory](https://thycotic.com/solutions/free-it-tools/weak-password-finder/weak-password-finder-nvlss/). The&nbsp;goal was to&nbsp;develop a&nbsp;tool that&nbsp;would be&nbsp;very easy to&nbsp;use yet&nbsp;powerful enough to&nbsp;yield actionable results. I&nbsp;think that&nbsp;this&nbsp;combination really makes it&nbsp;unique in&nbsp;the&nbsp;market. It&nbsp;basically does the&nbsp;same as&nbsp;my [PowerShell module](/en/auditing-active-directory-password-quality/), but&nbsp;with&nbsp;a&nbsp;nice and&nbsp;shiny user interface:

![Screenshot 1](../../assets/images/scanner_screen01.png)

<!--more-->

![Screenshot 2](../../assets/images/scanner_screen03.png)

![Screenshot 3](../../assets/images/scanner_screen04.png)

It generates reports which&nbsp;are&nbsp;suitable for&nbsp;the&nbsp;management:

![Report 1](../../assets/images/thycotic_report1.png)

![Report 2](../../assets/images/thycotic_report2.png)

Of course, you can also drill down through the&nbsp;detailed data:

![CSV Report](../../assets/images/thycotic_spreadsheet.png)

Here is&nbsp;a&nbsp;quick demo of&nbsp;the&nbsp;tool:

{% include vimeo.html id="197521549" title="Weak Password Finder Demo" %}

Did I&nbsp;mention that&nbsp;the&nbsp;[Weak Password Finder](https://thycotic.com/solutions/free-it-tools/weak-password-finder/weak-password-finder-nvlss/) is&nbsp;totally free?
