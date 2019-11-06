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

*Zeilen R code:* 849, *Zeilen Test code:* 0

Packet Info
-----------

**Version**

0.1.0 ( 2019-11-06 01:18:33 )

**Beschreibung**

Ein objektorientierter Ansatz f<c3><bc>r Datenbanken operationen. Data
Access Object (DAO, englisch f<c3><bc>r Datenzugriffsobjekt) ist ein
Entwurfsmuster, das den Zugriff auf unterschiedliche Arten von
Datenquellen (z. B. Datenbanken, Dateisystem) so kapselt, dass die
angesprochene Datenquelle ausgetauscht werden kann, ohne dass der
aufrufende Code ge<c3><a4>ndert werden muss. Dadurch soll die
eigentliche Programmlogik von technischen Details der Datenspeicherung
befreit werden und flexibler einsetzbar sein. Ziel des OOP-Paradigmas
soll eine verbesserte Wartbarkeit und Wiederverwendbarkeit des
statischen Quellcodes sein.

**Lizenz**

<br>Christoph Nitz

**Installation**

Aktuelle Entwicklerversion auf Github:

    devtools::install_github("chrisnice89/rdao")

------------------------------------------------------------------------

Dokumentation
-------------

Für weiterführende Informationen
[Framework](docs/articles/Framework.html) und konkrete Anwendungen.

Klassen
-------

**SqlConnection** : Das Herz und Arbeitstier aller Sql Objekte im
Framework.

**SqlCommand** : x

**SqlResult** : x

**IDiamonds** : Interface zur Businesslogic

**Diamond** : Konkrete Entity

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
    ## <Builder>> for provider: <dbFile> created

    # Optionale Verbindungsparameter einstellen
    b$addCredentials(username = "Admin",password = "SesameOpen")

    ## <Validator> for parent class: <Credentials> created
    ## <Credentials> for User: <Admin> created

    # Verbindung erstellen
    cnn<-b$build()

    ## <Validator> for parent class: <SqlConnection> created
    ## <SqlConnection>> for provider: <dbFile> created

### Abfrage erstellen

    # Abfrage erstellen
    qry<-cnn$createQuery(sql = "Select * FROM diamonds")

    ## <Validator> for parent class: <SqlCommand> created
    ## <SqlCommand> :: <Select * FROM diamonds>
    ## for provider: <dbFile> created

    #Abfrage ausführen
    result<-qry$fetch()

    ## <Validator> for parent class: <SqlResult> created
    ## <SqlCommand> :: <Select * FROM diamonds>
    ## for provider: <dbFile> ausgeführt

    class(result)

    ## [1] "SqlResult" "R6"

    head(result$data)

    ##   carat       cut color clarity depth table price    x    y    z
    ## 1  0.23     Ideal     E     SI2  61.5    55   326 3.95 3.98 2.43
    ## 2  0.21   Premium     E     SI1  59.8    61   326 3.89 3.84 2.31
    ## 3  0.23      Good     E     VS1  56.9    65   327 4.05 4.07 2.31
    ## 4  0.29   Premium     I     VS2  62.4    58   334 4.20 4.23 2.63
    ## 5  0.31      Good     J     SI2  63.3    58   335 4.34 4.35 2.75
    ## 6  0.24 Very Good     J    VVS2  62.8    57   336 3.94 3.96 2.48
