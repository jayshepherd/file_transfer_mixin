# FileTransferMixin #
FileTransferMixin is a module that you can include in a library.  It will support various mechanisms long-term, but
for now is focused on SFTP and FTP servers.

It provides the following methods for now:

- sftp_send(key, remote_location, local_file_path)
- sftp_fetch(key, remote_path, local_path)
- sftp_move(key, original_remote_path, new_remote_path)
- sftp_block(key)
- ftp_send(key, remote_location, local_file_path)
- ftp_fetch(key, remote_path, local_path)
- ftp_move(key, original_remote_path, new_remote_path)
- ftp_block(key)

It expects an ENV variable named FILE_TRANSFER_MIXIN_CONFIG_PATH to be set.
It expects a yml configuration file in FILE_TRANSFER_MIXIN_CONFIG_PATH that looks like the following:

    :development:
      :sftp:
        :some_key:
          :server: 127.0.0.1
          :username: user
          :password: pass
      :ftp:
        :some_key:
          :server: 127.0.0.1
          :username: user
          :password: pass

    :test: {}

    :production: {}

Then in a class, you would deal with it thusly:

    class SomeClass
      include FileTransferMixin

      # Some method that uploads a file via sftp
      def some_method
        sftp_send(:some_key, remote_path, local_path)
      end

      # Some method that fetches a file via sftp
      def fetch_method
        sftp_fetch(:some_key, remote_path, local_path)
      end

      # Some method that moves a file via sftp
      def move_method
        sftp_move(:some_key, original_remote_path, new_remote_path)
      end

      # Some method that otherwise uses Net::SFTP commands but still uses our config block
      def sftp_detailed_method
        sftp_block(:some_key) do |sftp|
          sftp.rename!('foo', 'bar')
        end
      end

      # Some method that uploads a file via ftp
      def some_method
        ftp_send(:some_key, remote_path, local_path)
      end

      # Some method that fetches a file via ftp
      def fetch_method
        ftp_fetch(:some_key, remote_path, local_path)
      end

      # Some method that moves a file via ftp
      def move_method
        ftp_move(:some_key, original_remote_path, new_remote_path)
      end

      # Some method that otherwise uses Net::FTP commands but still uses our config block
      def ftp_detailed_method
        ftp_block(:some_key) do |ftp|
          puts "foo's last modification time: #{ftp.mtime('foo')}"
        end
      end
    end

## Motivation ##
We have quite a few libraries that interact with remote SFTP and FTP servers, and inevitably they share massive swathes of code
that should be unnecessary.  This intends to be a mixin to make the easy things extremely easy.

