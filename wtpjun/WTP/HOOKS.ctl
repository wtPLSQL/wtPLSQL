OPTIONS (SKIP=1)
LOAD DATA
APPEND INTO TABLE "WTP"."HOOKS"
FIELDS CSV WITH EMBEDDED
TRAILING NULLCOLS
   (HOOK_NAME                      CHAR(20)
   ,SEQ                            FLOAT EXTERNAL
   ,RUN_STRING                     CHAR(4000)
   ,DESCRIPTION                    CHAR(1000)
   )
