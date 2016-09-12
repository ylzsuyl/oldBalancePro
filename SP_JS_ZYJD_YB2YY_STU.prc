CREATE OR REPLACE PROCEDURE SP_JS_ZYJD_YB2YY_STU
(
   PI_NIAN00    IN VARCHAR,
   PI_QSRQ00    IN VARCHAR,
   PI_JZRQ00    IN VARCHAR,
  PI_FWWDBH   IN VARCHAR,
   pi_wdjbbh  in varchar,
   pi_fzxbh0  in varchar,
   pi_czyuan  in varchar,
  PO_sign     OUT NUMBER
) AS
   cursor c_1 is
      select FZXBH0 from bm_fzxbmb;
   ls_fzxbh0   char(2);
   ln_pdbz   number;
   LN_COUNT    NUMBER(8);
   LN_ZYCS00   NUMBER(8);
   LN_FYBFY0   NUMBER(10,2);
   LN_FYBZH0   NUMBER(10,2);
   LN_FYBXJ0   NUMBER(10,2);
   LN_ZHBYZF   NUMBER(10,2);
   LN_JJBYZF   NUMBER(10,2);
   LN_SBBYZF   NUMBER(10,2);
   LN_JJZF00   NUMBER(10,2);
   LN_ZHZF00   NUMBER(10,2);
   LN_XJZF00   NUMBER(10,2);
   LN_SBJJZF   NUMBER(10,2);
   LN_ZZF000   NUMBER(10,2);
   LN_YZFJJ0   NUMBER(10,2);
   LN_YBFJJ0   NUMBER(10,2);
   ln_yzfzh0   NUMBER(10,2);  --Ӧ֧���ʻ�
   LN_SJZHZF   NUMBER(10,2);
   LN_ZFNL00   NUMBER(8,4);  --ÿ��֧������
   ln_zryfy0   number(10,2);  --ת��Ժ����
   ln_wdlb00   char(2);       --�������
   ln_wgyfy0   number(10,2);
   ln_zyyybl   number(3,2);   --תԺҽԺ֧������
   ln_ybzjbl   number(3,2);   --Ԥ���ʽ����
   ln_sjsbzf   number(10,2);  --ʵ���̱�֧��
   LN_SJJSJE   NUMBER(10,2);  --ʵ�ʽ�����
   LN_YBYBZJ   NUMBER(10,2);  --ҽ��Ԥ�����
   LN_YBBLJE   NUMBER(10,2);  --ҽ���������
   V_SQLERRM  VARCHAR2(512);

   ERR_INS_ZYJD      EXCEPTION;
   ERR_JS_ZRYFY      EXCEPTION;
   ERR_SEL_HBCS      EXCEPTION;
   ERR_SEL_ZYJS      EXCEPTION;
   ERR_SEL_ZFNL      EXCEPTION;
   ERR_YD_ZYJS          EXCEPTION;
   cursor c_2 is
      select distinct tcjjlx from bm_tcjjlx; --add by Chenj on 20040315
   ls_tcjjlx   char(2);
BEGIN
  -- ���ݷ���������������������
  --**********************PO_SIGN  = -7001 ˵�������·�����û�����ɣ���������ݣ�********************
  --SET TRANSACTION USE ROLLBACK SEGMENT JF_RBS;
  SELECT COUNT(*) INTO LN_COUNT FROM VW_JS_ZYJS00_STU
   WHERE TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
         TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00) AND
         FWWDBH = PI_FWWDBH;
   IF LN_COUNT <= 0 THEN --����������δ��
      V_SQLERRM := '�����·����ݻ�û������!';
      RAISE ERR_SEL_ZYJS;
   END IF;
   ---�����������'04'-����ҩ��
   SELECT WDLB00 INTO LN_WDLB00
      FROM BM_FWWDB0
      WHERE FWWDBH=PI_FWWDBH ;
   --IF LN_WDLB00='04' THEN  --����ҩ��û��סԺ
   --   v_sqlerrm :='����Ϊҩ�꣬û��סԺ����';
   --  RAISE ERR_YD_ZYJS;
   --END IF;
   -----------���ݲ�ͬ�����ķֱ����--------------------------
   OPEN C_1;
   LOOP
      fetch c_1 into ls_fzxbh0;
      EXIT WHEN c_1%notfound ;

      --NEW ADD BY CHENJ ON 20040315
      --���ݲ�ͬ�������ͳ��
      open c_2;
      loop

         fetch c_2 into ls_tcjjlx;
         exit when c_2%notfound;

            BEGIN
            ln_count:=0;
            SELECT count(*),nvl(SUM(ZYCS00),0),nvl(SUM(fybfy0),0),nvl(SUM(fybzh0),0),
                   nvl(SUM(zhbyzf),0),nvl(SUM(jjbyzf),0),nvl(SUM(sbbyzf),0),
                   nvl(SUM(nvl(XJZFJE,0) + nvl(DBGRZF,0)),0),
                   nvl(SUM(nvl(ZHZFJE,0) + nvl(DBZHZF,0)),0),
                   nvl(SUM(JJZFJE),0),nvl(SUM(DBJJZF),0), nvl(SUM(ZZFJE0),0)
              into  ln_count,LN_ZYCS00,ln_fybfy0,ln_fybzh0,ln_zhbyzf,ln_jjbyzf,
                    ln_sbbyzf,LN_XJZF00, LN_ZHZF00,LN_JJZF00,LN_SBJJZF,LN_ZZF000
                FROM  Vw_Js_Zyjs00_Stu
                WHERE TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
                  TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00) and
                  fwwdbh=pi_fwwdbh and tcjjlx=ls_tcjjlx and fzxbh0=ls_fzxbh0;
             if ln_count>0 then
               ln_fybxj0 := ln_fybfy0 - ln_fybzh0 ;
               ln_sjsbzf := ln_sbjjzf - ln_sbbyzf ;
               ln_yzfzh0 := ln_zhzf00 - ln_zhbyzf ;
               ln_pdbz:=sf_js_pdszdq(ls_fzxbh0,pi_fwwdbh);
               if ln_pdbz=0 or ln_pdbz=1 then  --�����л�ͨ����
                   --����֧������
                 IF LN_WDLB00='04' THEN  --����ҩ��
                    ln_zfnl00 := 1;
                 ELSE
                  BEGIN
                     ln_count:=0;
                   SELECT COUNT(*) INTO LN_COUNT FROM js_yfzfnl_jm
                          WHERE  TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
                               TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00) AND
                               FZXBH0 = PI_FZXBH0;-- and xxly00='1'
                    IF LN_COUNT > 0 THEN -- ����֧���������ݲ����Ѿ�����
                       SELECT zfnl00  INTO LN_ZFNL00 FROM js_yfzfnl_jm
                         WHERE FZXBH0 = PI_FZXBH0 AND
                              TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
                              TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00);
                     if ln_zfnl00>1 then
                       ln_zfnl00:=1;
                     end if;
                    if ln_zfnl00<0 then
                       ln_zfnl00:=0;
                     END IF;
                    ELSE
                        V_SQLERRM := '����֧���������ݲ�����û������!';
                        RAISE ERR_SEL_ZFNL;
                     END IF;
                  END;
                 END IF;
                  ---���Ҳ���
                  begin
                     select ybzjbl into ln_ybzjbl
                       from Bm_Jsblb0_Jm            -------------ȡ����֧����������
                       where (pi_qsrq00 between qsrq00 and jzrq00) and
                             (pi_jzrq00 between qsrq00 and jzrq00) and
                             JSLB00 = '00' ;
                  exception when others then
                        v_sqlerrm := sqlerrm;
                        RAISE ERR_SEL_HBCS;
                  end;
                  --�����⹺ҩ����
                  begin
                      select nvl(xmje00,0) into ln_wgyfy0
                         from js_tjxmlb
                          where  rtrim(ltrim(lower(xmbm00)))='wgyfy0'  and
                                 TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
                              TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00) and
                                 fwwdbh=(SELECT MAX(fwwdbh) FROM js_tjxmlb
                                     WHERE  (fwwdbh='0000' OR fwwdbh=PI_fwwdbh));
                        if ln_wgyfy0<=0 or (ln_wgyfy0 is null) then
                           ln_wgyfy0 :=0 ;
                        end if;
                  exception when others then
                        ln_wgyfy0 :=0 ;
                  end;
                  --����ת��Ժ����
                  begin
                  --   select nvl(sum(a.jjzfje * b.zyyybl),0) into ln_zryfy0
                       select nvl(sum(a.jjzfje),0) into ln_zryfy0
                       from js_zyyyjs a,BM_JS_YBHBCS b
                       where  TO_NUMBER(a.QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
                             TO_NUMBER(A.JZRQ00) <= TO_NUMBER(PI_JZRQ00) and
                             a.yfwwd0=pi_fwwdbh and a.fzxbh0=ls_fzxbh0   and
                             b.fzxbh0=pi_fzxbh0 and a.tcjjlx=ls_tcjjlx and
                             b.zyfs00=sf_js_pdzyfs(a.yfwwd0,a.xfwwd0);
                  exception when others then
                        v_sqlerrm := sqlerrm;
                        RAISE ERR_JS_ZRYFY ;
                  end;
               else
                 ln_wgyfy0 := 0;
                 ln_ybzjbl := 1;
                 ln_zfnl00 := 1;
                 ln_zryfy0 := 0;
               end if;
               ln_sjzhzf := ln_yzfzh0 ;
               ln_yzfjj0 := (ln_jjzf00 - ln_jjbyzf) * ln_zfnl00 ;
               ln_ybfjj0 := ln_yzfjj0 * ln_ybzjbl;
               ln_ybybzj := ln_ybfjj0 - ln_zryfy0 - ln_wgyfy0 ;
               LN_SJJSJE := ln_ybybzj + ln_sjzhzf + ln_sjsbzf;
               -------------
               Begin

                INSERT INTO Js_Zyjd_Yb2yy_Stu
                 (
                    NIAN00,QSRQ00,JZRQ00,FZXBH0,FWWDBH,WDJBBH,ZYCS00,
                    fybfy0,fybzh0,fybxj0,zhbyzf,jjbyzf,sbbyzf,zfnl00,
                    ZHZFJE,XJZFJE,JJZFJE,SBJJZF,ZZFJE0,SJJSJE,YBYBZJ,
                    yzfjj0,ybfjj0,zryfy0,wgyfy0,yzfzh0,sjzhzf,sjsbzf,
                    WDFZXH,CZRQ00,CZYUAN,tcjjlx
                  )
                 VALUES
                  (
                    pi_NIAN00,pi_QSRQ00,pi_JZRQ00,ls_fzxbh0,pi_FWWDBH,pi_wdjbbh,nvl(LN_ZYCS00,0),
                    nvl(LN_fybfy0,0),nvl(LN_fybzh0,0),nvl(LN_fybxj0,0),nvl(LN_ZHBYZF,0),nvl(LN_JJBYZF,0),nvl(LN_SBBYZF,0),nvl(LN_ZFNL00,0),
                    nvl(LN_ZHZF00,0),nvl(LN_XJZF00,0),nvl(LN_JJZF00,0),NVL(LN_SBJJZF,0),nvl(LN_ZZF000,0),nvl(LN_SJJSJE,0),nvl(LN_YBYBZJ,0),
                    nvl(LN_YZFJJ0,0),nvl(LN_YBFJJ0,0),nvl(LN_ZRYFY0,0),NVL(LN_WGYFY0,0),nvl(LN_YZFZH0,0),nvl(LN_SJZHZF,0),nvl(LN_SJSBZF,0),
                    PI_FZXBH0, TO_CHAR(SYSDATE,'YYYYMMDD'),PI_CZYUAN,ls_tcjjlx
                  );

        EXCEPTION WHEN OTHERS THEN
                    V_SQLERRM := SQLERRM;
                     RAISE ERR_INS_ZYJD;
        END;
             end if;
            END;
       end loop;
       close c_2;
   END LOOP;
   close c_1;
   COMMIT;
   po_sign := 0;
EXCEPTION   WHEN ERR_INS_ZYJD THEN
               PO_SIGN := -7421;
               ROLLBACK;
               INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
                (PO_SIGN,'����������＾�ȱ�ʱ����!',V_SQLERRM,'����->SP_JS_ZYJD_YB2YY_STU',pi_FWWDBH,pi_czyuan);
               COMMIT;
            WHEN ERR_SEL_HBCS THEN
               PO_SIGN := -7422;
               ROLLBACK;
               INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
                (PO_SIGN,'�ӱ�BM_JSBLB0_JM����֧������ϵ��ʱ����!',V_SQLERRM,'�¶Ƚ���->SP_JS_ZYJD_YB2YY_STU',pi_FWWDBH,pi_czyuan);
               COMMIT;
            WHEN ERR_JS_ZRYFY THEN
               PO_SIGN := -7423;
               ROLLBACK;
               INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
                (PO_SIGN, '����ת��Ժ����ʱ����!',V_SQLERRM,'�¶Ƚ���->SP_JS_ZYJD_YB2YY_STU',pi_FWWDBH,pi_czyuan);
               COMMIT;
            WHEN ERR_SEL_ZYJS THEN
               PO_SIGN := -7001;
            WHEN ERR_SEL_ZFNL THEN
               PO_SIGN := -7002;
            WHEN ERR_YD_ZYJS THEN
               PO_SIGN := -7003;
               ROLLBACK;
               INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
                (PO_SIGN,'����Ϊҩ�꣬û��סԺ����!',V_SQLERRM,'סԺ�¶Ƚ���->SP_JS_ZYJD_YB2YY_STU',pi_FWWDBH,pi_czyuan);
               COMMIT;
            WHEN OTHERS THEN
               ROLLBACK;
               PO_SIGN := -7423;--���＾�Ƚ��������
               V_SQLERRM := SQLERRM;
               INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
                (PO_SIGN,'���＾�Ƚ��㷢���������!',V_SQLERRM,'����->SP_JS_ZYJD_YB2YY_STU',pi_FWWDBH,pi_czyuan);
               COMMIT;
END SP_JS_ZYJD_YB2YY_STU;
/
