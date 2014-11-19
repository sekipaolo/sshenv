
require_relative '../spec_helper'

describe 'sshenv::install' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ["sshenv"]).converge(described_recipe) }
  
  before(:each) do
    stub_command("ssh-keygen -F localhost").and_return(true)
  end

  it 'create the group deploy ' do
    expect(chef_run).to create_group('deploy')
  end

  it 'create a deploy user' do
    expect(chef_run).to create_user('deploy')
  end

  it 'trigger the ssh enviroment install process' do
    expect(chef_run).to install_sshenv('deploy').with(home: '/home/deploy', key_name: 'id_rsa')
  end

  it 'create the .ssh folder on home' do
    expect(chef_run).to create_directory('/home/deploy/.ssh')
  end

  it 'create the ssh keys' do
    expect(chef_run).to run_bash('create key id_rsa')
  end

  it 'setup the ssh keys' do
    expect(chef_run).to run_bash('setup /home/deploy/.ssh/config for deploy')
  end

  it 'create known_hosts file' do
    expect(chef_run).to create_file('/home/deploy/.ssh/known_hosts')
  end

  it 'update entry for localhost in known hosts' do
    expect(chef_run).to run_bash('update localhost entry in /home/deploy/.ssh/known_hosts')
  end

end
