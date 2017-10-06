# Intro

This is a little application that uses the vpe-challenge API of Whitepages.

# Building the Application

You do not need any paticular version of ruby.  But you do need Docker installed.

Clone the git repository.  Then from tthe root of the project directoy do:
```bash
make build
```

I like to use a Makefile for managing Docker applications.  Makes it easier when
you doing things for multiple different languages.  It also is helpful for 
automating deployments.

Type:
```bash
make help
```
or look in the Makefile to see what it provides.

# Running the application

If you have have vpe-challenge already running somewhere you can edit the file
prod.env and change the key WP_SERVICE_URL to the proper URL.

You can then just type:
```bash
make run
```
The website can be viewed on http://localhost:8080

This launches the container named "ray-vpe" in detached mode.
You anc view the logs comeing on stdout if you type:
```bash
docker logs -f ray-vpe
```

Alternatively, you can also use docker-compose to launch both the front end
and back end together.  However, you will first need to edit the file
challenge-api.env to enter the PRO_API_KEY value and enter a valid key.

The just type:
```bash
docker-compose up
```
Logs for both of the containers will flow - but they are color coded.

# Logging

I've set up logging to go to stdout.  This is the docker way.  However,
many companies do it differently - not sure what WP is doing.  At YP we
had set up a Graylog environment to send logs, others use syslog.  This is
easy to change to fit into your infrustructure.

# Running tests

TODO

# Notes for improvement

Well there can many improvements as this was done in only two days.
The code is simplistic at this point and could be more robust in every area.

TODO
