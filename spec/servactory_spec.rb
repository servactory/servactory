# frozen_string_literal: true

require "open3"

RSpec.describe Servactory do
  def run_ruby(script)
    Open3.capture3(RbConfig.ruby, "-rbundler/setup", "-I", File.expand_path("../lib", __dir__), "-e", script)
  end

  describe "loading without Rails" do
    let(:script) do
      <<~'RUBY'
        require "servactory"

        abort("Rails must not be loaded") if defined?(Rails)

        class PlainRubyService < Servactory::Base
          input :name, type: String

          output :greeting, type: String

          make :assign_greeting

          private

          def assign_greeting
            outputs.greeting = "Hello, #{inputs.name}!"
          end
        end

        print PlainRubyService.call!(name: "World").greeting
      RUBY
    end

    it "defines and calls a service", :aggregate_failures do
      stdout, stderr, status = run_ruby(script)

      expect(status).to be_success, stderr
      expect(stdout).to eq("Hello, World!")
    end
  end
end
