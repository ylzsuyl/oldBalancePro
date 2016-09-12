CREATE OR REPLACE PROCEDURE SP_JS_gwybz_zyfpfy_yd
(v_qsrq00 IN char,
v_jzrq00 IN char,
v_ret OUT number)
as
 type cursor_type is ref cursor;
 mycursor cursor_type;
 v_mine yy_zysfb0%rowtype;
 ls_ybfy00  NUMBER(10,2);
 ls_ybgrfy  NUMBER(10,2);
 ls_fybfy0  NUMBER(10,2);
 ls_mlnbl0  NUMBER(5,4);
 ls_mlwbl0  NUMBER(5,4);
 ls_mlnbz0  NUMBER(10,2);
 ls_mlwbz0  NUMBER(10,2);
 ls_GWYBZ0  NUMBER(10,2); --�������ܺ�
 ls_GWBZN0  NUMBER(10,2); --��������
 ls_GWBZW0  NUMBER(10,2); --��������
 ls_CZBZN0  NUMBER(10,2); --����������
 ls_CZBZW0  NUMBER(10,2); --����������
 notfound boolean;
begin
open mycursor for
    Select * From yy_zysfb0 Where gwyjb0 in ('11','12','13') And sfrq00>=v_qsrq00 And sfrq00<=v_jzrq00 and fwwdbh like 'YD%'
    And zylb00 Not In ('11','12','13') and  gwybz0 is not null and gwybz0<>0 and sfrq00 >='20100201' Order By sfrq00;
   loop
        fetch mycursor into v_mine;
        notfound:=mycursor%notfound;
        exit when notfound;

        --ͳ�ƹ���Ա��������
        select sum(ybfy00),sum(ybgrfy),sum(fybfy0) into ls_ybfy00,ls_ybgrfy,ls_fybfy0 from yy_zyfpfy where djlsh0=v_mine.djlsh0;
        commit;

        --ȡ����Ա��������
        select mlnbl0,mlwbl0 into ls_mlnbl0,ls_mlwbl0  from bm_gwyblb where jsfsbh='02' and gwyjb0=v_mine.gwyjb0 and dqbh00=v_mine.dqbh00;

        --����ʵ�ʹ���Ա��������
         ls_mlnbz0:=(ls_ybfy00+ls_ybgrfy-v_mine.jjzfe0-v_mine.DBJJZF)*ls_mlnbl0;
         ls_CZBZN0:=(ls_ybfy00+ls_ybgrfy-v_mine.jjzfe0-v_mine.DBJJZF)*(ls_mlnbl0-0.9);

         ls_mlwbz0:=ls_fybfy0*ls_mlwbl0;
         ls_CZBZW0:=ls_fybfy0*(ls_mlwbl0-0.4);
         ls_GWBZW0:=ls_mlwbz0-ls_CZBZW0;

         ls_GWYBZ0:=v_mine.gwybz0;
         ls_GWBZN0:=ls_GWYBZ0-ls_CZBZN0-ls_GWBZW0-ls_CZBZW0;

        --���빫��Ա������
        insert into yy_zyfpfy_gwyb0_other(djlsh0,ybfy00,ybgrfy,fybfy0,ID0000,XMING0,BCBXF0,JJZFE0,ZHZFE0,
          GRZFE0,GWYBZ0,GWYJB0,DBJJZF,MLNBL0,MLWBL0,SFRQ00,CZBZN0,CZBZW0,GWBZN0,GWBZW0,fzxbh0,fwwdbh,QSRQ00)
           values (v_mine.djlsh0,ls_ybfy00,ls_ybgrfy,ls_fybfy0,v_mine.id0000,
           v_mine.XMING0,v_mine.BCBXF0,v_mine.JJZFE0,v_mine.ZHZFE0,v_mine.GRZFE0,
           ls_GWYBZ0,v_mine.GWYJB0,v_mine.DBJJZF,ls_mlnbl0,ls_mlwbl0,v_mine.SFRQ00,
           ls_CZBZN0,ls_CZBZW0,ls_GWBZN0,ls_GWBZW0,v_mine.fzxbh0,v_mine.fwwdbh,v_mine.SFRQ00);
        commit;
    end loop;
close mycursor;
    v_ret := 1;
       exception
       --����̫��ֵ������-2
       when too_many_rows then
           v_ret := -2;
           rollback;
       --Υ��ΨһԼ��������0
       when dup_val_on_index then
           v_ret := 0;
           rollback;
       --����������-1
       when others then
           v_ret := -1;
           rollback;
END SP_JS_gwybz_zyfpfy_yd;
/
