docker run --rm -ti -w /current -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/current --volumes-from gcloud-config yurifrl/gcloud
