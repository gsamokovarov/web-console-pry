require 'pry'
require 'web_console/repl'
require 'web_console/stream'

module WebConsole
  module REPL
    class Pry
      class FiberInput
        def previous
          @previous ||= ''
        end

        def readline
          @previous = Fiber.yield
        end
      end

      ENFORCED_UNSUPPORTED_OPTIONS = { color: false, pager: false }

      def initialize(binding = ::Pry.toplevel_binding)
        @binding = binding
        @input   = FiberInput.new
        @pry     = ::Pry.new(input: @input)
        @fiber   = Fiber.new { enforce_supported_options! { @pry.repl(binding) } }.tap(&:resume)
      end

      def prompt
        @pry.select_prompt(@input.previous, @binding)
      end

      def send_input(input)
        Stream.threadsafe_capture! { @fiber.resume("#{input}\n") }
      rescue FiberError
        @fiber = Fiber.new { enforce_supported_options! { @pry.repl(binding) } }.tap(&:resume)
        retry
      end

      private
        def enforce_supported_options!
          original_config = ::Pry.config.dup
          ENFORCED_UNSUPPORTED_OPTIONS.each do |option, value|
            ::Pry.config.send(:"#{option}=", value)
          end
          yield
        ensure
          ::Pry.config = original_config
        end
    end

    register_adapter Pry do
      require 'rails/console/app'
      require 'rails/console/helpers'

      # Sneak the console session into the top-level binding, as Pry does not
      # have a proxy context as IRB does.
      ::Pry.toplevel_binding.eval('self').send(:include, ::Rails::ConsoleMethods)
    end
  end
end
