require 'enviro'
require 'net/sftp'
require 'net/ftp'
require 'forwardable'

require 'file_transfer_mixin/interfaces'

module FileTransferMixin
  include ::Enviro::Environate
  configuration_path_env :file_transfer_mixin_config_path

  module InstanceMethods
  end

  def self.included(base)
    base.send :include, InstanceMethods
  end
end
