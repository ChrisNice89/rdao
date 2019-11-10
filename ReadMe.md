-   [Data Access Object (DAO) framework for
    R](#data-access-object-dao-framework-for-r)
    -   [Packet Info](#packet-info)
    -   [Dokumentation](#dokumentation)
    -   [Klassen](#klassen)
    -   [Anwendung](#anwendung)

<!-- README.md is generated from README.Rmd. Please edit that file -->
Data Access Object (DAO) framework for R
========================================

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

*Zeilen R code:* 929, *Zeilen Test code:* 0

Packet Info
-----------

**Version**

0.1.0 ( 2019-11-10 14:42:31 )

**Beschreibung**

Data Access Object (DAO, englisch fuer Datenzugriffsobjekt) ist ein
Entwurfsmuster, das den Zugriff auf unterschiedliche Arten von
Datenquellen (z. B. Datenbanken, Dateisystem) so kapselt, dass die
angesprochene Datenquelle ausgetauscht werden kann, ohne dass der
aufrufende Code geändert werden muss. Dadurch soll die eigentliche
Programmlogik von technischen Details der Datenspeicherung befreit
werden und flexibler einsetzbar sein. Ziel des OOP-Paradigmas soll eine
verbesserte Wartbarkeit und Wiederverwendbarkeit des statischen
Quellcodes sein.

**Lizenz**

All rights reserved by the respective owner <br>Christoph Nitz

**Installation**

Aktuelle Entwicklerversion auf Github:

    devtools::install_github("chrisnice89/rdao")

------------------------------------------------------------------------

Dokumentation
-------------

Für weiterführende Informationen und konkrete Anwendungen:
[Framework](file:///rdao/vignettes/Framework.html)

Klassen
-------

**SqlConnection** : Steuert Verbindung und ist Basis des SqlCommands

**SqlCommand** : Interface für CRUD Operationen

**SqlResult** : Ergebnis einer Abfrage

**IDiamonds** : Interface zur Geschäftslogik (exemplarisch)

**Diamond** : Business entity (exemplarisch)

------------------------------------------------------------------------

Anwendung
---------

**Laden benötigter Pakete**

    # packages
    library(RSQLite)
    library(R6)
    library(rdao)

    ## This package ist created,developed and copyrighted by Christoph Nitz.
    ## Interested parties may contact <Christoph.Nitz89@gmail.com>

### Erstellen einer neuen Verbindung

    # erstellen einer factory
    f<-connectionFactory()

    ## <Validator> for parent class: <SqlFactory> created
    ## <SqlFactory> created

    # Auswahl der Datenquelle und erforderliche Arguemnte übergeben
    b<-f$dbFile("/Users/cnitz/Dev/R/rdao/db files external/Diamonds.db")

    ## <Validator> for parent class: <Builder> created
    ## <Builder> for provider: <dbFile> created

    # Optionale Verbindungsparameter einstellen
    b$addCredentials(username = "Admin",password = "SesameOpen")

    ## <Validator> for parent class: <Credentials> created
    ## <Credentials> for User: <Admin> created

    # Verbindung erstellen
    cnn<-b$build()

    ## <Validator> for parent class: <SqlConnection> created
    ## <SqlConnection>> for provider: <dbFile> created

### Generics

    # Abfrage erstellen
    library(rdao)
    f<-connectionFactory()

    ## <Validator> for parent class: <SqlFactory> created
    ## <SqlFactory> created

    b<-f$dbFile("/Users/cnitz/Dev/R/rdao/db files external/Diamonds.db")

    ## <Validator> for parent class: <Builder> created
    ## <Builder> for provider: <dbFile> created

    cnn<-b$build()

    ## <Validator> for parent class: <SqlConnection> created
    ## <SqlConnection>> for provider: <dbFile> created

    result<-cnn$createQuery(sql = "Select carat,color FROM diamonds LIMIT 10")$fetch()

    ## <Validator> for parent class: <SqlCommand> created
    ## <SqlCommand> :: <Select carat,color FROM diamonds LIMIT 10>
    ## for provider: <dbFile> created 
    ## <Validator> for parent class: <SqlResult> created
    ## <SqlCommand> :: <Select carat,color FROM diamonds LIMIT 10>
    ## for provider: <dbFile> ausgeführt

    ## <SqlConnection>> for provider: <dbFile> Disconnect

    result$countRows()

    ## [1] 10

    m<-result$toMatrix()
    m(i = 1,j=1)

    ## [1] 0.23

    m(2)

    ## data frame with 0 columns and 1 row

    m(1,1:2)

    ##   carat color
    ## 1  0.23     E

    result$setCarat(0.66)
    result$row(1)$setCarat(0.99)
    m(,1:2)

    ## [1] carat color
    ## <0 rows> (or 0-length row.names)

    print(result)

    ## <SqlResult>
    ##   Inherits from: <Generics>
    ##   Public:
    ##     add: function () 
    ##     clone: function (deep = FALSE) 
    ##     countColumns: function () 
    ##     countRows: function () 
    ##     delete: function (rows) 
    ##     getCarat: function () 
    ##     getColor: function () 
    ##     getRecords: function () 
    ##     initialize: function (connection, data) 
    ##     read: function () 
    ##     row: function (i) 
    ##     setCarat: function (value) 
    ##     setColor: function (value) 
    ##     toMatrix: function () 
    ##     update: function () 
    ##   Private:
    ##     .connection: SqlConnection, Abstrakt SqlConnection, Abstarkt SqlResult Interface, R6
    ##     .eod: FALSE
    ##     .shared: environment
    ##     .validator: Validator, R6
    ##     e: environment
    ##     getPointer: function () 
    ##     matrixAccess: function (i = NULL, j = NULL)

    result2<-cnn$createQuery(sql = "Select cut, price, depth FROM diamonds LIMIT 10")$fetch()

    ## <Validator> for parent class: <SqlCommand> created
    ## <SqlCommand> :: <Select cut, price, depth FROM diamonds LIMIT 10>
    ## for provider: <dbFile> created 
    ## <Validator> for parent class: <SqlResult> created
    ## <SqlCommand> :: <Select cut, price, depth FROM diamonds LIMIT 10>
    ## for provider: <dbFile> ausgeführt

    ## <SqlConnection>> for provider: <dbFile> Disconnect

    # Generic
    print(result)

    ## <SqlResult>
    ##   Inherits from: <Generics>
    ##   Public:
    ##     add: function () 
    ##     clone: function (deep = FALSE) 
    ##     countColumns: function () 
    ##     countRows: function () 
    ##     delete: function (rows) 
    ##     getCarat: function () 
    ##     getColor: function () 
    ##     getRecords: function () 
    ##     initialize: function (connection, data) 
    ##     read: function () 
    ##     row: function (i) 
    ##     setCarat: function (value) 
    ##     setColor: function (value) 
    ##     toMatrix: function () 
    ##     update: function () 
    ##   Private:
    ##     .connection: SqlConnection, Abstrakt SqlConnection, Abstarkt SqlResult Interface, R6
    ##     .eod: FALSE
    ##     .shared: environment
    ##     .validator: Validator, R6
    ##     e: environment
    ##     getPointer: function () 
    ##     matrixAccess: function (i = NULL, j = NULL)

    print(result2)

    ## <SqlResult>
    ##   Inherits from: <Generics>
    ##   Public:
    ##     add: function () 
    ##     clone: function (deep = FALSE) 
    ##     countColumns: function () 
    ##     countRows: function () 
    ##     delete: function (rows) 
    ##     getCut: function () 
    ##     getDepth: function () 
    ##     getPrice: function () 
    ##     getRecords: function () 
    ##     initialize: function (connection, data) 
    ##     read: function () 
    ##     row: function (i) 
    ##     setCut: function (value) 
    ##     setDepth: function (value) 
    ##     setPrice: function (value) 
    ##     toMatrix: function () 
    ##     update: function () 
    ##   Private:
    ##     .connection: SqlConnection, Abstrakt SqlConnection, Abstarkt SqlResult Interface, R6
    ##     .eod: FALSE
    ##     .shared: environment
    ##     .validator: Validator, R6
    ##     e: environment
    ##     getPointer: function () 
    ##     matrixAccess: function (i = NULL, j = NULL)
