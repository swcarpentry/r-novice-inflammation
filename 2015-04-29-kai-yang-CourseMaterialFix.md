---
date: 2015-04-29
round: Round 12
title: A fix in course material
author: Kai Yang
permalink: /2015/04/kai-yang-fix-on-course-material-R/
tags:
  - Fix
  - Bug
  - Lesson
  - R
---

I suggest to suppy "ignore.case=TRUE" in callings of "sub" function in the section entitled "Making choice" within R course material.

The R function "sub" is used there to substitute the filename ending "csv" with "pdf". In Windows platforms, since file names are case insensitive, users are free to use capital letters. Unfortunately, pattern strings in "sub" function are case sensitive by default. So, it is necessary to accomodate the scenario of having capital letters in file name extension by supplying the argument value of "ignore.case=TRUE". 
