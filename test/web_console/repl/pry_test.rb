require 'test_helper'

class PryTest < ActiveSupport::TestCase
  setup do
    @pry1 = @pry = WebConsole::REPL::Pry.new
    @pry2 = WebConsole::REPL::Pry.new
  end

  test 'sending input returns the result as output' do
    assert_equal sprintf(return_prompt, "42\n"), @pry.send_input('foo = 42')
  end

  test 'session preservation requires same bindings' do
    assert_equal sprintf(return_prompt, "42\n"), @pry1.send_input('foo = 42')
    assert_equal sprintf(return_prompt, "42\n"), @pry2.send_input('foo')
  end

  test 'multi-line support' do
    assert_equal "", @pry.send_input('class A')
    assert_equal sprintf(return_prompt, "nil\n"), @pry.send_input('end')
    assert_equal sprintf(return_prompt, "A\n"), @pry.send_input('A')
  end

  test "prompt isn't nil" do
    assert_not_nil @pry.prompt
  end

  test 'rails helpers are available in the session' do
    each_rails_console_method do |meth|
      assert_no_match undefined_var_or_method(meth), @pry.send_input("respond_to? :#{meth}")
    end
  end

  private
    def return_prompt
      "=> %s"
    end

    def undefined_var_or_method(name)
      %r{undefined local variable or method `#{name}'}
    end

    def each_rails_console_method(&block)
      require 'rails/console/app'
      require 'rails/console/helpers'
      Rails::ConsoleMethods.public_instance_methods.each(&block)
    end
end
