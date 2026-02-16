# Webserv – HTTP/1.1 Server in C++

A lightweight, non-blocking HTTP/1.1 web server written in modern C++.  
Built to run inside Docker and designed to be tested directly in a browser.

Developed by **M. Haan**, **J. van der Laan**, and **C. ter Maat**.

---

## Overview

Webserv is a custom-built HTTP server that:

- Listens on multiple ports
- Serves static websites
- Supports file uploads
- Executes CGI scripts
- Handles concurrent clients using `poll()`
- Implements core HTTP/1.1 features
- Runs fully inside Docker

The project follows the official subject specification (`webserver_subject.pdf`) located in the root of the repository.

---

## Features

### Multi-Port Support
Configure multiple listening ports through the configuration file.

### Static Website Hosting
Supports:
- `GET`
- `POST`
- `DELETE`

Serves static files directly from configured root directories.

### File Uploads
Users can upload files via HTTP POST requests.

### Non-Blocking I/O
Uses `poll()` to monitor multiple client connections simultaneously.  
This allows efficient concurrent request handling without blocking the main server loop.

### CGI Support
Executes CGI scripts for dynamic content generation.

### HTTP/1.1 Compliance
Implements:
- Persistent connections
- Multipart handling
- Proper response formatting
- Standard HTTP status codes

### Custom Error Pages
Supports customizable default error pages.

---

## Components Developed by Chavert

- **Dockerfile**
- **Makefile**
- `main.cpp` – error handling, parsing, initialization, main loop
- `Signals.cpp / Signals.hpp` – graceful shutdown & signal handling
- `ClientConnection.cpp / ClientConnection.hpp`
- `ServerConnection.cpp / ServerConnection.hpp`
- `log.cpp / log.hpp` – structured logging system

---

## Docker Setup
Docker ensures a controlled and reproducible build environment.
Download Docker:  
https://www.docker.com/

### Available Make Targets

| Command        | Description |
|---------------|------------|
| `make build`  | Build Docker image |
| `make run`    | Build (if needed) and start container |
| `make stop`   | Stop and remove container |
| `make clean`  | Remove Docker image |
| `make re`     | Rebuild image and run container |
| `make fclean` | Remove containers and images |
| `make status` | Check container status |

---

## Building the Project

From the root of the repository:

make build
make run

This starts an interactive Docker shell.

Inside the container:

make

To rebuild:

make re


## Running the Server

Inside the Docker shell:

./webserv basic_config.txt

Then open your browser:

http://localhost:8080/index.html

Or use any port defined in basic_config.txt.

To stop the server:

CTRL + C


## Memory Leak Testing (Valgrind)

Valgrind detects memory leaks and invalid memory usage.

Inside the container:

make
valgrind --leak-check=full ./webserv basic_config.txt

Then access the server via browser as usual.

Stop with:

CTRL + C


## Stress Testing with Siege

Siege allows benchmarking under heavy load.

Start the server inside Docker:

./webserv basic_config.txt

In a new terminal:

siege -b -c250 -t2M http://localhost:8080/index.html

Parameters explained:

-b     Runs in benchmark mode (no delay between requests)
-c250  Simulates 250 concurrent users
-t2M   Runs the test for 2 minutes

After completion, review the Siege performance report.

Stop the server with:

CTRL + C
