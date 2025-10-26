# -----------------------------
# TP #2 - Redis Data Management
# -----------------------------

# Variables
PYTHON = python3
FLASK_APP = app.py
REDIS_SERVICE = redis-server

# === General Commands ===
help:
	@echo "Available commands:"
	@echo "  make install       -> Install dependencies (Python + Node)"
	@echo "  make redis-start   -> Start Redis server"
	@echo "  make redis-stop    -> Stop Redis server"
	@echo "  make redis-status  -> Check Redis status"
	@echo "  make test-python   -> Run Python Redis test"
	@echo "  make flask-run     -> Run Flask API server"
	@echo "  make node-run      -> Run collaborative Node.js server"
	@echo "  make clean         -> Remove caches and temp files"

# === Setup ===
install:
	sudo apt update
	sudo apt install -y redis-server
	pip install -r requirements.txt
	npm install express socket.io redis

# === Redis Commands ===
redis-start:
	sudo service $(REDIS_SERVICE) start

redis-stop:
	sudo service $(REDIS_SERVICE) stop

redis-status:
	sudo service $(REDIS_SERVICE) status

# === Python Test ===
test-python:
	@echo "Running Redis Python test..."
	$(PYTHON) -c "import redis; r=redis.Redis(host='localhost', port=6379); print('PING =>', r.ping())"

# === Flask Service ===
flask-run:
	FLASK_APP=$(FLASK_APP) FLASK_ENV=development $(PYTHON) -m flask run

# === Node Service ===
node-run:
	node server.js

# === Clean up ===
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	rm -rf node_modules
