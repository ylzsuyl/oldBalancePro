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
	begin	--清空临时表数据
		delete from js_temp_zyyytj;
	exception when others then
		v_sqlerrm := sqlerrm;
		raise del_zyyytj_err;
	end;
	begin --插入所有转院费用临时统计表
		insert into js_temp_zyyytj
		(  ZYDJH0 ,        -- 转院登记号
                   YFWWD0 ,        -- 原服务网点
                   XFWWD0 ,        -- 新服务网点
                   FZXBH0 ,        -- 分中心编号
                   TCJJLX ,        -- 统筹基金类型
                   ID0000 ,        -- 个人保险号
                   JSRQ00 ,        -- 计算日期
                   XXLY00 ,        -- 信息来源,1为住院登记表，2为报销收费表
                   BCKBCS ,        -- 本次看病次数
                   ZHZFJE ,        -- 病人帐户支付金额
                   XJZFJE ,       -- 病人现金支付金额
                   JJZFJE ,       -- 基金支付金额
                   zbxfje ,       -- 总支付金额
                   DBZHZF ,       -- 大病住院帐户支付金额
                   DBGRZF ,       -- 大病住院现金支付金额
                   DBJJZF         -- 大病住院基金支付金额
		)
		select
		   ZYDJH0 ,        -- 转院登记号
                   YFWWD0 ,        -- 原服务网点
                   XFWWD0 ,        -- 新服务网点
                   FZXBH0 ,        -- 分中心编号
                   TCJJLX ,        -- 统筹基金类型
                   ID0000 ,        -- 个人保险号
                   JSRQ00 ,        -- 计算日期
                   XXLY00 ,        -- 信息来源,1为住院登记表，2为报销收费表
                   BCKBCS ,        -- 本次看病次数
                   ZHZFJE ,        -- 病人帐户支付金额
                   XJZFJE ,       -- 病人现金支付金额
                   JJZFJE ,       -- 基金支付金额
                   zbxfje ,       -- 总支付金额
                   DBZHZF ,       -- 大病住院帐户支付金额
                   DBGRZF ,       -- 大病住院现金支付金额
                   DBJJZF         -- 大病住院基金支付金额
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
			values(PO_RET,'清空转移医院临时表出错!',v_sqlerrm,'sp_js_zyyyinsert','all',pi_czy000);
		COMMIT;
	when INS_ZYYYTJ_ERR then
	   PO_RET := -7125;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'插入转移医院费用临时统计表出错!',v_sqlerrm,'sp_js_zyyyinsert','all',pi_czy000);
		COMMIT;
	when others then
	   PO_RET := -7126;
		v_sqlerrm := sqlerrm;
		insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
			values(PO_RET,'计算转移医院费用临表时出现别的错误!',v_sqlerrm,'sp_js_zyyyinsert','all',pi_czy000);
		COMMIT;
end sp_js_zyyyinsert;
/
