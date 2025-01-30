OPTIONS (SKIP=1)
LOAD DATA
INTO TABLE "ODBCAPTURE"."SCHEMA_CONF"
APPEND
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (USERNAME                       CHAR(128)
   ,BUILD_TYPE                     CHAR(10)
   ,ORACLE_PROVIDED                CHAR(1)
   ,PROFILE                        CHAR(128)
   ,TEMPORARY_TSPACE               CHAR(30)
   ,DEFAULT_TSPACE                 CHAR(30)
   ,TS_QUOTA                       CHAR(10)
   ,NOTES                          CHAR(1024)
   )
