create or replace procedure sp_customer_details(p_cusid in number,p_details out sys_refcursor) as
begin
open p_details for
select customer_name,bank_location as home_branch,first_name as manager,customer_main_balance,acctype_name from
tts_bank_customers a,tts_banks b,tts_bank_acc_types c,tts_bank_emp d
where a.customer_home_branch=b.bank_id
and a.customer_acctype_id=c.acctype_id
and b.Bank_Manager_Id=d.employee_id
and a.customer_id=p_cusid;
end;
