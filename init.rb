require "heroku/version"

if Heroku::VERSION < "2.0.0"
  raise "heroku gem 2.0.0 or later required"
end

require "heroku/client/routes"
require "heroku/command/routes"
