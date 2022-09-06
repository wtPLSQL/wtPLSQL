OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "DEVDBA"."OBJECT_LIST"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (USERNAME                       CHAR(128)
   ,INSTALL_OTYPE                  CHAR(20)
   ,INSTALL_TYPE                   CHAR(10)
   ,ONAME_FILTER                   CHAR(4000)
   ,NOTES                          CHAR(1024)
   )
