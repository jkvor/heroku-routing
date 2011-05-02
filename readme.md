# heroku-routing
 
Create an app that will be routed to:

    $ heroku create --stack capstan

Create a route:

    $ heroku routes:create
    Creating route... done
    ip://11.323.234.12:58679

    $ heroku routes
    Route                         Processes
    ----------------------------  ----------------------------
    ip://11.323.234.12:58679

Start a process that will serve as the endpoint:

    $ heroku ps:run 'nc -l $PORT'
    Running `nc -l $PORT` attached to terminal... up, ps.2

In another terminal, attach the route to the process:

    $ heroku routes:attach ip://11.323.234.12:58679 ps.2
    Attaching route ip://11.323.234.12:58679 to ps.2... done

    $ heroku routes
    Route                         Processes
    ----------------------------  ---------------------------- 
    ip://11.323.234.12:58679      ps.2

Then connect to the endpoint process via the route:

    $ heroku ps:run 'telnet 11.323.234.12 58679'
    Running `telnet 11.323.234.12 58679` attached to terminal... up, ps.3
    Trying 11.323.234.12...
    Connected to 11.323.234.12.
    Escape character is '^]'
    hello, route!

You should see `hello, route!` in the terminal of the `nc` process.

While your telnet connection is still open, detach the route from the process:

    $ heroku routes:detach ip://11.323.234.12:58679
    Detaching route ip://11.323.234.12:58679... done
    
    $ heroku routes
    Route                         Processes
    ----------------------------  ----------------------------
    ip://11.323.234.12:58679      

You should still be able to communicate over your existing connection, but
subsequent attempts will fail now that the route has been detach.

To permanently destroy the route:

    $ heroku routes:destroy ip://11.323.234.12:58679
    Destroying route ip://11.323.234.12:58679... done
