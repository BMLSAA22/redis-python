# ----------------------------
# Variables
# ----------------------------
FLASK_APP=app.py
NODE_SERVER=front-app/server.js

# ----------------------------
# Redis
# ----------------------------
install-redis:
	sudo apt update && sudo apt install -y redis-server

start-redis:
	sudo systemctl start redis-server
	sudo systemctl enable redis-server

stop-redis:
	sudo systemctl stop redis-server

restart-redis:
	sudo systemctl restart redis-server

status-redis:
	sudo systemctl status redis-server

test-redis:
	redis-cli ping

# ----------------------------
# Python (Flask)
# ----------------------------
install-python-deps:
	pip install --upgrade pip
	pip install flask redis

run-flask:
	FLASK_APP=$(FLASK_APP) flask run &

# ----------------------------
# Node.js (Formulaire collaboratif)
# ----------------------------
install-node-deps:
	npm install express socket.io redis

run-node:
	node $(NODE_SERVER) &

setup: install-redis install-python-deps install-node-deps start-redis

# ----------------------------
# Tout lancer simultanément
# ----------------------------
run-all: start-redis run-flask run-node
	@echo "Tout est lancé ! Accédez à Flask et Node.js."

# ----------------------------
# Nettoyage
# ----------------------------
stop-all:
	-sudo pkill -f server.js
	-sudo pkill -f flask
	-sudo systemctl stop redis-server
	@echo "Tous les serveurs ont été arrêtés."
