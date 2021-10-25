-- vacuum and analyze
vacuum lineorder;
analyze lineorder;

select count(a.*) from lineorder a;
