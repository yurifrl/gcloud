# Log in to gcloud
- docker volume create --name=gcloud-data
- dg gcloud init
- dg gcloud beta auth application-default login

# Get cluster credentials
- dg gcloud container clusters get-credentials <cluster-name> --zone=<zone>

# Run stuff
- ./dg kubectl cluster-info

# create docker machine
- dg docker-machine create --driver google --google-project <project-id> --google-zone us-east1-d --google-machine-type n1-standard-1 ucp-master

