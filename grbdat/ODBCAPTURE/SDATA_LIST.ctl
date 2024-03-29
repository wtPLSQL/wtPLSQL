OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "DEVDBA"."SDATA_LIST"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (USERNAME                       CHAR(128)
   ,TABLE_NAME                     CHAR(128)
   ,INSTALL_TYPE                   CHAR(10)
   ,BEFORE_SELECT_SQL              CHAR(4000)
   ,WHERE_CLAUSE                   CHAR(4000)
   ,ORDER_BY_COLUMNS               CHAR(4000)
   ,AFTER_ORDER_BY_SQL             CHAR(4000)
   ,NOTES                          CHAR(1024)
   )
