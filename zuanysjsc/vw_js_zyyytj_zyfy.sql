create or replace view vw_js_zyyytj_zyfy
(id0000, zylsh0, zhzfje, xjzfje, jjzfje, bcbxf0, dbzhzf, dbgrzf, dbjjzf)
as
select
   a.id0000  ,  a.zylsh0  ,
   nvl(sum(b.zhzfe0),0) ,
	nvl(sum(b.grzfe0),0) ,
	nvl(sum(b.jjzfe0),0) ,
	nvl(sum(b.bcbxf0),0) ,
	nvl(sum(b.dbzhzf),0) ,
	nvl(sum(b.dbgrzf),0) ,
	nvl(sum(b.dbjjzf),0)
from yy_zydjb0 a,yy_zysfb0 b,vw_js_arg d
where a.zydjh0 is not null  and  a.cxbz00='Z'  and
      b.zylsh0=a.zylsh0     and
      a.cyrq00 <> '*' and A.CYRQ00<= D.JZRQ00 AND
      (
         b.sfrq00 between d.qsrq00 and d.jzrq00  or
         (b.sfrq00 < d.qsrq00 and b.qsrq00 is null) OR
         B.QSRQ00  between d.qsrq00 and d.jzrq00 -- ÒÔÍùÎ´½áËã¼ÇÂ¼
      )
group by a.id0000,a.zylsh0
;
