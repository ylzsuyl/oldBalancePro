create or replace procedure sp_js_zyfyinsert
(
	pi_fwwdbh	in char,
	pi_czy000	in char,
	po_ret out number
)
is
	v_sqlerrm 	varchar2(512);
	del_zyfytj_err	exception;
	ins_zyfytj_err	exception;
begin
	commit;
	--set transaction use rollback segment jf_rbs;
	begin	--�����ʱ������
		delete from js_temp_zyfytj where fwwdbh like pi_fwwdbh||'%';
		delete from JS_TEMP_ZYTS where fwwdbh like pi_fwwdbh||'%';
		--add by Chenj on 20050328
		--���շѱ�ԭ�ȵ��������ڱ����գ��Է�ֹ���¼���ʱ���ַ���ͳ�Ƶ���©
		--update yy_zysfb0 a,vw_js_arg b
		--set   a.qsrq00 = ''
		--where a.fwwdbh like pi_fwwdbh||'%' and a.qsrq00=substr(b.qsrq00,1,6)||'05';
		UPDATE yy_zysfb0
      set   qsrq00 = null
		where fwwdbh like pi_fwwdbh||'%' and qsrq00 in (select substr(qsrq00,1,6)||'05' from vw_js_arg) and zylb00<>'13';
	exception when others then
		v_sqlerrm := sqlerrm;
		raise del_zyfytj_err;
	end;
	begin --�������������ʱͳ�Ʊ�
		insert into js_temp_zyfytj
		(  fwwdbh,  gzzt00,  wdjbbh,  fzxbh0,
		   sfcs00,  --�շѴ���
   		   xjzfje,  --�ֽ�֧�����	(--���˴�֮��)
   		   zhzfje,  --�ʻ�֧�����	(--���˴�֮��)
   		   jjzfje,  --����֧�����	(--���˴�֮��)
   		   zzfje0,  --��֧�����
                   dbzhzf,  --���ʻ�֧��
                   dbgrzf,  --�󲡸���֧��
                   dbjjzf,  --�󲡻���֧��
                   TSXMFY,  -- ������Ŀ����
                   YBGRFY,  -- ���߲����Է�
                   FYBFY0,  -- ��ҽ�����û���
                   FYBZH0   --
		)
		select   fwwdbh,  gzzt00,  wdjbbh,  fzxbh0,
		   sfcs00,  --�շѴ���
   		   xjzfje,  --�ֽ�֧�����	(--���˴�֮��)
   		   zhzfje,  --�ʻ�֧�����	(--���˴�֮��)
   		   jjzfje,  --����֧�����	(--���˴�֮��)
   		   zzfje0,  --��֧�����
   		   dbzhzf,  --���ʻ�֧��
                   dbgrzf,  --�󲡸���֧��
                   dbjjzf,  --�󲡻���֧��
                   TSXMFY,  -- ������Ŀ����
                   YBGRFY,  -- ���߲����Է�
                   FYBFY0,  -- ��ҽ�����û���
                   FYBZH0   --
		from vw_js_zyfytj
		where fwwdbh like pi_fwwdbh||'%';
	exception when others then
		v_sqlerrm := sqlerrm;
		raise ins_zyfytj_err;
	end;
	begin --����סԺ������ʱͳ�Ʊ�
		insert into js_temp_zyts
		(  fwwdbh,  gzzt00,  wdjbbh,  fzxbh0,
		   ZYCS00,  --סԺ����
   		   ZYTS00   --סԺ����
		)
		select   fwwdbh,  gzzt00,  wdjbbh,  fzxbh0,
		   ZYCS00,  --סԺ����
   		   ZYTS00   --סԺ����
		from vw_js_zyts
		where fwwdbh like pi_fwwdbh||'%';
	exception when others then
		v_sqlerrm := sqlerrm;
		raise ins_zyfytj_err;
	end;
	po_ret := 0;
exception
	when del_zyfytj_err then
	   PO_RET := -7121;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'�����ʱ�����ݳ���!',v_sqlerrm,'sp_js_zyfyinsert',pi_fwwdbh,pi_czy000);
		COMMIT;
	when ins_zyfytj_err then
	   PO_RET := -7122;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'����סԺ������ʱͳ�Ʊ����!',v_sqlerrm,'sp_js_zyfyinsert',pi_fwwdbh,pi_czy000);
		COMMIT;
	when others then
	   PO_RET := -7123;
		v_sqlerrm := sqlerrm;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'����סԺ������ʱ������������!',v_sqlerrm,'sp_js_zyfyinsert',pi_fwwdbh,pi_czy000);
		COMMIT;
end sp_js_zyfyinsert;
/
