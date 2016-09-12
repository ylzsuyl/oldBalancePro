create or replace view vw_js_zyyytj
(zydjh0, yfwwd0, xfwwd0, fzxbh0, tcjjlx, id0000, jsrq00, xxly00, bckbcs, zhzfje, xjzfje, jjzfje, zbxfje, dbzhzf, dbgrzf, dbjjzf)
as
select
   a.zydjh0      ,
   a.yfwwdh      ,
   a.xfwwdh      ,
   a.fzxbh0      ,
   e.tcjjlx      ,    --new add by Chenj on 20040322
   b.id0000      ,
   c.cyrq00      ,
   a.xxxly0      ,
   a.xkbcs0      ,
   nvl(b.zhzfje,0)  ,
	nvl(b.xjzfje,0)  ,
	nvl(b.jjzfje,0)  ,
	nvl(b.bcbxf0,0)  ,
	nvl(b.dbzhzf,0)  ,	--大病帐户支付
	nvl(b.dbgrzf,0)  ,	--大病个人支付
	nvl(b.dbjjzf,0)   	--大病基金支付
from yy_zyyydj a,vw_js_zyyytj_zyfy b,yy_zydjb0 c,vw_js_arg d,bm_tcjjlx e
where a.xxxly0='1'      and a.zydjh0=c.zydjh0    and
      a.xlsh00=c.zylsh0 and a.cxbz00='Z'         and
      c.cyrq00 <> '*'  and  c.zylsh0 = b.zylsh0  and
      a.gzzt00=e.gzzt00
union
select
   a.zydjh0         ,
   a.yfwwdh         ,
   a.xfwwdh         ,
   a.fzxbh0         ,
   d.tcjjlx         ,
   a.id0000         ,
   b.bxrq00         ,
   a.xxxly0         ,
   a.xkbcs0         ,
	nvl(b.zhzfe0,0)  ,
	nvl(b.grzfe0,0)  ,
	nvl(b.jjzfe0,0)  ,
	nvl(b.bcbxf0,0)  ,
	nvl(b.dbzhzf,0)  ,	--大病帐户支付
	nvl(b.dbgrzf,0)  ,	--大病个人支付
	nvl(b.dbjjzf,0)   	--大病基金支付
from yy_zyyydj a,yy_bxsfb0 b,vw_js_arg c,bm_tcjjlx d
where a.xxxly0='2' and a.zydjh0=b.zydjh0   and
      a.xlsh00=b.djlsh0 and b.jzlb00='02'  and
      a.cxbz00='Z' and b.cxbz00 = 'Z'      and
      a.gzzt00=d.gzzt00 and
      b.bxrq00 between c.qsrq00 and c.jzrq00
;
