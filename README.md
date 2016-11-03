# Log in to gcloud
docker run -ti --name gcloud-config yurifl/gcloud gcloud init
docker run --rm -ti --volumes-from gcloud-config yurifl/gcloud gcloud beta auth application-default login

# Get cluster credentials
docker run --rm -ti --volumes-from gcloud-config yurifl/gcloud gcloud container clusters get-credentials <cluster-name> --zone=<zone>

# Run stuff
./dg.sh

# create docker machine
dg docker-machine create --driver google --google-project <project-id> --google-zone us-east1-d --google-machine-type n1-standard-1 ucp-master

