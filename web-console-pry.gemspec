$:.push File.expand_path("../lib", __FILE__)

require "web_console/repl/pry/version"

Gem::Specification.new do |s|
  s.name     = "web-console-pry"
  s.version  = WebConsole::REPL::Pry::VERSION
  s.authors  = ["Genadi Samokovarov", "Guillermo Iguaran"]
  s.email    = ["gsamokovarov@gmail.com", "guilleiguaran@gmail.com"]
  s.homepage = "https://github.com/gsamokovarov/web-console-pry"
  s.summary  = "Rails Console on the Browser."

  s.files      = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  # Uncomment once web-console is released.
  s.add_dependency "web-console", "~> 0.1.0"
  s.add_dependency "pry", "~> 0.9.11"

  s.add_development_dependency "rails", "~> 4.0.0"
  s.add_development_dependency "sqlite3"
end
