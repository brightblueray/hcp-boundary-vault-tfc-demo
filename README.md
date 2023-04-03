# Configure Vault for Demo

Boundary Tutorial: https://developer.hashicorp.com/boundary/tutorials/access-management/hcp-vault-cred-brokering-quickstart
RDS Tutorial: https://developer.hashicorp.com/terraform/tutorials/aws/aws-rds

AWS Links
https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html#API_CreateDBInstance_Examples
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.html
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts.General.DBVersions
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html


## Vault needs to be configured to generate secrets for the database target. To set up Vault you need to:

- Start Vault
- Set up a Boundary controller policy
- Enable the database secrets engine
- Configure the postgres database plugin
- Create a database admin role to generate credentials
- Create an analyst role to generate credentials


# Demo

- Set environment vars

`export BOUNDARY_AUTH_METHOD_ID=ampw_wnuoth3dgh`

`export BOUNDARY_ADDR=https://da193632-6017-4be7-ab6d-9598d83e9f88.boundary.hashicorp.cloud`

- login via CLI

`boundary authenticate password -auth-method-id=$BOUNDARY_AUTH_METHOD_ID -login-name=rryjewski`

- Analyst Session

`boundary connect postgres -target-id ttcp_xkYI5rDUli -dbname northwind`

- Kill Analyst Session from Admin GUI

- Finally Rotate Root Credentials

- Vault UI Secrets -> Database -> Connections -> Edit Configuration

`psql -h terraform-20230403005648174000000004.cne04tub3qaw.us-east-2.rds.amazonaws.com -p 5432 -U postgres -d northwind`

pwd: foobarbaz
