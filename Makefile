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
clean c:
	#rm -f $(GOPATH)/bin/$(CLIENT) $(GOPATH)/bin/$(SERVER)
	rm -f bin/*
#----------------------------------------------------------------------------------
run r:
	@echo "make (run:r) [client|server]"
run-client rc:
	$(CLIENT) -host 172.17.0.1 -realm teamgrit -user=stoney=kang
run-client-test rct:
	PIONS_LOG_INFO=all $(CLIENT) -host 172.16.16.96 -realm teamgrit -user=stoney=kang -ping
run-server rs:
	PIONS_LOG_INFO=all USERS=stoney=kang REALM=teamgrit UDP_PORT=3478 CHANNEL_BIND_TIMEOUT=100ms $(SERVER)
#----------------------------------------------------------------------------------
docker d:
	@echo "make (docker:d) [build]"

IMAGE=teamgrit/pion-turn:0.0.1
docker-build db:
	#docker build -t $(IMAGE) . -f Dockerfile.multi
	docker build -t $(IMAGE) . -f Dockerfile
	docker images $(IMAGE)
	docker system prune

docker-run dr:
	docker run -i -t $(IMAGE) 
#----------------------------------------------------------------------------------
git g:
	@echo "make (git:g) [update|store]"
git-update gu:
	git add .gitignore *.md Makefile go.??? turn-client/ turn-server/ Dockerfile*
	git commit -m "Add dockerfiles including multi-stage"
	git push
git-store gs:
	git config credential.helper store
#----------------------------------------------------------------------------------

