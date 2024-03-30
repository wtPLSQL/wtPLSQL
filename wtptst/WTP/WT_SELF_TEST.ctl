OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "WTP"."WT_SELF_TEST"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (ID                             FLOAT EXTERNAL
   ,TEMP_CLOB                      CHAR(1048576)
   ,TEMP_NCLOB                     CHAR(1048576)
   ,TEMP_XML                       CHAR(1048576)
      -- BLOB data must be decoded from Base64 after loading
   ,TEMP_BLOB                      CHAR(1572864)
   )
