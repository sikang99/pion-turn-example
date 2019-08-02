#
# Makefile for testing turn example
#
CLIENT=turn-client
SERVER=turn-server
.PHONEY:usage edit
#----------------------------------------------------------------------------------
usage:
	@echo "make [edit|build|run]"
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
	@echo "make (docker:d) [build]"
docker-build db:
	docker build -t $(IMAGE) . -f Dockerfile
	docker images $(NAME)
docker-build-multi dbm:
	docker build -t $(IMAGE) . -f Dockerfile.multi
	docker images $(NAME)
docker-run dr:
	docker run -i -t $(IMAGE) 
#----------------------------------------------------------------------------------
compose c:
	@echo "make (compose:c) [up|down]"
compose-run cr:
	docker-compose up
compose-down cd:
	docker-compose down
#----------------------------------------------------------------------------------
git g:
	@echo "make (git:g) [update|store]"
git-update gu:
	git add .gitignore *.md Makefile go.??? turn-client/ turn-server/ Dockerfile* *.yml
	git commit -m "Add docker-compose.yml file"
	git push
git-store gs:
	git config credential.helper store
#----------------------------------------------------------------------------------

