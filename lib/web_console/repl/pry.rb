require 'stringio'
require 'pry'
require 'web_console/repl'

module WebConsole
  module REPL
    class Pry
      def initialize(binding = ::Pry.toplevel_binding)
        # We need to keep the binding, se we can send it to Pry#repl until we
        # support Pry <= 0.9.13.
        @binding = binding
        @input   = StringIO.new
        @output  = StringIO.new
        @pry     = ::Pry.new(input: @input, output: @output, target: @binding)
      end

      def prompt
        @pry.select_prompt
      end

      def send_input(input)
        replace_input!(input)
        suspend_pry_config! { @pry.repl(@binding) }
        extract_output!
      end

      private
        def suspend_pry_config!
          original_config   = ::Pry.config
          # When ::Pry#repl runs out of input, it loops out input from
          # ::Pry.config.input. Make sure that we swap that so we don't get
          # into regulard STDIN/STDOUT terminal and possibly, loop forever.
          ::Pry.config.input  = @input
          ::Pry.config.output = @output
        ensure
          ::Pry.config = original_config
        end

        def replace_input!(input)
          @input.truncate(0)
          @input.rewind
          @input.write(input)
          @input.rewind
        end

        def extract_output!
          @output.rewind
          @output.read.tap do
            @output.truncate(0)
            @output.rewind
          end
        end
    end

    register_adapter Pry do
      require 'rails/console/app'
      require 'rails/console/helpers'

      # Sneak the console session into the top-level binding, as Pry does not
      # have a proxy context as IRB does.
      ::Pry.toplevel_binding.eval('self').send :include, ::Rails::ConsoleMethods
    end
  end
end
