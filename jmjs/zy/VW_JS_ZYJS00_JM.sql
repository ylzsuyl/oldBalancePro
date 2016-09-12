CREATE OR REPLACE VIEW VW_JS_ZYJS00_JM
(fwwdbh, wdjbbh, fzxbh0, nian00, qsrq00, jzrq00, zycs00, sfcs00, xjzfje, zhzfje, jjzfje, zzfje0, fybfy0, fybzh0, dbzhzf, dbgrzf, dbjjzf, zhbyzf, jjbyzf, sbbyzf, tcjjlx)
AS
SELECT
      a.fwwdbh ,
      a.wdjbbh ,
      a.fzxbh0 ,
      a.NIAN00 ,
      a.KSRQI0 ,
      a.JZRQI0 ,
      a.zycs00 ,
      a.sfcs00 ,
      a.xjzfje ,
      a.zhzfje ,
      a.jjzfje ,
      a.zzfje0 ,
      a.FYBFY0 ,
      a.FYBZH0 ,
      a.DBZHZF ,
      a.DBGRZF ,
      a.dbjjzf ,
           0 ,
           0 ,
           0 ,
      b.tcjjlx  --new add by Chenj on 20040322
FROM  JS_ZYJS00 a, bm_tcjjlx b
where a.gzzt00=b.gzzt00 And a.gzzt00>'99' And a.gzzt00<'c1'  And b.gzzt00>'99' And b.gzzt00<'c1'
UNION ALL
SELECT
        fwwdbh , wdjbbh , fzxbh0, NIAN00 ,
        QSRQ00 , JZRQ00 ,      0,      0 ,
       0 , 0 , 0 , 0 , 0 , 0 , 0 ,    0 ,
       0 , ZHBYZF, JJBYZF, SBBYZF,
       tcjjlx
FROM  Js_Yfbyzf_Jm  where JSLX00 = 'Z'
;
