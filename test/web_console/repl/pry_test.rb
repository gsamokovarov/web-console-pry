require 'test_helper'

class PryTest < ActiveSupport::TestCase
  setup do
    @pry1 = @pry = WebConsole::REPL::Pry.new
    @pry2 = WebConsole::REPL::Pry.new
  end

  test 'sending input returns the result as output' do
    assert_equal return_prompt(42), @pry.send_input('foo = 42')
  end

  test 'session preservation requires same bindings' do
    assert_equal return_prompt(42), @pry1.send_input('foo = 42')
    assert_equal return_prompt(42), @pry2.send_input('foo')
  end

  test 'session isolation requires own bindings' do
    pry1 = WebConsole::REPL::Pry.new(Object.new.instance_eval('binding'))
    pry2 = WebConsole::REPL::Pry.new(Object.new.instance_eval('binding'))
    assert_equal return_prompt(42), pry1.send_input('foo = 42')
    assert_match %r{NameError}, pry2.send_input('foo')
  end

  test 'multiline support' do
    assert_equal '', @pry.send_input('class A')
    assert_equal return_prompt(nil), @pry.send_input('end')
    assert_equal return_prompt('A'), @pry.send_input('A.name')
  end

  test 'multiline support between threads' do
    assert_equal "", @pry.send_input('class A')
    Thread.new do
      assert_equal return_prompt(nil), @pry.send_input('end')
      assert_no_match %r{NameError}, @pry.send_input('A')
    end.join
  end

  test 'captures direct stdout output' do
    assert_equal "42\n#{return_prompt(nil)}", @pry.send_input('puts 42')
  end

  test 'captures direct stderr output' do
    assert_equal "42\n#{return_prompt(3)}", @pry.send_input('$stderr.write("42\n")')
  end

  test 'captures direct output from subprocesses' do
    assert_equal "42\n#{return_prompt(true)}", @pry.send_input('system "echo 42"')
  end

  test 'captures direct output from forks' do
    assert_match %r{42\n}, @pry.send_input('Process.wait(fork { puts 42 })')
  end

  test 'prompt is present' do
    assert_not_nil @pry.prompt
  end

  test 'rails helpers are available in the session' do
    each_rails_console_method do |meth|
      assert_equal return_prompt(true), @pry.send_input("respond_to? :#{meth}")
    end
  end

  private
    def return_prompt(value)
      output = StringIO.new
      ::Pry.config.print.call(output, value)
      output.string
    end

    def each_rails_console_method(&block)
      require 'rails/console/app'
      require 'rails/console/helpers'
      Rails::ConsoleMethods.public_instance_methods.each(&block)
    end
end
