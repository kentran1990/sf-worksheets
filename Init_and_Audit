 CREATE USER IF NOT EXISTS STREAMLIT_ADMIN WITH PASSWORD = 'SNOW@123snow';

use role securityadmin ;
create role STREAMLIT_ADMIN;
grant ownership on database STREAMLIT_TEST_DATA to role STREAMLIT_ADMIN;
grant ownership on all schemas in database STREAMLIT_TEST_DATA to role STREAMLIT_ADMIN copy current grants;
grant ownership on all tables in schema STREAMLIT_TEST_DATA.SCH to role STREAMLIT_ADMIN copy current grants;

grant usage on warehouse COMPUTE_WH to role STREAMLIT_ADMIN;
grant usage on database SNOWFLAKE_SANDBOX_DB to role STREAMLIT_ADMIN;

grant role STREAMLIT_ADMIN to user STREAMLIT_ADMIN;

grant usage on database STREAMLIT_TEST_DATA to role ACCOUNTADMIN;
grant usage on all schemas in database STREAMLIT_TEST_DATA to role ACCOUNTADMIN;
grant select, insert, delete, update on all tables in schema STREAMLIT_TEST_DATA.SCH to role ACCOUNTADMIN;


create or replace TABLE STREAMLIT_TEST_DATA.SCH.EMPLOYEES_3 (
	ID number identity,
    FULLNAME VARCHAR(100),
	DEPARTMENT VARCHAR(100)
);

select * from STREAMLIT_TEST_DATA.SCH.EMPLOYEES_3;

insert into STREAMLIT_TEST_DATA.SCH.EMPLOYEES_3 (FULLNAME,DEPARTMENT) values('A','D1');

-- Audit log. Please note the database and schema is the one that Streamlit App stored in.
select USER_NAME,ROLE_NAME,database_name,schema_name,WAREHOUSE_NAME,QUERY_TEXT,QUERY_TYPE,CONVERT_TIMEZONE('America/Los_Angeles','Pacific/Auckland',START_TIME),START_TIME,ROWS_DELETED,ROWS_INSERTED,ROWS_UPDATED,IS_CLIENT_GENERATED_STATEMENT
from snowflake.account_usage.QUERY_HISTORY
where 1=1
and database_name = 'STREAMLIT_TEST_DATA' AND schema_name = 'PUBLIC'
and execution_status = 'SUCCESS'
and QUERY_TYPE in ('DELETE','UPDATE','INSERT')
and query_text like '%STREAMLIT_TEST_DATA.SCH.EMPLOYEES_3%'
--and (ROWS_DELETED <> 0 OR ROWS_INSERTED <> 0 OR ROWS_UPDATED <> 0)
order by start_time desc
; 



select * from STREAMLIT_TEST_DATA.SCH.EMPLOYEES_3;
