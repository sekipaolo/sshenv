require 'rds'
require  'fileutils'
describe 'Rds::Commands entry in known_hosts' do 
	it 'add and check entry_in_known_hosts' do
		kn = "/home/paolo"
		host = 'localhost'
		FileUtils::touch "#{kn}/.ssh/known_hosts"
		Rds.run :add_entry_in_known_hosts, host, kn
		check = Rds.check :entry_in_known_hosts, host
		expect(check).to eq 0
		Rds.run :remove_entry_in_known_hosts, host		
	end

	it 'add and check entry in ssh_config' do
		host = 'localhost'
		key_name = 'id_rsa'
		home_path = '/tmp/home_test'
		FileUtils::mkdir_p "#{home_path}/.ssh"
		Rds.run :add_entry_ssh_config, host, key_name, home_path
		check = Rds.check :entry_in_ssh_config, host, key_name, home_path
		expect(check).to eq 0
		Rds.run :remove_entry_in_ssh_config, host, key_name, home_path				
		check = Rds.check :entry_in_ssh_config, host, key_name, home_path
		expect(check).to_not eq 0
	end
	
end