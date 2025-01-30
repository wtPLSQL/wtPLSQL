OPTIONS (SKIP=1)
LOAD DATA
INTO TABLE "ODBCAPTURE"."ELEMENT_CONF"
APPEND
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (ELEMENT_SEQ                    FLOAT EXTERNAL
   ,ELEMENT_NAME                   CHAR(20)
   ,FILE_EXT1                      CHAR(6)
   ,FILE_EXT2                      CHAR(6)
   ,FILE_EXT3                      CHAR(6)
   ,OBJECT_TYPE                    CHAR(30)
   ,NAME_CHECK_OBJECT_TYPE         CHAR(30)
   ,PRE_COMPILE                    CHAR(1)
   ,NOTES                          CHAR(1024)
   )
