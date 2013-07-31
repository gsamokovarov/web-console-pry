$:.push File.expand_path("../lib", __FILE__)

require "web_console/repl/pry/version"

Gem::Specification.new do |s|
  s.name     = "web-console-pry"
  s.version  = WebConsole::REPL::Pry::VERSION
  s.authors  = ["Genadi Samokovarov", "Guillermo Iguaran"]
  s.email    = ["gsamokovarov@gmail.com", "guilleiguaran@gmail.com"]
  s.homepage = "https://github.com/gsamokovarov/web-console-pry"
  s.summary  = "Pry adapter for Web Console."

  s.license = "MIT"

  s.files      = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "web-console", "~> 0.1.0"
  s.add_dependency "pry", "~> 0.9.11"

  s.add_development_dependency "rails", "~> 4.0.0"
  s.add_development_dependency "sqlite3"
end
