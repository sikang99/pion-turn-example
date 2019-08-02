#
# Makefile for turn test
#
CLIENT=turn-client
SERVER=turn-server
.PHONEY:usage edit
#----------------------------------------------------------------------------------
usage:
	@echo "make [edit|build|run]"
#----------------------------------------------------------------------------------
edit e:
	@echo "make (edit:e) [client|server]"
edit-client ec:
	vi $(CLIENT)/main.go
edit-server es:
	vi $(SERVER)/main.go
#----------------------------------------------------------------------------------
build b:
	GO111MODULE=on go build -o $(CLIENT)/$(CLIENT) $(CLIENT)/main.go
	GO111MODULE=on go build -o $(SERVER)/$(SERVER) $(SERVER)/main.go
	@mv $(CLIENT)/$(CLIENT) $(GOPATH)/bin
	@mv $(SERVER)/$(SERVER) $(GOPATH)/bin
	ls -al $(GOPATH)/bin/$(CLIENT) $(GOPATH)/bin/$(SERVER)
clean c:
	rm -f $(CLIENT)/$(CLIENT) $(SERVER)/$(SERVER)
	rm -f $(GOPATH)/bin/$(CLIENT) $(GOPATH)/bin/$(SERVER)
#----------------------------------------------------------------------------------
run r:
	@echo "make (run:r) [client|server]"
run-client rc:
	#$(CLIENT) -host 172.17.0.1 -realm teamgrit -user=stoney=kang -ping
	$(CLIENT) -host 172.17.0.1 -realm teamgrit -user=stoney=kang
run-server rs:
	PIONS_LOG_INFO=all USERS=stoney=kang REALM=teamgrit UDP_PORT=3478 CHANNEL_BIND_TIMEOUT=100ms $(SERVER)
#----------------------------------------------------------------------------------
docker d:
	@echo "make (docker:d) [build]"
docker-build db:
	docker build -t teamgrit/pion-turn:0.0.1 .
#----------------------------------------------------------------------------------
git g:
	@make clean
	git add README.md Makefile turn-client/ turn-server/
	git commit -m "New repo created for pion turn test"
	git push


