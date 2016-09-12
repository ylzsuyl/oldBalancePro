CREATE OR REPLACE VIEW VW_JS_UNION0
(fwwdbh, wdjbbh, gzzt00, fzxbh0, sfcs00, zycs00, zyts00, xjzfje, zhzfje, jjzfje, zzfje0, dbzhzf, dbgrzf, dbjjzf, tsxmfy, ybgrfy, fybfy0, fybzh0)
AS
SELECT
     	FWWDBH,  WDJBBH,	GZZT00,  FZXBH0,
     	SFCS00,  0  ,0 ,	XJZFJE,  ZHZFJE,
     	JJZFJE,  ZZFJE0,   DBZHZF,	DBGRZF,
     	DBJJZF,  TSXMFY, YBGRFY, FYBFY0, FYBZH0
FROM	JS_TEMP_ZYFYTJ
UNION all
SELECT
      FWWDBH,  WDJBBH,	GZZT00,  FZXBH0,
      0,       ZYCS00,  ZYTS00,       0,
      0,            0,       0,       0,
      0,            0,       0,       0,
      0,            0
FROM  JS_TEMP_ZYTS;
