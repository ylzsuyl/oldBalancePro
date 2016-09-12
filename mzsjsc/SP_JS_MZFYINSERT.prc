CREATE OR REPLACE PROCEDURE SP_JS_MZFYINSERT
(
  PI_FWWDBH  IN CHAR,
  PI_CZY000  IN CHAR,
  PO_RET OUT NUMBER
)
IS
  V_SQLERRM   VARCHAR2(512);
  DEL_MZFYTJ_ERR  EXCEPTION;
  INS_MZFYTJ_ERR  EXCEPTION;
  INS_TSFYTJ_ERR  EXCEPTION;
BEGIN
  COMMIT;
  --SET TRANSACTION USE ROLLBACK SEGMENT JF_RBS;
  BEGIN  --�����ʱ������
    --DELETE FROM JS_TEMP_MZFYTJ WHERE FWWDBH like pi_fwwdbh||'%';
    --DELETE FROM JS_TEMP_TSFYTJ WHERE FWWDBH like pi_fwwdbh||'%';
    DELETE FROM JS_TEMP_MZFYTJ WHERE FWWDBH = pi_fwwdbh;
    DELETE FROM JS_TEMP_TSFYTJ WHERE FWWDBH = pi_fwwdbh;
    --add by Chenj on 20050328
    --�ѹҺź��շѱ��ԭ�ȵ��������ڱ����գ��Է�ֹ���¼���ʱ���ַ���ͳ�Ƶ���©
    /*
    UPDATE YY_MZGHB0
         set   qsrq00 = null
    where fwwdbh like pi_fwwdbh||'%' and qsrq00 in (select substr(qsrq00,1,6)||'05' from vw_js_arg);
    UPDATE YY_MZSFB0
       set   qsrq00 = null
    where fwwdbh like pi_fwwdbh||'%' and qsrq00 in (select substr(qsrq00,1,6)||'05' from vw_js_arg);
    */
    UPDATE YY_MZGHB0
         set   qsrq00 = null,QSRXM0 = null
    where fwwdbh = pi_fwwdbh and qsrq00 in (select substr(qsrq00,1,6)||'05' from JS_ARG_RIQI00 --vw_js_arg
      );
    UPDATE YY_MZSFB0
       set   qsrq00 = null,QSRXM0 = null
    where fwwdbh = pi_fwwdbh and qsrq00 in (select substr(qsrq00,1,6)||'05' from JS_ARG_RIQI00 --vw_js_arg
    );

  EXCEPTION WHEN OTHERS THEN
    V_SQLERRM := SQLERRM;
    RAISE DEL_MZFYTJ_ERR;
  END;
  BEGIN --�������������ʱͳ�Ʊ�
    /*
    INSERT INTO JS_TEMP_MZFYTJ
    (  FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
       MZCS00,  SFCS00,
          XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
          TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
          DBZHZF,  DBGRZF,  DBJJZF
    )
    SELECT   FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
             MZCS00,  SFCS00,
          XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
          TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
                DBZHZF,  DBGRZF,  DBJJZF
    FROM VW_JS_MZFYTJ
    WHERE FWWDBH like pi_fwwdbh||'%';
    */
    INSERT INTO JS_TEMP_MZFYTJ
    (  FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
       MZCS00,  SFCS00,
          XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
          TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
          DBZHZF,  DBGRZF,  DBJJZF
    )
    SELECT   FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
             MZCS00,  SFCS00,
          XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
          TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
                DBZHZF,  DBGRZF,  DBJJZF
    FROM VW_JS_MZFYTJ
    WHERE FWWDBH = pi_fwwdbh;

  EXCEPTION WHEN OTHERS THEN
    V_SQLERRM := SQLERRM;
    RAISE INS_MZFYTJ_ERR;
  END;
  BEGIN--�����������������ʱͳ��
    /*
    INSERT INTO JS_TEMP_TSFYTJ
    (  FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
            TSMZCS,  SFCS00,
      XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
      TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
               DBZHZF,  DBGRZF,  DBJJZF
    )
    SELECT   FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
            TSMZCS,  SFCS00,
      XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
      TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
               DBZHZF,  DBGRZF,  DBJJZF
    FROM VW_JS_TSMZFYTJ
    WHERE FWWDBH like pi_fwwdbh||'%';
    */
    INSERT INTO JS_TEMP_TSFYTJ
    (  FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
            TSMZCS,  SFCS00,
      XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
      TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
               DBZHZF,  DBGRZF,  DBJJZF
    )
    SELECT   FWWDBH,  GZZT00,  WDJBBH,  FZXBH0,
            TSMZCS,  SFCS00,
      XJZFJE,  ZHZFJE,  JJZFJE,  ZZFJE0,
      TSXMFY,  YBGRFY,  FYBFY0,  FYBZH0,
               DBZHZF,  DBGRZF,  DBJJZF
    FROM VW_JS_TSMZFYTJ
    WHERE FWWDBH = pi_fwwdbh;
  EXCEPTION WHEN OTHERS THEN
    V_SQLERRM := SQLERRM;
    RAISE INS_TSFYTJ_ERR;
  END;
  PO_RET := 0;
EXCEPTION
  WHEN DEL_MZFYTJ_ERR THEN
     PO_RET := -7101;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'�����ʱ�����ݳ���!',V_SQLERRM,'SP_JS_MZFYINSERT',PI_FWWDBH,PI_CZY000);
    COMMIT;
  WHEN INS_MZFYTJ_ERR THEN
     PO_RET := -7102;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'�������������ʱͳ�Ʊ����!',V_SQLERRM,'SP_JS_MZFYINSERT',PI_FWWDBH,PI_CZY000);
    COMMIT;
  WHEN INS_TSFYTJ_ERR THEN
     PO_RET := -7103;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'�����������������ʱͳ�Ƴ���!',V_SQLERRM,'SP_JS_MZFYINSERT',PI_FWWDBH,PI_CZY000);
    COMMIT;
  WHEN OTHERS THEN
     PO_RET := -7104;
    V_SQLERRM := SQLERRM;
    INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000)
      VALUES(PO_RET,'�������������ʱ������������!',V_SQLERRM,'SP_JS_MZFYINSERT',PI_FWWDBH,PI_CZY000);
    COMMIT;
END SP_JS_MZFYINSERT;
/
