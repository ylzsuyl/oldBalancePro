create or replace procedure sp_js_zyyyinsert
(
	pi_czy000	in char,
	po_ret out number
)
is
	v_sqlerrm 	varchar2(512);
	del_zyyytj_err exception;
	INS_ZYYYTJ_ERR exception;
begin
	commit;
	--set transaction use rollback segment JF_RBS;
	begin	--�����ʱ������
		delete from js_temp_zyyytj;
	exception when others then
		v_sqlerrm := sqlerrm;
		raise del_zyyytj_err;
	end;
	begin --��������תԺ������ʱͳ�Ʊ�
		insert into js_temp_zyyytj
		(  ZYDJH0 ,        -- תԺ�ǼǺ�
                   YFWWD0 ,        -- ԭ��������
                   XFWWD0 ,        -- �·�������
                   FZXBH0 ,        -- �����ı��
                   TCJJLX ,        -- ͳ���������
                   ID0000 ,        -- ���˱��պ�
                   JSRQ00 ,        -- ��������
                   XXLY00 ,        -- ��Ϣ��Դ,1ΪסԺ�ǼǱ�2Ϊ�����շѱ�
                   BCKBCS ,        -- ���ο�������
                   ZHZFJE ,        -- �����ʻ�֧�����
                   XJZFJE ,       -- �����ֽ�֧�����
                   JJZFJE ,       -- ����֧�����
                   zbxfje ,       -- ��֧�����
                   DBZHZF ,       -- ��סԺ�ʻ�֧�����
                   DBGRZF ,       -- ��סԺ�ֽ�֧�����
                   DBJJZF         -- ��סԺ����֧�����
		)
		select
		   ZYDJH0 ,        -- תԺ�ǼǺ�
                   YFWWD0 ,        -- ԭ��������
                   XFWWD0 ,        -- �·�������
                   FZXBH0 ,        -- �����ı��
                   TCJJLX ,        -- ͳ���������
                   ID0000 ,        -- ���˱��պ�
                   JSRQ00 ,        -- ��������
                   XXLY00 ,        -- ��Ϣ��Դ,1ΪסԺ�ǼǱ�2Ϊ�����շѱ�
                   BCKBCS ,        -- ���ο�������
                   ZHZFJE ,        -- �����ʻ�֧�����
                   XJZFJE ,       -- �����ֽ�֧�����
                   JJZFJE ,       -- ����֧�����
                   zbxfje ,       -- ��֧�����
                   DBZHZF ,       -- ��סԺ�ʻ�֧�����
                   DBGRZF ,       -- ��סԺ�ֽ�֧�����
                   DBJJZF         -- ��סԺ����֧�����
		from vw_js_zyyytj;
	exception when others then
		v_sqlerrm := sqlerrm;
		raise INS_ZYYYTJ_ERR;
	end;
	po_ret := 0;
exception
	when DEL_ZYYYTJ_ERR then
	   PO_RET := -7124;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'���ת��ҽԺ��ʱ�����!',v_sqlerrm,'sp_js_zyyyinsert','all',pi_czy000);
		COMMIT;
	when INS_ZYYYTJ_ERR then
	   PO_RET := -7125;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'����ת��ҽԺ������ʱͳ�Ʊ����!',v_sqlerrm,'sp_js_zyyyinsert','all',pi_czy000);
		COMMIT;
	when others then
	   PO_RET := -7126;
		v_sqlerrm := sqlerrm;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'����ת��ҽԺ�����ٱ�ʱ���ֱ�Ĵ���!',v_sqlerrm,'sp_js_zyyyinsert','all',pi_czy000);
		COMMIT;
end sp_js_zyyyinsert;
/
