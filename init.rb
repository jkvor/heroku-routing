class Heroku::Client
  def routes(app_name)
    JSON.parse(get("/apps/#{app_name}/routes").to_s)
  end

  def routes_create(app_name)
    JSON.parse(post("/apps/#{app_name}/routes").to_s)
  end

  def route_assoc(app_name, url, ps)
    put("/apps/#{app_name}/routes/assoc", {"url" => URI.escape(url), "ps" => URI.escape(ps)})
  end

  def route_dissoc(app_name, url, ps)
    put("/apps/#{app_name}/routes/dissoc", {"url" => URI.escape(url), "ps" => URI.escape(ps)})
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
      group.command "routes:assoc   <url> <ps>", "associate a process to a route"
      group.command "routes:dissoc  <url> <ps>", "dissociate a process from a route"
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

    def assoc
      url = args.shift
      ps = args.shift || abort("Usage: heroku routes:assoc <url> <ps>")
      display("Associating route #{url} to #{ps}... ", false)
      heroku.route_assoc(app, url, ps)
      display("done")
    end

    def dissoc
      url = args.shift
      ps = args.shift || abort("Usage: heroku routes:dissoc <url> <ps>")
      display("Dissociating route #{url} from #{ps}... ", false)
      heroku.route_dissoc(app, url, ps)
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
