
wtPLSQL 1.2 Release Notes:

Proposed V1.2 Release
* Hooks allow add-ons to attach to basic framework
   * Move all reporting into hooks
   * Move all persistence into hooks
   * Move all code coverage into hooks.
   * Brutally fast JUnit XML reporting
* GUI (Graphical Used Interface) using APEX (Application Express)
   * Trend Analysis
   * Launch Test Runners
   * Test Case and Assertion Drill-Down
   * Code Coverage Drill Down
* Travis-CI integration ??
   * New HTML file based reporting

### Overview
* Assertion results are recorded in memory arrays by Core.
* Assertion results are stored in tables by Persist.
* Code coverage is included in Persist.
* There are 2 versions of JUnit XML reports, one each for Core and Persist.
* There are 2 versions of WT_TEXT_OUTPUT package, one each for Core and Persist.
* The GUI only works with Persist.  Demo works with Core and Persist.
* Major Website Updates (docs directory)

### New Features
* Add-ons have been implemented. The V1.2 source is now split into multiple directories.
* The HOOKS table can be used to implement add-ons.
* A comprehensive GUI has been implemented using Application Express.
* A utPLSQL conversion tool is available.
* The WT_VERIONS table has more detail for add-ons.
* New WT_QUAL_TEST_RUNNERS_VW to list packages that qualify as Test Runners.
* New WT_JOB package and WT_SCHEDULER_JOBS view for executing Test Runners in parallel.
* New TEST_RUNNERS table in Persist for increased normalization.
* Test yield from WT_TEXT_OUTPUT and GUI reports based on test cases instead of assertions.

### Detailed Changes
* Too numerous to list
