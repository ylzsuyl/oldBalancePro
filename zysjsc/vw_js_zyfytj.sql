create or replace view vw_js_zyfytj
(fwwdbh, gzzt00, wdjbbh, fzxbh0, sfcs00, xjzfje, zhzfje, jjzfje, zzfje0, dbzhzf, dbgrzf, dbjjzf, tsxmfy, ybgrfy, fybfy0, fybzh0)
as
select
 a.fwwdbh,a.gzzt00,a.wdjbbh,a.fzxbh0,
 count(a.djlsh0),
 sum(nvl(a.grzfe0,0)),
 sum(nvl(a.zhzfe0,0)),
 sum(nvl(a.jjzfe0,0)),
 SUM(NVL(A.BCBXF0,0)),         --总支付金额
 sum(a.dbzhzf),                --大病帐户支付
 sum(a.dbgrzf),                --大病个人支付
 sum(a.dbjjzf),                --大病基金支付
 sum(d.tsxmfy),
 sum(nvl(d.ybgrfy,0)),         --政策部分自费
 SUM(D.FYBFY0),
 SUM(DECODE(sign(abs(a.zhzfe2) - abs(D.fybfy0)),1,D.fybfy0,a.zhzfe2))
from yy_zysfb0 a,yy_zydjb0 b,vw_js_arg c,
     (select y.djlsh0 djlsh0,SUM(TSXMFY) TSXMFY,sum(nvl(ybgrfy,0)) ybgrfy,sum(nvl(fybfy0,0)) fybfy0
      from yy_zyfpfy x,yy_zysfb0 y ,vw_js_arg Z
      where x.djlsh0=y.djlsh0 AND y.zylb00<>'13' AND y.zylb00<>'15' and
            (y.sfrq00 between z.qsrq00 AND z.jzrq00 or
            (y.sfrq00 < z.qsrq00 AND y.qsrq00 IS NULL) )
      group by y.djlsh0) d
where a.zylsh0 = b.zylsh0 and  b.fwwdbh=a.fwwdbh  and
      d.djlsh0 = a.djlsh0 and  b.cyrq00 <> '*' and
      b.cyrq00 <= c.jzrq00 and
      (  a.sfrq00 between c.qsrq00 and c.jzrq00  or
         (a.sfrq00 < c.qsrq00 and a.qsrq00 is null)  -- 以往未结算记录
      ) and a.zylb00<>'13' and b.zylb00<>'13'
      and a.zylb00<>'15' and b.zylb00<>'15'   --生育保险不结算
group by a.fwwdbh,a.gzzt00,a.wdjbbh,a.fzxbh0
;
