class Heroku::Client
  def routes(app_name)
    JSON.parse(get("/apps/#{app_name}/routes").to_s)
  end

  def routes_create(app_name)
    JSON.parse(post("/apps/#{app_name}/routes").to_s)
  end

  def route_attach(app_name, url, ps)
    put("/apps/#{app_name}/routes/attach", {"url" => URI.escape(url), "ps" => URI.escape(ps)})
  end

  def route_detach(app_name, url, ps)
    put("/apps/#{app_name}/routes/detach", {"url" => URI.escape(url), "ps" => URI.escape(ps)})
  end

  def route_destroy(app_name, url)
    delete("/apps/#{app_name}/routes?url=#{URI.escape(url)}", {})
  end
end

module Heroku::Command
  class Routes < BaseWithApp
    Help.group("Routing") do |group|
      group.command "routes",                    "list all routes"
      group.command "routes:create",             "create a route"
      group.command "routes:attach  <url> <ps>", "attach a process to a route"
      group.command "routes:detach  <url> <ps>", "detach a process from a route"
      group.command "routes:destroy <url>",      "destroy a route"
    end

    def index
      routes = heroku.routes(app)
      output = []
      output << "Route                         Processes                   "
      output << "----------------------------  ----------------------------"
      routes.each do |route|
        output << "%-28s  %-12s" % [route["url"], route["ps"]]
      end
      display(output.join("\n"))
    end

    def create
      display("Creating route... ", false)
      route = heroku.routes_create(app)
      display("done")
      display(route["url"])
    end

    def attach
      url = args.shift
      ps = args.shift || abort("Usage: heroku routes:attach <url> <ps>")
      display("Associating route #{url} to #{ps}... ", false)
      heroku.route_attach(app, url, ps)
      display("done")
    end

    def detach
      url = args.shift
      ps = args.shift || abort("Usage: heroku routes:detach <url> <ps>")
      display("Dissociating route #{url} from #{ps}... ", false)
      heroku.route_detach(app, url, ps)
      display("done")
    end

    def destroy
      route_id = args.shift || abort("Usage: heroku routes:destroy <url>")
      display("Destroying route #{route_id}... ", false)
      heroku.route_destroy(app, route_id)
      display("done")
    end
  end
end
