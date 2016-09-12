CREATE OR REPLACE VIEW VW_JS_SUM000
(fwwdbh, gzzt00, wdjbbh, fzxbh0, sfcs00, zycs00, zyts00, xjzfje, zhzfje, jjzfje, zzfje0, dbzhzf, dbgrzf, dbjjzf, tsxmfy, ybgrfy, fybfy0, fybzh0)
AS
SELECT
      FWWDBH,          GZZT00,     WDJBBH,     FZXBH0,
      SUM(SFCS00),SUM(ZYCS00),SUM(ZYTS00),SUM(XJZFJE),SUM(ZHZFJE),
      SUM(JJZFJE),SUM(ZZFJE0),SUM(DBZHZF),SUM(DBGRZF),
      SUM(DBJJZF),SUM(TSXMFY),SUM(YBGRFY),SUM(FYBFY0),
      SUM(FYBZH0)
FROM VW_JS_UNION0
GROUP BY FWWDBH,GZZT00,WDJBBH,FZXBH0;
