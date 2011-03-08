module FileTransferMixin
  module InstanceMethods
    extend Forwardable

    def_delegators :file_transfer_mixin_sftp_instance, :sftp_send, :sftp_fetch, :sftp_move, :sftp_block

    private
    def file_transfer_mixin_sftp_instance
      ::FileTransferMixin::Interfaces::SFTP.new
    end
  end

  module Interfaces
    class SFTP
      def configuration
        FileTransferMixin.configuration.sftp
      end

      def sftp_block(key, &block)
        if perform_network_operations?
          Net::SFTP.start(configuration[key][:server], configuration[key][:username], :password => configuration[key][:password]) do |sftp|
            yield(sftp)
          end
        end
      end

      def sftp_send(key, remote_path, local_path)
        perform :upload!, key, local_path, remote_path
      end

      def sftp_fetch(key, remote_path, local_path)
        perform :download!, key, remote_path, local_path
      end

      def sftp_move(key, original_remote_path, new_remote_path)
        perform :rename!, key, original_remote_path, new_remote_path
      end

      def perform(action, key, *args)
        sftp_block(key) do |sftp|
          sftp.send(action, args)
        end
      end

      def perform_network_operations?
        FileTransferMixin.env.to_s != 'test'
      end
    end
  end
end
