#
# Makefile for testing turn example
#
CLIENT=turn-client
SERVER=turn-server
.PHONY: usage edit build clean docker compose git
#----------------------------------------------------------------------------------
usage:
	@echo "make [edit|build|run|docker|compose]"
#----------------------------------------------------------------------------------
edit e:
	@echo "make (edit:e) [client|server|history]"
edit-client ec:
	vi $(CLIENT)/main.go
edit-server es:
	vi $(SERVER)/main.go
edit-history eh:
	vi HISTORY.md
#----------------------------------------------------------------------------------
build b:
	CGO_ENABLED=0 GO111MODULE=on GOOS=linux go build -o bin/$(CLIENT) $(CLIENT)/main.go
	CGO_ENABLED=0 GO111MODULE=on GOOS=linux go build -o bin/$(SERVER) $(SERVER)/main.go
	@cp bin/* $(GOPATH)/bin
	ls -al $(GOPATH)/bin/turn-*
clean:
	#rm -f $(GOPATH)/bin/$(CLIENT) $(GOPATH)/bin/$(SERVER)
	rm -f bin/*
	docker system prune
#----------------------------------------------------------------------------------
run r:
	@echo "make (run:r) [client|server]"
run-client rc:
	$(CLIENT) -host 172.17.0.1 -realm teamgrit -user=stoney=kang
run-client-test rct:
	PIONS_LOG_INFO=all $(CLIENT) -host 172.16.16.96 -realm teamgrit -user=stoney=kang -ping
run-server rs:
	PIONS_LOG_INFO=all USERS=stoney=kang REALM=teamgrit UDP_PORT=3478 CHANNEL_BIND_TIMEOUT=1000ms $(SERVER)
#----------------------------------------------------------------------------------
TAG=0.0.2
NAME=teamgrit/pion-turn
IMAGE=$(NAME):$(TAG)

docker d:
	@echo "make (docker:d) [build|run|push]"
docker-build db:
	docker build -t $(IMAGE) . -f Dockerfile
	docker images $(NAME)
docker-build-multi dbm:
	docker build -t $(IMAGE) . -f Dockerfile.multi
	docker images $(NAME)
docker-run dr:
	docker run -i -t $(IMAGE) 
docker-push dp:
	docker push $(IMAGE)
#----------------------------------------------------------------------------------
compose c:
	@echo "make (compose:c) [up|down|status]"
compose-up cu:
	docker-compose up -d
	docker-compose ps
compose-down cd:
	docker-compose down
compose-status cs:
	docker-compose ps
#----------------------------------------------------------------------------------
git g:
	@echo "make (git:g) [update|store]"
git-update gu:
	git add .gitignore *.md Makefile go.??? turn-client/ turn-server/ Dockerfile* *.yml
	git commit -m "Write slack interface"
	git push
git-store gs:
	git config credential.helper store
#----------------------------------------------------------------------------------

