create or replace procedure sp_customer_transaction 
(
p_cusid in number,
p_amount in number,
p_trans_whom in varchar2,
p_trans_mode in varchar2,
p_type in varchar2,
p_msg out varchar2 
)as
ltransid varchar2(20) :='TTSTRANSID0000';
lbal number;
lcheck number;
ldlimt number;
lsmamnt number;
begin
if p_type=1 then
select customer_main_balance into lbal from tts_bank_customers  where customer_id=p_cusid;
if p_amount<= lbal then

select daily_limit into ldlimt from tts_bank_customers where customer_id=p_cusid;
select sum(transaction_amount) into lsmamnt from tts_bank_customers_dbt where customer_id=p_cusid and 
trunc(transaction_date)=trunc(systimestamp);

lcheck:=ldlimt-(lsmamnt+p_amount);

if lcheck<0 then
p_msg:='daily limit exceeded please check your daily limt ';

else

insert into tts_bank_customers_dbt 
values(ltransid ||sqtransid.nextval,p_cusid,p_amount,systimestamp,p_trans_whom,p_trans_mode);
select customer_main_balance into lbal from tts_bank_customers  where customer_id=p_cusid;
commit;
p_msg:='amount debited and you account balance is'||lbal;

end if;


else
p_msg:='insufficent funds';
end if;

elsif p_type=2 then
insert into tts_bank_customers_cdt 
values(ltransid ||sqtransid.nextval,p_cusid,p_amount,systimestamp,p_trans_whom,p_trans_mode);
select customer_main_balance into lbal from tts_bank_customers  where customer_id=p_cusid;
commit;
p_msg:='amount credited and you account balance is '||lbal;
end if;
end;
