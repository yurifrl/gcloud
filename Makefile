all:
	docker build -t yurifl/gcloud .
	docker push yurifl/gcloud
