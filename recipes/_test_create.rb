
# User with default attributes
group 'user_with_default_attributes'
user 'user_with_default_attributes' do
	home '/home/user_with_default_attributes'	
	group 'user_with_default_attributes'	
	manage_home true	
end

sshenv "user_with_default_attributes" do
	known_hosts ['localhost']
end


group 'custom_group'
user 'user_with_custom_attributes' do
	home '/custom_home'	
	group 'custom_group'	
	manage_home true	
end


sshenv "user_with_custom_attributes" do
	known_hosts ['localhost', 'test.rvsvm.com']
	group 'custom_group'
	key_name 'custom_key_name'
	home '/custom_home'
end
