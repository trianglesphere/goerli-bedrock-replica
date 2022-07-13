up:
	./up.sh

down:
	docker-compose down

clean:
	docker-compose down
	docker image ls 'goerli-bedrock-replica*' --format='{{.Repository}}' | xargs -r docker rmi
	docker volume ls --filter name=goerli-bedrock-replica --format='{{.Name}}' | xargs -r docker volume rm

.PHONY: up down clean