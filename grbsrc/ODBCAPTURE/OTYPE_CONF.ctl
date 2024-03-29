OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "ODBCAPTURE"."OTYPE_CONF"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (INSTALL_OTYPE                  CHAR(20)
   ,INSTALL_ORDER                  FLOAT EXTERNAL
   ,EXT                            CHAR(6)
   ,EXT2                           CHAR(6)
   ,EXT3                           CHAR(6)
   ,NAME_CHECK_OTYPE               CHAR(30)
   ,NOTES                          CHAR(1024)
   ,OBJECT_TYPE                    CHAR(30)
   )
