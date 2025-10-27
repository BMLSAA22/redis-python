# Project Setup and Management

This project consists of a Flask backend and a Node.js collaborative form frontend, both using Redis for data storage and communication.

## Prerequisites

- Ubuntu/Debian-based Linux system
- Python 3.x
- Node.js and npm
- sudo privileges (for Redis installation)

## Project Structure

```
.
├── app.py                 # Flask application
├── front-app/
│   ├── server.js         # Node.js server with Socket.io
│   └── ...               # Frontend files
├── Makefile              # Build and run automation
└── README.md             # This file
```

## Quick Start

### Complete Setup (First Time)

Install all dependencies and start Redis:

```bash
make setup
```

This command will:
- Install Redis server
- Install Python dependencies (Flask, redis)
- Install Node.js dependencies (express, socket.io, redis)
- Start Redis server

### Run All Services

Launch Redis, Flask, and Node.js servers simultaneously:

```bash
make run-all
```

## Individual Commands

### Redis Management

```bash
# Install Redis
make install-redis

# Start Redis server
make start-redis

# Stop Redis server
make stop-redis

# Restart Redis server
make restart-redis

# Check Redis status
make status-redis

# Test Redis connection
make test-redis
```

### Python/Flask

```bash
# Install Python dependencies
make install-python-deps

# Run Flask application (background)
make run-flask
```

The Flask app will be available at `http://localhost:5000`

### Node.js Server

```bash
# Install Node.js dependencies
make install-node-deps

# Run Node.js server (background)
make run-node
```

The Node.js server configuration depends on your `server.js` file.

### Stop All Services

Stop all running servers (Flask, Node.js, and Redis):

```bash
make stop-all
```

## Troubleshooting

### Port Already in Use

If you get a "port already in use" error, stop all services first:

```bash
make stop-all
```

Then restart the services you need.

### Redis Connection Issues

Check if Redis is running:

```bash
make status-redis
```

Test the connection:

```bash
make test-redis
```

Expected output: `PONG`

### Services Not Starting

Make sure all dependencies are installed:

```bash
make setup
```

Check for error messages in the terminal output.

## Development

- **Flask app**: Edit `app.py` and restart with `make run-flask`
- **Node.js server**: Edit files in `front-app/` and restart with `make run-node`
- **Dependencies**: Add new dependencies to the appropriate `install-*-deps` target in the Makefile

## Notes

- Services run in the background (`&` at the end of commands)
- Redis requires sudo privileges for installation and service management
- Use `make stop-all` before closing your terminal to ensure clean shutdown

## License

[Add your license information here]