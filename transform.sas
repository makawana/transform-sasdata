%macro SAStoXPT (location= );

libname OUT "&location";

proc sql;
 create table DSETS as select MEMNAME, MEMLABEL 
   from DICTIONARY.TABLES
    where MEMTYPE eq 'DATA' and upcase(LIBNAME) eq 'OUT';
quit;

data _NULL_;
 set DSETS;
  call symput ('DSET' || trim(left(put(_N_,best.))), trim(left(MEMNAME)));
  call symput ('LABL' || trim(left(put(_N_,best.))), trim(left(MEMLABEL)));
  call symput ('ALLD', trim(left(put(_N_,best.))));
run;

%do i=1 %to &ALLD;
  libname TRANFILE xport "&location/&&dset&i...xpt";

  data out.&&dset&i (label="&&labl&i");
    set out.&&dset&i;
  run;

  proc copy in=out out=TRANFILE;
    select &&dset&i;
  run;

  libname TRANFILE clear;
%end;

%mend SAStoXPT;
