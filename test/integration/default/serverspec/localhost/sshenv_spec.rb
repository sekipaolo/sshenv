require 'spec_helper'

describe 'sshenv'  do

	it 'should have a deploy user' do
    expect(user 'deploy' ).to exist
	end

	it 'should have key secret file' do
    expect(file '/home/deploy/.ssh/id_rsa').to be_file
	end

	it 'should have key public file' do
    expect(file '/home/deploy/.ssh/id_rsa.pub').to be_file
	end

	it 'should have edited config file' do
		# TODO test also key 
		# TODO let host be configurable
    expect(file('/home/deploy/.ssh/config').content).to match(/Hostname+\s*localhost$\nIdentityFile+\s*/)
	end

	it 'has a known_hosts file' do
		#TODO check also corrispondence hith host
    expect(file '/home/deploy/.ssh/id_rsa.pub').to be_file
	end


end
