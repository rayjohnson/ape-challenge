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
You can view the logs coming on stdout if you type:
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
had set up a Graylog environment to send logs.  We also sent more structured
logs to better alert on errors and graph things like ingress and egress service times.

# Running tests

To run tests you can first type:
```bash
make shell
```

This puts you in the container in a bash shell.  It also sets RAILS_ENV=test.
So now you can run:
```bash
rake test
```
to see test results.  (Or run any other command you wish to test or debug.)

# Notes for improvement

Well there can many improvements as this was done in only two days.
The code is simplistic at this point and could be more robust in every area.

I don't have any client side validartion - which would be worth adding next.
The bootstrap validation stuff would make for a cleaner UI.  I probably 
would change the state field to be a drop down as well.

I also do not have a model of any sort which is not very ruby like.  I'd move
all the API exception handling out of the controller into that.  The app is
so simple that the model would not be that interesting right now - but it 
would be cleaner.

In the case when we do have a connection I'm just displaying the path.  Frankly,
I don't fully understand what it is giving me or how to use it.  This would,
of course, be the most important improvement to make...

# Going to production

This is a simple app - I'd assume it would get rolled into something larger.
Aside from making the app more useful, robust and bug free - we would also
want to tie into WP deployment and monitoring systems.

I'd expect we would want to use Jecnkins (or something like) to build this.
My Makefile can be adjusted to get a version number from a tag and Jenkins
can buid when new tags are cut.

For deployment we would want to package up a reference to a specific image
along with and app specific configs for kunernetes and the corrent env
file to QA and operations folks.  TYhis really should be done in a way
that enforces SOX and logs all changes to out environment.

Lastly we would want proper monitoring of the app and a way for developers
to access operational stats and view production logs.

