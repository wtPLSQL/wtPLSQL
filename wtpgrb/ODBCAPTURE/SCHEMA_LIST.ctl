OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "DEVDBA"."SCHEMA_LIST"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (USERNAME                       CHAR(128)
   ,INSTALL_TYPE                   CHAR(10)
   ,TS_SIZE                        CHAR(10)
   ,DIFF_FLAG                      CHAR(1)
   ,NOTES                          CHAR(1024)
   )
