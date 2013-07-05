require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'pry'

Bundler.require(*Rails.groups)
require "web_console"
require "web_console_pry"

module Dummy
  class Application < Rails::Application
    config.console = Pry
  end
end
