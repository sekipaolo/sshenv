
require_relative '../spec_helper'

describe 'sshenv::_test_create' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ["sshenv"]).converge(described_recipe) }
  context 'user with default attributes' do  
    before(:each) do
      # stb all command used for guards with return false, so every operation is executed
      stub_command("cat /home/user_with_default_attributes/.ssh/config | grep id_rsa").and_return(false)
      stub_command("cat /custom_home/.ssh/config | grep custom_key_name").and_return(false)
    end

    it 'create the ssh env' do
      expect(chef_run).to create_ssh_env('user_with_default_attributes')
    end

    it 'create the .ssh folder on home' do
      expect(chef_run).to create_directory('/home/user_with_default_attributes/.ssh')
    end

    it 'create the ssh keys' do
      expect(chef_run).to run_bash('create keys /home/user_with_default_attributes/.ssh/id_rsa[.pub]')
    end

    it 'setup config file for localhost' do
      expect(chef_run).to run_bash('setup /home/user_with_default_attributes/.ssh/config for localhost')
    end

    it 'add entry in known_hosts' do
      expect(chef_run).to create_ssh_known_hosts_entry('localhost')
    end

  end

  context 'user with custom attributes' do  
    before(:each) do
      # stb all command used for guards with return false, so every operation is executed
      stub_command("cat /home/user_with_default_attributes/.ssh/config | grep id_rsa").and_return(false)
      stub_command("cat /custom_home/.ssh/config | grep custom_key_name").and_return(false)
    end

    it 'create the ssh env' do
      expect(chef_run).to create_ssh_env('user_with_default_attributes')
    end

    it 'create the .ssh folder on home' do
      expect(chef_run).to create_directory('/custom_home/.ssh')
    end

    it 'create the ssh keys' do
      expect(chef_run).to run_bash('create keys /custom_home/.ssh/custom_key_name[.pub]')
    end

    it 'setup config file' do
      expect(chef_run).to run_bash('setup /custom_home/.ssh/config for localhost')
      expect(chef_run).to run_bash('setup /custom_home/.ssh/config for test.rvsvm.com')
    end

    it 'add entry in known_hosts' do
      expect(chef_run).to create_ssh_known_hosts_entry('localhost')
      expect(chef_run).to create_ssh_known_hosts_entry('test.rvsvm.com')
    end
  end

end
