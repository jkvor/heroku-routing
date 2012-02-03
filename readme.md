# heroku-routing

Install the heroku-routing client plugin:

    $ heroku plugins:install https://github.com/JacobVorreuter/heroku-routing

Create an app using the node template:

    $ git clone git@github.com:JacobVorreuter/hello-node.git
    Initialized empty Git repository in /private/tmp/hello-node/.git/
    remote: Counting objects: 26, done.
    remote: Compressing objects: 100% (13/13), done.
    remote: Total 26 (delta 12), reused 26 (delta 12)
    Receiving objects: 100% (26/26), done.
    Resolving deltas: 100% (12/12), done.

    $ cd hello-node/

    $ heroku create --stack cedar
    Creating blazing-mist-4424... done, stack is cedar
    http://blazing-mist-4424.herokuapp.com/ | git@heroku.com:blazing-mist-4424.git
    Git remote heroku added
    $ git push heroku master
    Counting objects: 26, done.
    Delta compression using up to 2 threads.
    Compressing objects: 100% (13/13), done.
    Writing objects: 100% (26/26), 2.43 KiB, done.
    Total 26 (delta 12), reused 26 (delta 12)

    -----> Heroku receiving push
    -----> Node.js app detected
    -----> Fetching Node.js binaries
    -----> Vendoring node 0.4.7
    -----> Installing dependencies with npm 1.0.94
           express@2.1.1 ./node_modules/express 
           ├── mime@1.2.4
           ├── qs@0.4.0
           └── connect@1.8.3
           Dependencies installed
    -----> Discovering process types
           Procfile declares types -> web
    -----> Compiled slug size is 6.9MB
    -----> Launching... done, v2
           http://blazing-mist-4424.herokuapp.com deployed to Heroku

    To git@heroku.com:blazing-mist-4424.git
     * [new branch]      master -> master

Create a TCP route:

    $ heroku routes:create
    Creating route... done
    tcp://route.heroku.com:26393

List routes:

    $ heroku routes
    Route                         Process 
    ----------------------------  ----------
    tcp://route.heroku.com:26393              

Attach your web.1 process to your TCP route:

    $ heroku routes:attach tcp://route.heroku.com:26393 web.1
    Attaching route tcp://route.heroku.com:26393 to web.1... done

    $ heroku routes
    Route                         Process 
    ----------------------------  ----------
    tcp://route.heroku.com:26393  web.1

Connect to your TCP endpoint:

    $ telnet route.heroku.com 26393
    Trying 107.20.247.209...
    Connected to ec2-107-20-247-209.compute-1.amazonaws.com.
    Escape character is '^]'.
    HEAD / HTTP/1.1

    HTTP/1.1 200 OK
    Connection: keep-alive

    body complete

    ^C

Destroy your route:

    $ heroku routes:destroy tcp://route.heroku.com:26393 
    Destroying route tcp://route.heroku.com:26393... done

