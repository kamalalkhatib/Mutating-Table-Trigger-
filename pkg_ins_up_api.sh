create or replace package ins_updt_pkg as
procedure titl_ins_pro(p_empid emp_job_title.empid%type,
p_pos_id emp_job_title.pos_id%type,p_st_dt date,p_ed_dt date default null);
procedure titl_updt_pro(p_empid emp_job_title.empid%type,
p_st_dt date,p_ed_dt date);
end;
====================>
create or replace package body ins_updt_pkg
  2  as
  3  procedure TITL_INS_PRO(p_empid emp_job_title.empid%type,
  4  p_pos_id emp_job_title.pos_id%type,p_st_dt date,p_ed_dt date default null)
  5  is
  6	  v_mx_ed_dt date;
  7	  v_cnt number(2);
  8  /*     cursor c_emp_title is select * from emp_job_title
  9	  where empid=p_empid;
 10	  for update;
 11	 v_emp_title c_emp_title%rowtype;*/
 12	 BEGIN
 13    for i in(select * from emp_job_title where empid=p_empid
 14    for update)loop
 15    if (p_st_dt>= i.st_date and p_st_dt<= i.ed_date)or
 16    (p_st_dt < i.st_date and p_ed_dt >= i.st_date) THEN
 17    raise_application_error(-20001,'date overlapping not allowed');
 18    end if;
 19    end loop;
 20    insert into emp_job_title(empid,pos_id,st_date,ed_date)
 21    values(p_empid,p_pos_id,trunc(p_st_dt),trunc(p_ed_dt));
 22    commit;
 23    exception when others then
 24    error_mgr.log_error('TITL_INS_PRO');
 25    raise;		
 26  end;
 27  procedure titl_updt_pro(p_empid emp_job_title.empid%type,
 28  p_st_dt date,p_ed_dt date)
 29  is
 30	  v_mx_ed_dt date;
 31	  v_cnt number(2);
 32  cursor c_emp_title is select * from emp_job_title
 33	  where empid=p_empid
 34	  for update;
 35	 v_emp_title c_emp_title%rowtype;
 36	 BEGIN
 37	 for i in(select * from emp_job_title where empid=p_empid
 38	    for update)loop
 39	    if (p_st_dt < i.st_date and p_ed_dt >= i.st_date) THEN
 40	    raise_application_error(-20001,'date overlapping not allowed');
 41	    end if;
 42	end loop;
 43	update emp_job_title set ed_date=p_ed_dt
 44	     where empid=p_empid
 45	     and   trunc(st_date)=trunc(p_st_dt);
 46	commit;
 47	exception when others then
 48	error_mgr.log_error('TITL_UPDT_PRO');
 49	raise;
 50  end;
 51* end;
