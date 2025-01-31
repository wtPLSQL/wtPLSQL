OPTIONS (SKIP=1)
LOAD DATA
INTO TABLE "WTP"."WT_SELF_TEST"
APPEND
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (ID                             FLOAT EXTERNAL
   ,TEMP_CLOB                      CHAR(1048576)
      -- NCLOB data must be decoded with UNISTR after loading
   ,TEMP_NCLOB                     CHAR(5242880)
   ,TEMP_XML                       CHAR(1048576)
      -- BLOB data must be decoded from Base64 after loading
   ,TEMP_BLOB                      CHAR(1572864)
   )
