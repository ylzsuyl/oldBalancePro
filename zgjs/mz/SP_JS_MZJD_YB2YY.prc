CREATE OR REPLACE PROCEDURE SP_JS_MZJD_YB2YY
(
   PI_NIAN00    IN VARCHAR,
   PI_QSRQ00    IN VARCHAR,
   PI_JZRQ00    IN VARCHAR,
   PI_FWWDBH	 IN VARCHAR,
   pi_wdjbbh	in varchar,
   pi_fzxbh0	in varchar,
   pi_czyuan	in varchar,
	PO_sign	   OUT NUMBER
) AS
   cursor c_1 is
      select FZXBH0 from bm_fzxbmb;
   ls_fzxbh0   char(2);
   ln_pdbz     number;
   LN_COUNT    NUMBER(8);
   LN_MZCS00   NUMBER(8);
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
   ln_yzfzh0   NUMBER(10,2);  --Ӧ֧���ʻ�
   LN_YBFJJ0   NUMBER(10,2);
   LN_SJZHZF   NUMBER(10,2);
   LN_ZFNL00   NUMBER(8,4);   --ÿ��֧������
   ln_zryfy0   number(10,2);  --ת��Ժ����
   ln_wdlb00   char(2);       --�������
   ln_wgyfy0   number(10,2);
   ln_zyyybl   number(3,2);  --תԺҽԺ֧������
   ln_ybzjbl   number(3,2);  --Ԥ���ʽ����
   ln_sjsbzf   number(10,2);
   LN_SJJSJE   NUMBER(10,2);  --ʵ�ʽ�����
   LN_YBYBZJ   NUMBER(10,2);  --ҽ��Ԥ�����
   LN_YBBLJE   NUMBER(10,2);  --ҽ���������
   ln_zfnlbz   number := 0;
   V_SQLERRM	VARCHAR2(512);
   ERR_INS_MZJD	  		EXCEPTION;	--��������������＾�ȱ�ʱ����
   ERR_SEL_HBCS	  		EXCEPTION;
   ERR_SEL_MZJS	  		EXCEPTION;
   ERR_SEL_ZFNL	  		EXCEPTION;
   cursor c_2 is
      select distinct tcjjlx from bm_tcjjlx; --add by Chenj on 20040315
   ls_tcjjlx   char(2);
BEGIN
	-- ���ݷ���������������������
	--**********************PO_SIGN  = -7001 ˵�������·�����û�����ɣ���������ݣ�********************
	COMMIT;
	--SET TRANSACTION USE ROLLBACK SEGMENT JF_RBS;
	SELECT COUNT(*) INTO LN_COUNT FROM VW_JS_MZJS00
        	WHERE TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
        			TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00) AND
        			FWWDBH = PI_FWWDBH;
   IF LN_COUNT <= 0 THEN -- ����������δ����
      V_SQLERRM := '�����·����ݻ�û������!';
      RAISE ERR_SEL_MZJS;
   END IF;
   ---�����������'04'-����ҩ��
   SELECT WDLB00 INTO LN_WDLB00
      FROM BM_FWWDB0
      WHERE FWWDBH=PI_FWWDBH ;
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
            ln_count :=0;
            SELECT count(*),nvl(SUM(MZCS00),0),nvl(SUM(fybfy0),0),nvl(SUM(fybzh0),0),
                   nvl(SUM(zhbyzf),0),nvl(SUM(jjbyzf),0),nvl(SUM(sbbyzf),0),
                   nvl(SUM(nvl(XJZFJE,0) + nvl(DBGRZF,0)),0),
                   nvl(SUM(nvl(ZHZFJE,0) + nvl(DBZHZF,0)),0),
            	     nvl(SUM(JJZFJE),0),nvl(SUM(DBJJZF),0), nvl(SUM(ZZFJE0),0)
            	into  ln_count,LN_MZCS00,ln_fybfy0,ln_fybzh0,ln_zhbyzf,ln_jjbyzf,
            	      ln_sbbyzf,LN_XJZF00, LN_ZHZF00,LN_JJZF00,LN_SBJJZF,LN_ZZF000
              FROM  VW_JS_MZJS00
              WHERE TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
              	      TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00) and
              	      fwwdbh=pi_fwwdbh and tcjjlx=ls_tcjjlx and fzxbh0=ls_fzxbh0;
             if ln_count>0 then
               ln_fybxj0 := ln_fybfy0 - ln_fybzh0 ;
               ln_sjsbzf := ln_sbjjzf - ln_sbbyzf ;
               ln_yzfzh0 := ln_zhzf00 - ln_zhbyzf ;
               ln_pdbz :=sf_js_pdszdq(ls_fzxbh0,pi_fwwdbh);
               if ln_pdbz=0 or ln_pdbz=1 then  --�����л�ͨ����
                   --����֧������
                  BEGIN
                     ln_count :=0;
      		 SELECT COUNT(*) INTO LN_COUNT FROM js_yfzfnl
              	          WHERE  TO_NUMBER(QSRQ00) >= TO_NUMBER(PI_QSRQ00) AND
              			           TO_NUMBER(JZRQ00) <= TO_NUMBER(PI_JZRQ00) AND
              			           FZXBH0 = PI_FZXBH0;
      	 	          IF LN_COUNT > 0 THEN -- ����֧���������ݲ����Ѿ�����
      	               SELECT zfnl00	INTO LN_ZFNL00 FROM js_yfzfnl
      		               WHERE FZXBH0 = PI_FZXBH0 AND
      		 		               TO_NUMBER(QSRQ00) <= TO_NUMBER(PI_QSRQ00) AND
      		 		              TO_NUMBER(JZRQ00) >= TO_NUMBER(PI_JZRQ00);
      		 		      if ln_zfnl00>1 then
      		 		        ln_zfnl00 :=1;
      		 		      end if;
                    if ln_zfnl00<0 then
      		 		        ln_zfnl00 :=0;
      		 		      end if;
      	 	         ELSE
                           ln_zfnlbz := -1;
          	         END IF;
                  END;
                  --�⹺ҩ����
                  ln_wgyfy0 :=0 ;
                  ------------------
                  ln_zryfy0 := 0;
                  ---------------
                  ---���Ҳ���
                  begin
                     select ybzjbl into ln_ybzjbl
                       from BM_JSBLB0
                       where (pi_qsrq00 between qsrq00 and jzrq00) and
                             (pi_jzrq00 between qsrq00 and jzrq00) and
                             JSLB00 = '00' ;
                  exception when others then
                        v_sqlerrm := sqlerrm;
                        RAISE ERR_SEL_HBCS;
                  end;

                 IF LN_WDLB00 ='04' THEN  --����ҩ����½���
                     ln_sjzhzf := ln_yzfzh0 * ln_ybzjbl;
                     ln_zfnl00 := 1;
                 ELSE
                     if ln_jjzf00 > 0 and ln_zfnlbz = -1 then
                        V_SQLERRM := '����֧���������ݲ�����û������!';
                        RAISE ERR_SEL_ZFNL;
                     else
                        ln_zfnl00 := 1;
                     end if;
                     ln_sjzhzf := ln_yzfzh0 ;
                 END IF;
               else
                 ln_ybzjbl := 1;
                 ln_sjzhzf := ln_yzfzh0 ;
                 ln_wgyfy0 := 0;
                 ln_zryfy0 := 0;
                 ln_zfnl00 := 1;
               end if;
               ln_yzfjj0 := (ln_jjzf00 - ln_jjbyzf) * ln_zfnl00 ;
               ln_ybfjj0 := ln_yzfjj0 * ln_ybzjbl;
               ln_ybybzj := ln_ybfjj0 - ln_zryfy0 - ln_wgyfy0 ;
               LN_SJJSJE := ln_ybybzj + ln_sjzhzf + ln_sjsbzf;
               -----------------
               BEGIN
         	     INSERT INTO JS_MZJD_YB2YY
            	   (
                    NIAN00,QSRQ00,JZRQ00,FZXBH0,FWWDBH,WDJBBH,MZCS00,
                    fybfy0,fybzh0,fybxj0,zhbyzf,jjbyzf,sbbyzf,zfnl00,
                    ZHZFJE,XJZFJE,JJZFJE,SBJJZF,ZZFJE0,SJJSJE,YBYBZJ,
                    yzfjj0,ybfjj0,zryfy0,wgyfy0,yzfzh0,sjzhzf,sjsbzf,
                    WDFZXH,CZRQ00,CZYUAN,TCJJLX
                  )
                 VALUES
                  (
                    PI_NIAN00,PI_QSRQ00,PI_JZRQ00,ls_fzxbh0,pi_FWWDBH,pi_wdjbbh,nvl(LN_MZCS00,0),
                    nvl(LN_fybfy0,0),nvl(LN_fybzh0,0),nvl(LN_fybxj0,0),nvl(LN_ZHBYZF,0),nvl(LN_JJBYZF,0),nvl(LN_SBBYZF,0),nvl(LN_ZFNL00,0),
                    nvl(LN_ZHZF00,0),nvl(LN_XJZF00,0),nvl(LN_JJZF00,0),NVL(LN_SBJJZF,0),nvl(LN_ZZF000,0),nvl(LN_SJJSJE,0),nvl(LN_YBYBZJ,0),
                    nvl(LN_YZFJJ0,0),nvl(LN_YBFJJ0,0),nvl(LN_ZRYFY0,0),NVL(LN_WGYFY0,0),nvl(LN_YZFZH0,0),nvl(LN_SJZHZF,0),nvl(LN_SJSBZF,0),
                    PI_FZXBH0, TO_CHAR(SYSDATE,'YYYYMMDD'),PI_CZYUAN,ls_tcjjlx
                  );
      	 EXCEPTION WHEN OTHERS THEN
         	         V_SQLERRM := SQLERRM;
                     RAISE ERR_INS_MZJD;
      	 END;
             end if;
            END;
            end loop;
          close c_2;
   END LOOP;
   close c_1;
   COMMIT;
   po_sign := 0;
EXCEPTION   WHEN ERR_INS_MZJD THEN
               PO_SIGN := -7401;
    	         ROLLBACK;
    	         INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
         		   (PO_SIGN,'����������＾�ȱ�ʱ����!',V_SQLERRM,'����->SP_JS_MZJD_YB2YY',pi_FWWDBH,pi_czyuan);
       	      COMMIT;
       	   WHEN ERR_SEL_HBCS THEN
               PO_SIGN := -7402;
    	         ROLLBACK;
    	         INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
         		   (PO_SIGN,'�ӱ�BM_JSBLB0����֧������ϵ��ʱ����!',V_SQLERRM,'�����¶Ƚ���->SP_JS_MZJD_YB2YY',pi_FWWDBH,pi_czyuan);
       	      COMMIT;
       	   WHEN ERR_SEL_MZJS THEN
               PO_SIGN := -7001;
            WHEN ERR_SEL_ZFNL THEN
               PO_SIGN := -7002;
            WHEN OTHERS THEN
    	         ROLLBACK;
               PO_SIGN := -7403;--���＾�Ƚ��������
               V_SQLERRM := SQLERRM;
    	         INSERT INTO JS_ERRLOG(CWH000,JDCWXX,XXCWXX,CCDF00,CZDX00,CZY000) VALUES
      		      (PO_SIGN,'���＾�Ƚ��㷢���������!',V_SQLERRM,'����->SP_JS_MZJD_YB2YY',pi_FWWDBH,pi_czyuan);
       	      COMMIT;
END SP_JS_MZJD_YB2YY;
/
