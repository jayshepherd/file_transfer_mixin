require 'spec_helper'

describe ::FileTransferMixin::Interfaces::FTP do

  it "should know its parent configuration key" do
    subject.configuration.should == @config[:development][:ftp]
  end

  it "should be able to find the server, username, and password for a given key" do
    subject.configuration[:some_key][:server].should == '127.0.0.1'
    subject.configuration[:some_key][:username].should == 'user'
    subject.configuration[:some_key][:password].should == 'pass'
  end

  describe "network operations" do
    before(:each) do
      ftp_mock = mock('ftp')
      ftp_mock.stub!(:put_binaryfile).and_return(true)
      ftp_mock.stub!(:get_binaryfile).and_return(true)
      ftp_mock.stub!(:login).and_return(true)
      Net::FTP.stub(:open).and_return(ftp_mock)
      @ftp_interface = TestFileTransferMixin.new
      @ftp_interface.stub!(:perform_network_operations?).and_return(true)
    end

    it "should respond to ftp_send" do
      lambda{ @ftp_interface.ftp_send(:some_key, 'path', 'file_path') }.should_not raise_error
    end

    it "should respond to ftp_fetch" do
      lambda{ @ftp_interface.ftp_fetch(:some_key, 'path', 'file_path') }.should_not raise_error
    end
  end

  it "should not perform network operations in the test environment" do
    FileTransferMixin.stub!(:env).and_return('test')
    TestFileTransferMixin::Interfaces::SFTP.new.perform_network_operations?.should == false
  end
end
