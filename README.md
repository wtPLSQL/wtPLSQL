# wtPLSQL
Whitebox Testing Framework for Oracle's PL/SQL Language

## History

[Steven Feuerstein Designed and Developed utPLSQL (V1)](http://archive.oreilly.com/pub/a/oreilly/oracle/utplsql/).

[Steven Feuerstein's Recommendations for Unit Testing PL/SQL Programs](http://stevenfeuersteinonplsql.blogspot.com/2015/03/recommendations-for-unit-testing-plsql.html)

[utPLSQL V2 Documentation](https://utplsql.github.io/docs/index.html)

[utPLSQL V3 on GitHub](https://github.com/utPLSQL/utPLSQL)

## Background (Lots of Opinion Here)

Because of his reputation with Oracle's PL/SQL, Steven Feuerstein's utPLSQL has been widely adopted.  However, source code maintenance has become a problem with the latest utPLSQL V2 releases.  Inspection of the V2 source code reveals some very complex code pathways.  Much of this results from the layering of the V1 API on top of the V2 implementation.  There is no documentation on how the V1 layering was intended to work.  There is no documentation on the overall design of the V2 implementation.  There is no documentation on how to use the V2 API.  (Kudos to Paul Walker for an amazing job of maintaining the V2 code set.)  As a result, most all unit tests written with utPLSQL V2 use the V1 APIs.

The utPLSQL V3 project has taken a "clean sheet" approach.  While the complexity of the underlying utPLSQL V2 code set is no longer a problem, V3 is incompatable with V1 and V2.  The V3 project intends to resolve this problem at some point.  Before the "clean sheet" approach was adopted, the V3 team reviewed what has become the [utPLSQL_Lite project](https://github.com/DDieterich/utplsql_lite).  During the development of utPSQL_lite, several aspects of PL/SQL unit testing became obvious:
* Code coverage must be deeply integrated into the design.
* Unit test result storage is critical for large test suites.

## Random Thoughts
* Compatable with utPLSQL V1
* Test anything in the Oracle database
  * Packages, Procedures, and Functions
  * Table Triggers
  * Type Bodies
* Built-in Code Coverage
* Minimal Database Footprint
* Private Procedure/Function Testing
* PL/SQL IDE friendly
  * GUI based editor
  * Automated formatting of query results
  * DBMS_OUTPUT
* Optional Continuous Integration - Hudson/Jenkins
* Optional APEX Integration
* [Whitebox](https://en.wikipedia.org/wiki/White-box_testing) vs. [XUnit](https://martinfowler.com/bliki/Xunit.html) vs. [TDD](http://agiledata.org/essays/tdd.html)
