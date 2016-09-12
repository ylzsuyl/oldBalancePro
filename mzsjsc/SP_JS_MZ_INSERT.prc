CREATE OR REPLACE PROCEDURE SP_JS_MZ_INSERT
(
  PI_NIAN00  IN  VARCHAR,
  PI_YF0000   IN  VARCHAR,
  PI_FWWDBH   IN VARCHAR,
  PI_WDJBBH  IN VARCHAR,
  PI_QSRXM0   IN VARCHAR,
  PO_RET  OUT NUMBER
)IS
   LS_QSRQ     CHAR(8); --清算日期
   LS_BJRQ00   CHAR(8); --
   LS_QSRQ00   CHAR(8);  --结算起始日期
   LS_JZRQ00   CHAR(8);  --结算截止日期
   ld_cnt1  number;
   ld_cnt2 number;
   V_SQLERRM  VARCHAR2(512);
   INS_JS_MZJS00_ERR  EXCEPTION;
   INS_JS_TSMZJS_ERR  EXCEPTION;
   UPD_YY_MZGHB0_ERR  EXCEPTION;
   UPD_YY_MZSFB0_ERR  EXCEPTION;
BEGIN
   delete from JS_SCYFSJ_LOG
      where nian00 = pi_nian00 AND yf0000 = pi_yf0000 AND fwwdbh = pi_fwwdbh and jslx00='MZ';
  COMMIT;
  --SET TRANSACTION USE ROLLBACK SEGMENT JF_RBS;
  sp_js_qs2jz0(pi_nian00,pi_yf0000,ls_qsrq00,ls_jzrq00);
  --执行结算包参数,得到起始日期和截止日期
  SELECT TO_CHAR(SYSDATE,'YYYYMMDD') INTO LS_QSRQ FROM DUAL;
  LS_BJRQ00 := SUBSTR(LS_QSRQ00,1,6)||'05' ;
  BEGIN
    INSERT INTO JS_MZJS00 --<清算日期>--
    (  NIAN00,  YF0000,  QSRQI0,  FWWDBH,
       WDJBBH,  GZZT00,  FZXBH0,  KSRQI0,
       JZRQI0,  MZCS00,  SFCS00,  XJZFJE,
       ZHZFJE,  JJZFJE,  ZZFJE0,  TSXMFY,
                   YBGRFY,  FYBFY0,  FYBZH0,
                   DBZHZF,   DBGRZF,   DBJJZF,   DBZZF0,
       QSRXM0
    )
    SELECT
           PI_NIAN00, PI_YF0000, LS_QSRQ, PI_FWWDBH,
          PI_WDJBBH, GZZT00,     FZXBH0, LS_QSRQ00,
          LS_JZRQ00,  MZCS00,   SFCS00,   XJZFJE,
      ZHZFJE,  JJZFJE,  ZZFJE0,  TSXMFY,
                 YBGRFY,  FYBFY0,  FYBZH0,
          DBZHZF, DBGRZF, DBJJZF,  DBZHZF + DBGRZF + DBJJZF,
      PI_QSRXM0
     FROM  JS_TEMP_MZFYTJ
     WHERE FWWDBH = PI_FWWDBH;
   EXCEPTION WHEN OTHERS THEN
     V_SQLERRM := SQLERRM;
     RAISE INS_JS_MZJS00_ERR;
  END;
   --mod by Chenj on 20050329
   --由前台来判断处理
   --BEGIN  --清空临时表数据
   --  DELETE FROM JS_TSMZJS
   --   WHERE FWWDBH = PI_FWWDBH  and
   --         nian00 = pi_nian00 and yf0000 = pi_yf0000;
   --EXCEPTION WHEN OTHERS THEN
   --  V_SQLERRM := SQLERRM;
   --END;
  BEGIN
    INSERT INTO JS_TSMZJS --<清算日期>--
    (  NIAN00,  YF0000,  QSRQI0,  FWWDBH,
       WDJBBH,  GZZT00,  FZXBH0,  KSRQI0,
       JZRQI0,  TSMZCS,  SFCS00,  XJZFJE,
       ZHZFJE,  JJZFJE,  ZZFJE0,  TSXMFY,
                   YBGRFY,  FYBFY0,  FYBZH0,
                   DBZHZF,   DBGRZF,   DBJJZF,   DBZZF0,
       QSRXM0
    )
    SELECT
           PI_NIAN00,   PI_YF0000, LS_QSRQ, PI_FWWDBH,
          PI_WDJBBH,   GZZT00,     FZXBH0,  LS_QSRQ00,
          LS_JZRQ00,  TSMZCS,   SFCS00,   XJZFJE,
      ZHZFJE,  JJZFJE,  ZZFJE0,  TSXMFY,
                 YBGRFY,  FYBFY0,  FYBZH0,
          DBZHZF, DBGRZF, DBJJZF,  DBZHZF + DBGRZF + DBJJZF,
      PI_QSRXM0
     FROM  JS_TEMP_TSFYTJ
     WHERE FWWDBH = PI_FWWDBH;
   EXCEPTION WHEN OTHERS THEN
     V_SQLERRM := SQLERRM;
     RAISE INS_JS_TSMZJS_ERR;
  END;
   ---2004/12/23 add
   select count(*) into ld_cnt1 from JS_MZJS00
      where nian00 = pi_nian00 and yf0000 = pi_yf0000 and fwwdbh = pi_fwwdbh;
   select count(*) into ld_cnt2 from JS_TSMZJS
      where nian00 = pi_nian00 and yf0000 = pi_yf0000 and fwwdbh = pi_fwwdbh;
   if  ld_cnt1 = 0 and ld_cnt2 = 0  then
      PO_RET := -7000;
      rollback;
      return;
   end if;
   -- 打[门诊收费表]及[门诊挂号表]标记
   -- 设置清算日期、清算人
  BEGIN
     UPDATE YY_MZGHB0 A
      SET A.QSRQ00 = LS_BJRQ00, --结算日期标记
        A.QSRXM0 = PI_QSRXM0
      WHERE a.fwwdbh = PI_FWWDBH AND a.ghrq00 <= LS_JZRQ00 and
          A.MZLSH0 =
         (
            SELECT DISTINCT B.MZLSH0
            FROM   YY_MZSFB0 B
            WHERE  B.FWWDBH = PI_FWWDBH AND
                   A.MZLSH0 = B.MZLSH0 AND
                   B.SFRQ00 BETWEEN LS_QSRQ00 AND LS_JZRQ00
         );
   EXCEPTION WHEN OTHERS THEN
     V_SQLERRM := SQLERRM;
     RAISE UPD_YY_MZGHB0_ERR;
  END;
  --设置门诊收费表标记
  BEGIN
    UPDATE YY_MZSFB0
    SET    QSRQ00 = LS_BJRQ00, -- 结算日期标记
            QSRXM0 = PI_QSRXM0
    WHERE  FWWDBH = PI_FWWDBH AND
            SFRQ00 BETWEEN LS_QSRQ00 AND LS_JZRQ00;
   EXCEPTION WHEN OTHERS THEN
     V_SQLERRM := SQLERRM;
     RAISE UPD_YY_MZSFB0_ERR;
  END;
  insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
              values(pi_nian00,pi_yf0000,pi_fwwdbh,'MZ',1,pi_qsrxm0);
  COMMIT;
  PO_RET := 0;
EXCEPTION
  WHEN INS_JS_MZJS00_ERR THEN
     ROLLBACK;
     PO_RET := -7111;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'插入门诊结算表数据出错!',V_SQLERRM,'SP_JS_MZ_INSERT',PI_FWWDBH,PI_QSRXM0);
    insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
        values(pi_nian00,pi_yf0000,pi_fwwdbh,'MZ',-1,pi_qsrxm0);
     COMMIT;
  WHEN INS_JS_TSMZJS_ERR THEN
     ROLLBACK;
     PO_RET := -7112;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'插入特诊结算表数据出错!',V_SQLERRM,'SP_JS_MZ_INSERT',PI_FWWDBH,PI_QSRXM0);
    insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
        values(pi_nian00,pi_yf0000,pi_fwwdbh,'MZ',-1,pi_qsrxm0);
     COMMIT;
  WHEN UPD_YY_MZGHB0_ERR THEN
     ROLLBACK;
     PO_RET := -7113;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'标记门诊挂号表结算日期出错!',V_SQLERRM,'SP_JS_MZ_INSERT',PI_FWWDBH,PI_QSRXM0);
     insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
        values(pi_nian00,pi_yf0000,pi_fwwdbh,'MZ',-1,pi_qsrxm0);
     COMMIT;
  WHEN UPD_YY_MZSFB0_ERR THEN
     ROLLBACK;
     PO_RET := -7114;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'标记门诊收费表结算日期出错!',V_SQLERRM,'SP_JS_MZ_INSERT',PI_FWWDBH,PI_QSRXM0);
    insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
        values(pi_nian00,pi_yf0000,pi_fwwdbh,'MZ',-1,pi_qsrxm0);
     COMMIT;
  WHEN OTHERS THEN
    V_SQLERRM := SQLERRM;
    ROLLBACK;
    PO_RET := -7115;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'门诊结算出现其它错误!',V_SQLERRM,'SP_JS_MZ_INSERT',PI_FWWDBH,PI_QSRXM0);
    insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
        values(pi_nian00,pi_yf0000,pi_fwwdbh,'MZ',-1,pi_qsrxm0);
     COMMIT;
END SP_JS_MZ_INSERT;
/
