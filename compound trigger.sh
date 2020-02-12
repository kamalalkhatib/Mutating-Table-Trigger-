CREATE OR REPLACE TRIGGER pos_stdate_trg
	      FOR UPDATE OR INSERT ON pos_tst_trg
  	      COMPOUND TRIGGER
  		     type t_ed_date is table of pos_tst_trg.ed_date%type
  	     index by pls_integer;
  	     v_ed_date t_ed_date;
  	     type t_empid is table of pos_tst_trg.empid%type
  		  index by pls_integer;
  	     v_empid t_empid;
 	     v_st_date t_ed_date;
 	     BEFORE STATEMENT IS
 		    BEGIN
 	     SELECT empid,st_date,ed_date bulk collect
 	     INTO v_empid,v_st_date,v_ed_date
 		       FROM pos_tst_trg;
 		     END BEFORE STATEMENT;
 	      AFTER EACH ROW IS
 		     BEGIN
 		      FOR indx IN 1 .. v_empid.count
 			LOOP
 	     IF v_empid(indx)=:new.empid AND
   (trunc(:new.st_date)>= trunc(v_st_date(indx))
   and trunc(:new.st_date)<= trunc(v_ed_date(indx)))
	or
  trunc(:new.st_date) < trunc(v_st_date(indx))
  and trunc(:new.ed_date) >= trunc(v_st_date(indx)) THEN
 		     raise_application_error(-20001,'date overlapping is not allowed');END IF;
 		END LOOP;
 	  END AFTER EACH ROW;
   END pos_stdate_trg;