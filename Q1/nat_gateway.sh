######################################################## CLOUD NAT ############################################################
# Cloud NAT (Network address translation) allows GCP vm without externial ip to connect ot internet.
# Cloud NAT implement outbound NAT in conjunction with default route to allow the instance to reach the internet.
# it does not implement the inbound NAT.

###### Steps: #################
# 1. first set up the project 
gcloud config set project pe-training

# 2. Create a vpc network and subnet 
gcloud compute networks create j-neetwork-q1 --subnet-mode custom

# 3. Specify the subnet prefix for first region assigning 192.168.2.0/24 to region us-central1
gcloud compute networks subnets create j-subnet-us-central-192 --neetwork j-neetwork-q1 --region us-central1 --range 192.168.2.0/24

# 4. Create a bastion host for testing as 
	# To test Cloud NAT, you must use a test VM instance that has no external IP address. 
	# But, you cannot directly connect via SSH to an instance that doesn't have an external IP address. 
	# To connect to the instance that doesn't have an external IP address, 
	# you must first connect to an instance that does have an external IP address, 
	# then connect to the other instance via internal IP addresses.
	# So create a bastion host VM
	# and use this instance to connect to the test instance 
gcloud compute instances create j-bastion-q1 --image-family debian-9 --image-project debian-cloud --network j-neetwork-q1 --subnet j-subnet-us-central-192 --zone us-central1-c

# 5. Create a VM instance with no external IP address
gcloud compute instances create j-nat-test-q1 --image-family debian-9 --image-project debian-cloud --network j-neetwork-q1 --subnet j-subnet-us-central-192 --zone us-central1-c --no-address

# 6. Create a firewall rule that allows SSH connections
gcloud compute firewall-rules create j-allow-ssh --network j-neetwork-q1 --allow tcp:22

# 7. Log into nat-test-1 and confirm that it cannot reach the Internet
	# Add a Compute Engine SSH key to your local host. 
ssh-add ~/.ssh/google_compute_engine
	# Connect to bastion-1:
gcloud compute ssh j-bastion-q1 --zone us-central1-c -- -A
	# From bastion-1, connect to j-nat-test-q1
ssh j-nat-test-q1 -A
	# From nat-test-1, attempt to connect to the Internet
curl example.com # * obtained no result as it is not connected to internet

# 8. Create a NAT configuration using Cloud Router
	# cloud router must be created in the same region as the instance that uses Cloud NAT 
	# Cloud nat is only used to place NAT information onto the VMs.
	# it is not used as a part of the actual NAT gateway.
	# this configuration allows all instances in the region to use Cloud NAT for primery and alies ip ranges 
	# create a router
gcloud compute routers create j-nat-router --network j-neetwork-q1 --region us-central1
	# add a configuration to the router
gcloud compute routers nats create j-nat-config --router-region us-central1 --router j-nat-router --nat-all-subnet-ip-ranges --auto-allocate-nat-external-ips
	
# 9. Attempt to connect to internet
curl example.com

