require 'test_helper'

class PryTest < ActiveSupport::TestCase
  private
    def undefined_var_or_method(name)
      %r{undefined local variable or method `#{name}'}
    end

    def each_rails_console_method(&block)
      require 'rails/console/app'
      require 'rails/console/helpers'
      Rails::ConsoleMethods.public_instance_methods.each(&block)
    end
end
