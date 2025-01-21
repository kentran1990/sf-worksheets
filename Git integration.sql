-- 1. Create secret
create database myco_db;
create schema myco_db.integrations;
create role myco_db_owner;

grant ownership on database myco_db to myco_db_owner;
grant ownership on schema myco_db.integrations to myco_db_owner;
grant role myco_db_owner to user QRIOUSTRAINING;
grant role myco_secrets_admin to user QRIOUSTRAINING;

USE ROLE securityadmin;
CREATE ROLE myco_secrets_admin;
GRANT CREATE SECRET ON SCHEMA myco_db.integrations TO ROLE myco_secrets_admin;

--REVOKE CREATE SECRET ON SCHEMA myco_db.integrations from ROLE myco_secrets_admin;

USE ROLE myco_db_owner;
GRANT USAGE ON DATABASE myco_db TO ROLE myco_secrets_admin;
GRANT USAGE ON SCHEMA myco_db.integrations TO ROLE myco_secrets_admin;

USE ROLE myco_secrets_admin;
USE DATABASE myco_db;
USE SCHEMA myco_db.integrations;

CREATE OR REPLACE SECRET myco_git_secret
  TYPE = password
  USERNAME = 'gladyskravitz'
  PASSWORD = 'ghp_token';

  show secrets;


  -- 2. Create API integration
USE ROLE securityadmin;
CREATE ROLE myco_git_admin;
grant role myco_git_admin to user qrioustraining;
use role accountadmin;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE myco_git_admin;

USE ROLE myco_db_owner;
GRANT USAGE ON DATABASE myco_db TO ROLE myco_git_admin;
GRANT USAGE ON SCHEMA myco_db.integrations TO ROLE myco_git_admin;

USE ROLE myco_secrets_admin;
GRANT USAGE ON SECRET myco_git_secret TO ROLE myco_git_admin;

USE ROLE myco_git_admin;
USE DATABASE myco_db;
USE SCHEMA myco_db.integrations;

CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/kentran1990')
  ALLOWED_AUTHENTICATION_SECRETS = (myco_git_secret)
  ENABLED = TRUE;  

  show INTEGRATIONs;

  -- 3. Create repository stage
  USE ROLE securityadmin;
GRANT CREATE GIT REPOSITORY ON SCHEMA myco_db.integrations TO ROLE myco_git_admin;

USE ROLE myco_git_admin;

CREATE OR REPLACE GIT REPOSITORY snowflake_extensions
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = myco_git_secret
  ORIGIN = 'https://github.com/kentran1990/sf-worksheets.git';


  -- AAA
  SHOW GIT BRANCHES IN snowflake_extensions;
