OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "ODBCAPTURE"."SCHEMA_CONF"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (USERNAME                       CHAR(128)
   ,INSTALL_TYPE                   CHAR(10)
   ,TS_SIZE                        CHAR(10)
   ,NOTES                          CHAR(1024)
   ,TABLESPACE_NAME                CHAR(30)
   )
