CREATE OR REPLACE PROCEDURE SP_JS_JMMZYFJD_YB2YY
(
   PI_NIAN00    IN VARCHAR,
   PI_QSRQ00    IN VARCHAR,
   PI_JZRQ00    IN VARCHAR,
   PI_FWWDBH    IN VARCHAR,
   pi_wdjbbh    in varchar,
   pi_fzxbh0    in varchar,
   pi_czyuan    in varchar,
   PO_sign      OUT NUMBER
) AS
   cursor c_1 is
      select FZXBH0 from bm_fzxbmb;
      LN_RS0000 NUMBER;
      LN_YYJJE0 NUMBER(10,2);
      LN_FZXBH0 CHAR(2);
      LN_WDFZX0 CHAR(2);
      LN_QYFY00 VARCHAR2(8);
      LN_QSRQ00 VARCHAR2(8);

/*   cursor c_2 is
      select distinct tcjjlx from bm_tcjjlx; --不同基金类别*/
BEGIN

   SELECT QYFY00 INTO LN_QYFY00 FROM BM_JMMZTC WHERE PI_NIAN00||'02'||'01' BETWEEN QSRQ00 AND JZRQ00;
   SELECT FZXBH0 INTO LN_WDFZX0 FROM BM_FWWDB0 WHERE FWWDBH = PI_FWWDBH;
  OPEN C_1;
   LOOP
      fetch c_1 into LN_FZXBH0;
      EXIT WHEN c_1%notfound ;
      -----------根据不同分中心分别计算--------------------------*/
        BEGIN

        LN_RS0000 := 0;
        LN_YYJJE0 := 0;


         SELECT COUNT(DISTINCT ID0000) INTO LN_RS0000 FROM YY_MZSFB0
         WHERE TO_NUMBER(QSRQ00) BETWEEN TO_NUMBER(PI_QSRQ00) AND TO_NUMBER(PI_JZRQ00)
         AND TRIM(CXBZ00) = 'Z'
         AND FWWDBH = PI_FWWDBH AND FZXBH0 = LN_FZXBH0 AND GZZT00 > '99';

         select round((sum((nvl(jjzfje,0) + nvl(ybczje,0) +  nvl(ybjlje,0) - nvl(yybze0,0))/(ybrs00*12))),2) INTO LN_YYJJE0
         FROM js_jmmzndjd_yb2yy
         WHERE NIAN00 = to_char(to_number(PI_NIAN00)-1) AND FWWDBH = PI_FWWDBH AND FZXBH0 = LN_FZXBH0;
         
         IF LN_YYJJE0 > 0 AND LN_RS0000 > 0 then
               begin
                INSERT INTO js_jmmz_yjs
                 (
                    nian00,fwwdbh,rs0000,yyjje0,fzxbh0,
                    wdfzx0,qybz00,qsrq00,ksrq00,jzrq00
                  )
                 VALUES
                  (
                    SUBSTR(PI_QSRQ00,0,6),PI_FWWDBH,LN_RS0000,LN_YYJJE0,LN_FZXBH0,
                    LN_WDFZX0,LN_QYFY00,LN_QSRQ00,PI_QSRQ00,PI_JZRQ00
                  );
        /*         EXCEPTION WHEN OTHERS THEN
                           V_SQLERRM := SQLERRM;
                             RAISE ERR_INS_MZJD;*/

               end;
         END IF;

         NULL;
         END;
   END LOOP;
   close c_1;
   COMMIT;
   po_sign := 0;
END;
/
