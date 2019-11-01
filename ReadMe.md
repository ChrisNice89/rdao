-   [Object orientated framework around database
    actions](#object-orientated-framework-around-database-actions)
    -   [Package Info](#package-info)
    -   [Classes](#classes)
    -   [Usage](#usage)

<!-- README.md is generated from README.Rmd. Please edit that file -->
Object orientated framework around database actions
===================================================

**Status**

[![Project Status:
WIP.](https://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
<a href="https://travis-ci.org/chrisnice89/rdao">
<img src="https://api.travis-ci.org/chrisnice89/rdao.svg?branch=master">
<a/> <a href="https://cran.r-project.org/package=rdao">
<img src="http://www.r-pkg.org/badges/version/rdao"> </a> [![cran
checks](https://cranchecks.info/badges/summary/reshape)](https://cran.r-project.org/web/checks/check_results_reshape.html)
<a href="https://codecov.io/gh/chrisnice89/rdao">
<img src="https://codecov.io/gh/chrisnice89/rdao/branch/master/graph/badge.svg" alt="Codecov" />
</a> <img src="http://cranlogs.r-pkg.org/badges/grand-total/rdao">
<img src="http://cranlogs.r-pkg.org/badges/rdao">

*lines of R code:* 352, *lines of test code:* 0

Package Info
------------

**Version**

0.1.0 ( 2019-11-01 16:59:44 )

**Description**

A object orientated (R6 classes) framework around databases that
provides classes for simple CRUD actions (methods around SQL verbs) …
and many more.

**License**

All rights reserved by the respective owner <br>Christoph Nitz

**Installation**

Latest development version from Github:

    devtools::install_github("chrisnice89/rdao")

------------------------------------------------------------------------

Classes
-------

**SqlFactory** : Factory.

**SqlCommand** : A representation of a database within R. The object
allows to get information about the database and objects stored in it
(tables and such), to retrieve objects from it, and to manipulate it via
queries and convenience methods.

**SqlConnection** : The heart and work horse of all Sql objects and
responsible for the actual information flow between R and the database
with methods for connect, disconnect, reconnect, querying, and
manipulating the database.

**SqlTable** : A representation of a database table with particular
methods to interact with tables - create, delete, append, copy,
retrieve, filter, peak, and update.

------------------------------------------------------------------------

Usage
-----

**loading packages**

    # packages
    library(RSQLite)
    library(R6)
    library(rdao)

    ## This package ist created,developed and copyrighted by Christoph Nitz.
    ## Interested parties may contact <Christoph.Nitz89@gmail.com>

### Creating New Connection Object

    # creating SqlConnection object
    f<-factory()

    ## <Validator> for parent class: <sqlFactory> created
    ## <sqlFactory> created

    b<-f$msAccess(path = "mypath_AccessDB")

    ## <Builder> created

    # some optional arguments for db access if required
    b$addCredentials(username = "Admin",password = "SesameOpen")

    ## <Validator> for parent class: <Credentials> created
    ## <Credentials> for User: <Admin> created

    # create
    cnn<-b$build()

    ## <Validator> for parent class: <SqlConnection> created
    ## <SqlConnection> created

### Get Connection Infos

    # connection infos
    # some code

### Creating New Command Object

    # create command
    # some code
