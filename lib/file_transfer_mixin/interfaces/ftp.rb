module FileTransferMixin
  module InstanceMethods
    extend Forwardable

    def_delegators :file_transfer_mixin_ftp_instance, :ftp_send, :ftp_fetch, :ftp_move, :ftp_block

    private
    def file_transfer_mixin_ftp_instance
      ::FileTransferMixin::Interfaces::FTP.new
    end
  end

  module Interfaces
    class FTP
      def configuration
        FileTransferMixin.configuration.ftp
      end

      def ftp_block(key, &block)
        if perform_network_operations?
          c = configuration[key]
          Net::FTP.open(c[:server]) do |ftp|
            ftp.login(c[:username], c[:password])
            yield(ftp)
          end
        end
      end

      def ftp_send(key, remote_path, local_path)
        perform :putbinaryfile, key, local_path, remote_path
      end

      def ftp_fetch(key, remote_path, local_path)
        perform :getbinaryfile, key, remote_path, local_path
      end

      def ftp_move(key, original_remote_path, new_remote_path)
        perform :rename, key, original_remote_path, new_remote_path
      end

      def perform(action, key, *args)
        ftp_block(key) do |ftp|
          ftp.send(action, *args)
        end
      end

      def perform_network_operations?
        FileTransferMixin.env.to_s != 'test'
      end
    end
  end
end
