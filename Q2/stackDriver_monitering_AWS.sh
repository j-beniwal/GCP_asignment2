################################################ STACKDRIVER MONITERING AWS EC2 INSTANCE ####################################################
# Configure Stackdriver monitoring on an AWS EC2 instance using the monitoring agent. 
# Also explore how to monitor both AWS and GCP projects at a single place.
#############################################################################################

# Adding an AWS account to a Workspace requires that you create a Google Cloud Platform (GCP) 
# project to serve as the host project for the workspace
# after workspacae cretion add aws account to the workspace.

# Steps to connect the aws account to monitering.
1. Select the GCP project "pe-training"
2. We are working in an existing workspace "PE-TRAINING" Workspace

# configure workspace 
1. go to stackdriver monitoring console
2. Next to the Stackdriver logo in the title bar, a Workspace name is displayed. 
3. At thee bottom of the Workspace menu, click Workspace Settings.
4. Under Settings, click Monitored accounts.
5. Click Add AWS account.
6. Record the Account ID and External ID. Needed this data to create AWS Role.
7. Click Cancel. You add AWS account after creating AWS role.

# creating an aws role
1. To create your AWS role needed to authorize Stackdriver, we must have the Account ID and External ID
2. Log into the AWS IAM console and click Roles in the left side menu.
3. Click Create New Role and do the following:
    For the Role type, select Another AWS account.
    In the Account ID field, enter the account ID provided by Stackdriver.
    Select the Require external ID checkbox.
    In the External ID field, enter the external ID provided by Stackdriver.
    Dont select Require MFA.
    Click Next: Permission
4. From the Policy name drop-down list, select ReadOnlyAccess:
5. Click Next: Review and fill in or verify the following information:
    In the Role name field, enter a name such as GoogleStackdriver.
    In the Role description field, enter anything you wish.
    In the Trusted entities field, verify its the Account ID you entered earlier.
    In the Policies field, verify the value is ReadOnlyAccess.
6. In the AWS IAM page, click Create Role.
7. On the Summary page, copy the Role ARN string so that you can give it to Stackdriver. 

# connecting an aws account
1. Go to stackdriver monitoring console.
2. From the workspace manu on the top of the page click workspace setting.
3. Under setting click monitored account.
4. Click add AWS account
5. In role ARN field, enter Role ARN
6. In descriptin fiel give brif descriptin of the account.
7. Click add aws account in a moment the account is added.
8. When we connect to an aws account, monitoring creates an AWS connector project.
9. This can be seen in the monitored account page in workspace setting.

# Authorizing AWS applications
* To authorize applications running on AWS to access GCP services, give them access to a GCP service account that has suitable GCP IAM roles.
* single service account can authorize multiple AWS VM instances and applications in the same AWS account,
* or we can create multiple service accounts.

#Create a service account
* Service accounts are managed in the GCP Console, not in the Stackdriver Monitoring console.
1. To create the service account, go to the IAM & Admin > Service accounts page for connector project
2. Select the AWS connector project for AWS account.
3. Your connector project likely has no service accounts, so you are asked to create one.
   Click Create service account and enter the following information:
    In the Service account name field, enter Stackdriver agent authorization.
    In the Role field, add both of the following values:
        Monitoring > Monitoring Metric Writer
        Logging > Logs Writer
    Select the Furnish a new private key checkbox.
    For Key type, click JSON.
    Clear the Enable G Suite Domain-wide Delegation checkbox.
4. Click Create. The service accounts private-key file is downloaded to your workstation
5. save the location of the credentials file in the variable CREDS on your workstation
	CREDS="Downloads/[PROJECT_NAME]-[KEY_ID].json"

# add service account to vm instance 
1. From your workstation, copy the Stackdriver private-key credentials file to AWS EC2 instance and save it in a file named temp.json.
2. In the scp command, specify the path to key.pem, AWS SSH key pair file, and provide AWS credentials:
	KEY="/path/to/key.pem"
	scp -i "$KEY" "$CREDS" AWS_USERNAME@AWS_HOSTNAME:temp.json
3. On your EC2 instance, move the credentials to "/etc/google/auth/application_default_credentials.json"	
	GOOGLE_APPLICATION_CREDENTIALS="/etc/google/auth/application_default_credentials.json"
	sudo mkdir -p $(dirname "$GOOGLE_APPLICATION_CREDENTIALS")
	sudo mv "$HOME/temp.json" "$GOOGLE_APPLICATION_CREDENTIALS"

# installation of agents
1. Install the Stackdriver Monitoring and Logging agents by running the following commands on your EC2 instance
	curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
	sudo bash install-monitoring-agent.sh

	curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
	sudo bash install-logging-agent.sh --structured

2. varify agents are running 
	ps ax | grep fluentd
	ps ax | grep collectd

# using stackdriver services with AWS
  follows the steps to running stackdriver services on ec2 instances.
# Create an uptime check
  will create an uptime check which moniters the web server and notifies on failer
1. Go to stackdriver monitoring cnsole.
2. Click on the Create an uptime check on home page.
3. Fill details in uptime check window.
	In the Title field, enterMy Uptime Check.
	In the Check type drop-down list, select HTTP.
	In the Resource Type drop-down list,choose instance
	Select the instance.
	Click save and test for testing
# creating alerting policy
1. a window pops up after creating uptime check for creating alerting policy
2. click create alearting policy
3. fill details and click save.
4. In notification channel type select email and enter email 
5. Name the policy and save and exit.


