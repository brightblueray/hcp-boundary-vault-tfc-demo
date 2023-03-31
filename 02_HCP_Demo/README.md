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