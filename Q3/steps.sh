############################################################################################################################
# Create an instance with Linux OS of your choice.
# The instance should run apache server that displays your name when the webpage is accessed via a browser. 
# The task should be completed without accessing the instance via SSH. 
# Stop the instance (using CLI) and restart the instance (again using CLI) and check again if the apache server is running. 
# View the log file of the server startup.
############################################################################################################################

# STEPS 

# create an instance with linux os and an startup script which runs the apache server
gcloud compute instances create j-instance-q3 --machine-type ubuntu-1804-bionic-v20190628 --metadata-from-file startup-script=/home/jeevan/Documents/assignment/GCP/assignment2/Q3/server.sh --zone us-central1
	# file server.sh attached

# stop the instance using command line
gcloud compute instances stop j-instance-q3 --zone us-central1

# restart instance 
gcloud compute instances start j-instance-q3 --zone us-central1

# view th log file of the server startup.
# Activity logging is enabled by default for all Compute Engine projects
# Installing stackdriver agents gives the deeper insight of the logs.
# Instal stackdriver agents by running the below command in the instance .
# we can automate this by writing these commands in startup script
curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
sudo bash install-monitoring-agent.sh
# In google cloud platform console go to vm instances 
# Serch the instance click on the logging to see the logs.

