create or replace procedure sp_bank_statement(p_cusid in number,p_type in number,p_from in date,p_to in date,p_statement out sys_refcursor) as
stmnt_qry varchar2(4000);
begin
stmnt_qry :='(select * from tts_bank_statement where customer_id= '||p_cusid||' order by transaction_on desc)';
if p_type=1 then
stmnt_qry :='select * from '||stmnt_qry||' where rownum<=3';
open p_statement for stmnt_qry;
elsif p_type=2 then
stmnt_qry :='select * from '||stmnt_qry||' where rownum<=10';
open p_statement for stmnt_qry;
else
stmnt_qry :='select * from '||stmnt_qry||' where transaction_on between '||p_from||' and '||p_to;
open p_statement for stmnt_qry;
end if;
end;
