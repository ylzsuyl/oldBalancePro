CREATE OR REPLACE PROCEDURE SP_JS_gwybz_mzfpfy_ts
(v_qsrq00 IN char,
 v_jzrq00 IN char,
 v_ret OUT number)
as
 type cursor_type is ref cursor;
 mycursor cursor_type;
 v_mine yy_mzsfb0%rowtype;
 ls_ybfy00  NUMBER(10,2);
 ls_ybgrfy  NUMBER(10,2);
 ls_fybfy0  NUMBER(10,2);
 ls_mlnbl0  NUMBER(5,4);
 ls_mlwbl0  NUMBER(5,4);
 ls_mlnbz0  NUMBER(10,2);
 ls_mlwbz0  NUMBER(10,2);
 ls_GWYBZ0  NUMBER(10,2);--公务补助总和
 ls_GWBZN0  NUMBER(10,2);--公务补助内
 ls_GWBZW0  NUMBER(10,2);--公务补助外
 ls_CZBZN0  NUMBER(10,2);--财政补助内
 ls_CZBZW0  NUMBER(10,2);--财政补助外
 LS_CNT     NUMBER;
 notfound boolean;
begin
open mycursor for
Select * From yy_mzsfb0 Where gwyjb0 in ('11','12','13')  And sfrq00>=v_qsrq00 And sfrq00<=v_jzrq00 
and bqbm00 in (select bqbm00 from bm_bqbmb0 where sftsmz = 'Y') and sfrq00 >='20100201' 
and gwybz0 is not null and gwybz0<>0 and JSFSBH='03' and  qsrxm0 is not null 
and qsrq00 is not null Order By sfrq00;
    loop
        fetch mycursor into v_mine;
        notfound:=mycursor%notfound;
        exit when notfound;

        --统计公务员补助费用
        select sum(ybfy00),sum(ybgrfy),sum(fybfy0) into ls_ybfy00,ls_ybgrfy,ls_fybfy0 from yy_mzfpfy where djlsh0=v_mine.djlsh0;
        commit;

      --取公务员补助比例
      --select mlnbl0,mlwbl0 into ls_mlnbl0,ls_mlwbl0  from bm_gwyblb where dqbh00='01' and jsfsbh='03' and gwyjb0=v_mine.gwyjb0;
        select mlnbl0,mlwbl0 into ls_mlnbl0,ls_mlwbl0  from bm_gwyblb where jsfsbh='03' and gwyjb0=v_mine.gwyjb0 and dqbh00=v_mine.dqbh00
        AND v_mine.Sfrq00 BETWEEN QSRQ00 AND JZRQ00;

        --计算实际公务员补助费用
         ls_mlnbz0:=(ls_ybfy00+ls_ybgrfy-v_mine.jjzfe0-v_mine.DBJJZF)*ls_mlnbl0;
         ls_CZBZN0:=(ls_ybfy00+ls_ybgrfy-v_mine.jjzfe0-v_mine.DBJJZF)*(ls_mlnbl0-0.9);
         ls_GWBZN0:=ls_mlnbz0-ls_CZBZN0;

         ls_mlwbz0:=ls_fybfy0*ls_mlwbl0;
         ls_CZBZW0:=ls_fybfy0*(ls_mlwbl0-0.4);
         ls_GWBZW0:=v_mine.gwybz0-ls_CZBZN0-ls_GWBZN0-ls_CZBZW0;    
             
       --ls_GWBZW0:=ls_mlwbz0-ls_CZBZW0;
         ls_GWYBZ0:=ls_GWBZN0+ls_CZBZN0+ls_CZBZW0+ls_GWBZW0;
        SELECT COUNT(1) INTO LS_CNT FROM yy_mzfpfy_gwyb0_ts_other WHERE DJLSH0 = v_mine.djlsh0;
        
        IF LS_CNT = 0 THEN
        --插入公务员补助表
        insert into yy_mzfpfy_gwyb0_ts_other (djlsh0,ybfy00,ybgrfy,fybfy0,ID0000,XMING0,BCBXF0,JJZFE0,ZHZFE0,
        GRZFE0,GWYBZ0,GWYJB0,DBJJZF,MLNBL0,MLWBL0,SFRQ00,CZBZN0,CZBZW0,GWBZN0,GWBZW0,fzxbh0,fwwdbh)
           values (v_mine.djlsh0,ls_ybfy00,ls_ybgrfy,ls_fybfy0,v_mine.id0000,
           v_mine.XMING0,v_mine.BCBXF0,v_mine.JJZFE0,v_mine.ZHZFE0,v_mine.GRZFE0,
           ls_GWYBZ0,v_mine.GWYJB0,v_mine.DBJJZF,ls_mlnbl0,ls_mlwbl0,v_mine.SFRQ00,
           ls_CZBZN0,ls_CZBZW0,ls_GWBZN0,ls_GWBZW0,v_mine.fzxbh0,v_mine.fwwdbh);
        commit;
        END IF;
    end loop;
close mycursor;
    v_ret := 1;
       exception
       --返回太多值，返回-2
       when too_many_rows then
           v_ret := -2;
           rollback;
       --违反唯一约束，返回0
       when dup_val_on_index then
           v_ret := 0;
           rollback;
       --其他，返回-1
       when others then
           v_ret := -1;
           rollback;
END SP_JS_gwybz_mzfpfy_ts;
/
