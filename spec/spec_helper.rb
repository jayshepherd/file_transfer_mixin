require 'bundler/setup'
Bundler.require :default, :test

require "rspec"

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :rspec

  config.before(:each) do
    ENV['FILE_TRANSFER_MIXIN_CONFIG_PATH'] = '/tmp/file_transfer_mixin_enviro_config.yml'
    ENV['ENVY_ENV'] = 'development'

    @config = {
      :development => {
        :sftp => {
          :some_key => {
            :server => '127.0.0.1',
            :username => 'user',
            :password => 'pass',
            :port => 1234
          }
        },
        :ftp => {
          :some_key => {
            :server => '127.0.0.1',
            :username => 'user',
            :password => 'pass',
          }
        },
      },
      :test => {
      },
      :production => {
      },
    }
    File.open(ENV['FILE_TRANSFER_MIXIN_CONFIG_PATH'], 'w') do |f|
      f.write(YAML.dump(@config))
    end
    Object.send(:remove_const, :TestFileTransferMixin) if defined?(TestFileTransferMixin)
    class TestFileTransferMixin
      include FileTransferMixin
    end
  end
end
