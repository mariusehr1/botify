# Botify Flaskr

The following projet will deploy a Flask project into a remote machine with minimal setup: it contains an ansible script that will install all the necessary dependencies for your application to run. It will run as a docker image wrapped in a systemd service: the application will be server on port 8080.



## Requirements

- Two machines running systemd 
- The webserver should have a user named ubuntu user pre-added 
- This user should also have the sudo privilege without password : the following entry has to be added to /etc/sudoers beforehand
```
ubuntu  ALL=(ALL) NOPASSWD: ALL
```
- A Git client
- Ansible
- During this tutorial, i'll be connecting to localhost on port 2222 for the webserver but feel free to change it in ./ansible/hosts and replace localhost by your hosts adress as well as the port in the next commands.

## Usage

1 - Clone the repository 

```
git clone https://github.com/mariusehr1/botify.git
cd botify
```

2 - Setup SSH keys between your servers parameters are as follow : name, host, port

```
./scripts/gen_keypair.sh ubuntu localhost 2222
```
3 - You are now ready to run the playbook : it will call both playbooks in the ansible directory

```
ansible-playbook -i ./ansible/hosts ./ansible/docker_deploy.yml
```
3 - If everything went as expected, wait a few seconds to let the container spin up and look at your application running
```
curl -vv localhost:8080
```

## Troubleshooting

Test connection with the host. If needed, rerun the scripts gen_keypair.sh
```
ansible webservers -m ping
./scripts/gen_keypair.sh ubuntu localhost 2222
```

Rerun the playbook with verbosity.
```
ansible-playbook deploy.yml -vvvv
```
Check the systemd service logs on the webserver 
```
journalctl -u botify.service
```

## Answering questions

 #### - How would you publish this application in HTTPS mode?

 I would probably expose it through a reverse-proxy such as Nginx or Apache and use Certbot as an easy way to generate/update TLS certificates.

 #### - Which points would you improve on the security aspects? on other aspects?
 
 Improvements such as running a lighter Docker image with a non-root user would be a plus. Also, the Ansible procedure requires quite a few privileges by running as sudo, that could be minimized by allowing the binding user to only use docker without a password when running docker commands. I would probably have a separated database in order to share it across containers. As for the code itself, it would be more convinient to initalize the database during the app.run() phase, because running it with flask I had to manually initialize it within the container which is probably not a best practice. Having a an externalized config would also be a plus.

 #### - How do you plan to backup the application?

 I could write a scripts that would periodically backup all of my running instances : for example something that would backup the SQL every 12/24h ; it would exec the container and output a file which could then be restored if needed. 

 #### - How do you plan to deploy the application with a minimal customer impact?
 
 Assuming we are working with bare VM's only, I would have two applications server running and a loadbalancer in order to manage traffic and deploy smoothly, in that regard monitoring is also key.

 #### - How would you ​scale​ this application so it can serve a high number of requests?

 I would use a more stateless mechanism (e.g externalizing the database) in order to share it across multiple instances. I would probably use a tool like Kubernetes in order to have fully scalable infrastructure and application.
