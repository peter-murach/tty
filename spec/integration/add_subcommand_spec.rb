RSpec.describe 'teletype add subcommad', type: :cli do
  it "adds a new subcommand" do
    app_name = tmp_path('newcli')
    silent_run("teletype new #{app_name} --test rspec")

    output = <<-OUT
      create  spec/integration/config_spec.rb
      create  spec/integration/config/set_spec.rb
      create  lib/newcli/commands/config.rb
      create  lib/newcli/commands/config/set.rb
      inject  lib/newcli/cli.rb
      inject  lib/newcli/commands/config.rb
    OUT

    within_dir(app_name) do
      command = "teletype add config set --no-color"

      out, err, status = Open3.capture3(command)

      expect(out).to include(output)
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
# frozen_string_literal: true

require 'thor'

module Newcli
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'newcli version'
    def version
      require_relative 'version'
      puts \"v\#{Newcli::VERSION}\"
    end
    map %w(--version -v) => :version

    require_relative 'commands/config'
    register Newcli::Commands::Config, 'config', 'config [SUBCOMMAND]', 'Command description...'
  end
end
      EOS

      expect(::File.read('lib/newcli/commands/config.rb')).to eq <<-EOS
# frozen_string_literal: true

require 'thor'

module Newcli
  module Commands
    class Config < Thor

      namespace :config

      desc 'set', 'Command description...'
      def set(*)
        if options[:help]
          invoke :help, ['set']
        else
          require_relative 'config/set'
          Newcli::Commands::Config::Set.new(options).execute
        end
      end
    end
  end
end
      EOS

      # Subcommand `set`
      #
      expect(::File.read('lib/newcli/commands/config/set.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../../cmd'

module Newcli
  module Commands
    class Config
      class Set < Newcli::Cmd
        def initialize(options)
          @options = options
        end

        def execute
          # Command logic goes here ...
        end
      end
    end
  end
end
      EOS

      # test setup
      #
      expect(::File.read('spec/integration/config_spec.rb')).to eq <<-EOS
RSpec.describe Newcli::Commands::Config do
  it "executes the command successfully" do
    output = `newcli config`
    expect(output).to eq("EXPECTED")
  end
end
      EOS

      expect(::File.read('spec/integration/config/set_spec.rb')).to eq <<-EOS
RSpec.describe Newcli::Commands::Config::Set do
  it "executes the command successfully" do
    output = `newcli config set`
    expect(output).to eq("EXPECTED")
  end
end
      EOS
    end
  end
end