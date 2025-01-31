OPTIONS (SKIP=1)
LOAD DATA
INTO TABLE "ODBCAPTURE"."DLOAD_CONF"
APPEND
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (USERNAME                       CHAR(128)
   ,TABLE_NAME                     CHAR(128)
   ,BUILD_TYPE                     CHAR(10)
   ,ORDER_BY_COLUMNS               CHAR(4000)
   ,LOADING_METHOD                 CHAR(50)
   ,BEFORE_SELECT_SQL              CHAR(4000)
   ,COLUMNS_REMOVED                CHAR(4000)
   ,WHERE_CLAUSE                   CHAR(4000)
   ,AFTER_ORDER_BY_SQL             CHAR(4000)
   ,NOTES                          CHAR(4000)
   )
