OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "DEVDBA"."TYPE_LIST"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (INSTALL_TYPE                   CHAR(10)
   ,NOTES                          CHAR(1024)
   ,INSTALL_LEVEL                  FLOAT EXTERNAL
   ,ADD_DML_TRIGGER                CHAR(1)
   )
