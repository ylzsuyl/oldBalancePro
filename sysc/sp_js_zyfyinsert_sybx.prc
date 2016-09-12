create or replace procedure sp_js_zyfyinsert_sybx
(
  pi_fwwdbh  in char,
  pi_czy000  in char,
  po_ret out number
)
is
  v_sqlerrm   varchar2(512);
  del_zyfytj_err  exception;
  ins_zyfytj_err  exception;
begin
  commit;
  --set transaction use rollback segment jf_rbs;
  begin  --清空临时表数据
    delete from js_temp_zyfytj_sybx where fwwdbh like pi_fwwdbh||'%';
    delete from js_temp_zyfytj_sybx where fwwdbh like pi_fwwdbh||'%';
    UPDATE yy_zysfb0
      set   qsrq00 = null
    where fwwdbh like pi_fwwdbh||'%' and qsrq00 in (select substr(qsrq00,1,6)||'05' from vw_js_arg) and zylb00='15' ;
  exception when others then
    v_sqlerrm := sqlerrm;
    raise del_zyfytj_err;
  end;
  begin --插入门诊费用临时统计表
    insert into js_temp_zyfytj_sybx
    (  fwwdbh,  gzzt00,  wdjbbh,  fzxbh0,
       sfcs00,  --收费次数
          xjzfje,  --现金支付金额  (--除了大病之外)
          zhzfje,  --帐户支付金额  (--除了大病之外)
          jjzfje,  --基金支付金额  (--除了大病之外)
          zzfje0,  --总支付金额
                   dbzhzf,  --大病帐户支付
                   dbgrzf,  --大病个人支付
                   dbjjzf,  --大病基金支付
                   TSXMFY,  -- 特殊项目费用
                   YBGRFY,  -- 政策部分自费
                   FYBFY0,  -- 非医保费用汇总
                   FYBZH0   --
    )
    select   fwwdbh,  gzzt00,  wdjbbh,  fzxbh0,
       sfcs00,  --收费次数
          xjzfje,  --现金支付金额  (--除了大病之外)
          zhzfje,  --帐户支付金额  (--除了大病之外)
          jjzfje,  --基金支付金额  (--除了大病之外)
          zzfje0,  --总支付金额
          dbzhzf,  --大病帐户支付
                   dbgrzf,  --大病个人支付
                   dbjjzf,  --大病基金支付
                   TSXMFY,  -- 特殊项目费用
                   YBGRFY,  -- 政策部分自费
                   FYBFY0,  -- 非医保费用汇总
                   FYBZH0   --
    from vw_js_zyfytj_sybx
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
      values(PO_RET,'清空临时表数据出错!',v_sqlerrm,'sp_js_zyfyinsert_sybx',pi_fwwdbh,pi_czy000);
    COMMIT;
  when ins_zyfytj_err then
     PO_RET := -7122;
    insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
      values(PO_RET,'插入住院费用临时统计表出错!',v_sqlerrm,'sp_js_zyfyinsert_sybx',pi_fwwdbh,pi_czy000);
    COMMIT;
  when others then
     PO_RET := -7123;
    v_sqlerrm := sqlerrm;
    insert into js_errlog(cwh000,jdcwxx,xxcwxx,ccdf00,czdx00,czy000)
      values(PO_RET,'插入住院结算临时表出现以外错误!',v_sqlerrm,'sp_js_zyfyinsert_sybx',pi_fwwdbh,pi_czy000);
    COMMIT;
end sp_js_zyfyinsert_sybx;
/
