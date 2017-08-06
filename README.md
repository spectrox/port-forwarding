
# Publish ports on a remote host

Having troubles testing pushes/pixels/callbacks queried from external services with all your code running on localhost?

This example shows how to publish ports on a remote host with ssh server running in docker.

What's inside?

- Vagrantfile with multiple virtual network interfaces preconfigured. It's here for tests.
- Dockerfile having ssh server inside for port forwarding/publishing.
- Bash script to create containers and clear unused automatically.

## How to use it (soft way)

Copy scripts from `bin` to your proxy server and get docker running.
Build docker image, then start server with `server-new-agent.sh <port1> <port2> ...` specifying ports you want to publish.
Start ssh tunnel from your working machine to proxy server.

Clear old containers with `server-clear-hanging.sh` (just add it to cron).

P.S. Scripts are prepared for a multi-interface machine where you have at least one free interface for ports publishing without any open connections.

## How to use it (hard way)

Assuming we want to publish ports on 192.168.50.8. On the server we're starting docker container, exposing ports 22 and 80 on specified interface - 192.168.50.8 (ports 22 and 8080 used inside the container).

Reverse tunneling port 80 from 192.168.50.8 to our local machine with ssh tunnel.

Basically, for tests you'll have to start vagrant with `vagrant up`,
login to it with `vagrant ssh`, change directory with `cd /var/www/sshd/`,
build docker container inside and start it.
When container is ready you can set ssh tunnel and check if all works as it should.

Docker container built from [standard how-to](https://docs.docker.com/engine/examples/running_ssh_service/) on the server side:

```bash
# Build container
sudo docker build -t eg_sshd .
```
Run container:

```bash
# Run container with port mappings
sudo docker run -d -p 192.168.50.8:2222:22 -p 192.168.50.8:80:8080 --name test_sshd eg_sshd
```

SSH tunnel on the client side:

```bash
ssh -R 0.0.0.0:8080:localhost:80 -N client@192.168.50.8 -p 2222
```

Start docker container, open tunnel, have fun.
