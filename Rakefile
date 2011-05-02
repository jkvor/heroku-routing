FOLDER = "~/.heroku/plugins/heroku-routing"

desc "install via copy"
task "install" do
  sh "rm -rf #{FOLDER}; mkdir -p #{FOLDER} && cp -R . #{FOLDER}"
end

desc "install via symlink"
task "install:link" do
  sh "rm -rf #{FOLDER}; ln -s #{File.dirname(__FILE__)} #{FOLDER}"
end
