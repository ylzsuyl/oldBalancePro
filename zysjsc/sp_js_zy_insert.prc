create or replace procedure sp_js_zy_insert
(
	pi_nian00	in	varchar,
	pi_yf0000 	in	varchar,
	pi_fwwdbh 	in varchar,
	pi_wdjbbh	in varchar,
	pi_qsrxm0 	in varchar,
	po_ret	out number
)is
   LS_BJRQ00   CHAR(8);
   ls_qsrq     char(8); --��������
   ls_qsrq00   char(8);	--������ʼ����
   ls_jzrq00   char(8);	--�����ֹ����
   v_sqlerrm	varchar2(512);
   ins_js_zyjs00_err	exception;
   upd_yy_zydjb0_err	exception;
   upd_yy_zysfb0_err	exception;
   del_js_zyjs00_err exception;
begin
   delete from JS_SCYFSJ_LOG
	   where nian00 = pi_nian00 AND yf0000 = pi_yf0000 AND fwwdbh = pi_fwwdbh and jslx00='ZY';
	commit;
	--SET TRANSACTION USE ROLLBACK SEGMENT JF_RBS;
	--������ʼ����
	sp_js_qs2jz0(pi_nian00,pi_yf0000,ls_qsrq00,ls_jzrq00);
	select to_char(sysdate,'yyyymmdd') into ls_qsrq from dual;
	LS_BJRQ00 := SUBSTR(LS_QSRQ00,1,6)||'05' ;

	begin
		insert into js_zyjs00 --<��������>--
		(  nian00,  yf0000,  qsrqi0,  fwwdbh,
		   wdjbbh,  gzzt00, 	fzxbh0,  ksrqi0,
		   jzrqi0, 	--��ֹ����
		   sfcs00,  --�շѴ���
   		zyts00,  --סԺ����
   		zycs00,  --סԺ����
   		xjzfje,  --�ֽ�֧�����	(--���˴�֮��)
   		zhzfje,  --�ʻ�֧�����	(--���˴�֮��)
   		jjzfje,  --����֧�����	(--���˴�֮��)
   		zzfje0,  --��֧�����
   		dbzhzf,  --���ʻ�֧��
         dbgrzf,  --�󲡸���֧��
         dbjjzf,  --�󲡻���֧��
         DBZZF0,
         TSXMFY,  -- ������Ŀ����
         YBGRFY,  -- ���߲����Է�
         FYBFY0,  -- ��ҽ�����û���
         FYBZH0,   --
   		qsrxm0	--����������
		)
		select
	     	   pi_nian00, 	pi_yf0000,	ls_qsrq, 	pi_fwwdbh,
   	  	   pi_wdjbbh, 	gzzt00,		fzxbh0,
     		   ls_qsrq00,
     		   ls_jzrq00,	--��ֹ����
		      sfcs00,  --�շѴ���
   		   zyts00,  --סԺ����
   		   zycs00,  --סԺ����
   		   xjzfje,  --�ֽ�֧�����	(--���˴�֮��)
   		   zhzfje,  --�ʻ�֧�����	(--���˴�֮��)
   		   jjzfje,  --����֧�����	(--���˴�֮��)
   		   zzfje0,  --��֧�����
   		   dbzhzf,  --���ʻ�֧��
            dbgrzf,  --�󲡸���֧��
            dbjjzf,  --�󲡻���֧��
            DBZhZF + DBGRZF + DBJJZF,
            TSXMFY,  -- ������Ŀ����
            YBGRFY,  -- ���߲����Է�
            FYBFY0,  -- ��ҽ�����û���
            FYBZH0,   --
   		   pi_qsrxm0
   	from  VW_JS_SUM000
   	where fwwdbh = pi_fwwdbh;
   exception when others then
   	v_sqlerrm := sqlerrm;
   	raise ins_js_zyjs00_err;
	end;
	--����סԺ�շѱ���
	begin
		update yy_zysfb0 a
		set  	a.qsrq00 = LS_BJRQ00, -- �������ڱ��
        		a.qsrxm0 = pi_qsrxm0
		where  (a.sfrq00 between ls_qsrq00 and ls_jzrq00  or
             (a.sfrq00 <ls_qsrq00 and a.qsrq00 is null ))  and  -- ����δ�����¼
		       a.fwwdbh = pi_fwwdbh and
		       a.zylsh0 in ( select b.zylsh0
			                 from yy_zydjb0 b
			                 where b.fwwdbh = pi_fwwdbh and
			                       a.zylsh0 = b.zylsh0 and
                                b.cyrq00 <= ls_jzrq00 and b.cyrq00 <> '*' ) and a.zylb00<>'13' and a.zylb00<>'15';

   --add lizhiling 20061030
       update yy_zydjb0 b
       set  	b.qsrq00 = LS_BJRQ00, -- �������ڱ��
        	   	b.qsrxm0 = pi_qsrxm0
		 where b.fwwdbh = pi_fwwdbh and
         b.cyrq00 <= ls_jzrq00 and b.cyrq00 <> '*' and b.qsrq00 is null and b.zylb00<>'13' and b.zylb00<>'15';


   exception when others then
      v_sqlerrm := sqlerrm;
      raise upd_yy_zysfb0_err;
	end;
	--д����־
	insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
      values(pi_nian00,pi_yf0000,pi_fwwdbh,'ZY',1,pi_qsrxm0);
	COMMIT;
	po_ret := 0;
exception
	when ins_js_zyjs00_err then
	   rollback;
	   PO_RET := -7131;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'����סԺ��������ݳ���!',v_sqlerrm,'sp_js_zy_insert',pi_fwwdbh,pi_qsrxm0);
		insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
	      values(pi_nian00,pi_yf0000,pi_fwwdbh,'ZY',-1,pi_qsrxm0);
	   commit;
	when upd_yy_zydjb0_err then
	   rollback;
	   PO_RET := -7132;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'���סԺ�ǼǱ�������ڳ���!',v_sqlerrm,'sp_js_zy_insert',pi_fwwdbh,pi_qsrxm0);
		insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
	      values(pi_nian00,pi_yf0000,pi_fwwdbh,'ZY',-1,pi_qsrxm0);
	    COMMIT;
	when upd_yy_zysfb0_err then
	   rollback;
	   PO_RET := -7133;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'���סԺ�շѱ�������ڳ���!',v_sqlerrm,'sp_js_zy_insert',pi_fwwdbh,pi_qsrxm0);
		insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
	      values(pi_nian00,pi_yf0000,pi_fwwdbh,'ZY',-1,pi_qsrxm0);
	   commit;
	when others then
	   rollback;
		v_sqlerrm := sqlerrm;
		PO_RET := -7134;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'סԺ���������������!',v_sqlerrm,'sp_js_zy_insert',pi_fwwdbh,pi_qsrxm0);
		insert into JS_SCYFSJ_LOG(nian00, yf0000,fwwdbh,jslx00,czwcbz,czy000)
	      values(pi_nian00,pi_yf0000,pi_fwwdbh,'ZY',-1,pi_qsrxm0);
	   COMMIT;
end sp_js_zy_insert;
/
