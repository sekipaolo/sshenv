
def load_current_resource
  @current_resource = Chef::Resource::Sshenv.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.home(@new_resource.home)
  @current_resource.key_name(@new_resource.key_name)
  @current_resource
end

action :install do
	user = @current_resource.name
  ssh_path = "#{@current_resource.home}/.ssh"
  key = @current_resource.key_name
  converge_by("creating the ssh env for #{user}") do  
    install user, ssh_path, key, 'localhost'
    add_host_entry 'localhost', @current_resource.home
  end
  new_resource.updated_by_last_action(true)    
end

def install user, ssh_path, key_name, host
  key_file = "#{ssh_path}#{key_name}"
  # create .ssh dir
  directory ssh_path do
    owner user
    group user
    mode "0700"
    action :create
  end

  bash "create key #{key_name}" do
    user user
    group user
    cwd ssh_path
    code <<-EOH
      ssh-keygen -t rsa -N '' -P '' -f #{ssh_path}/#{key_name}
      chmod 0600 #{key_file}
      chmod 0600 #{key_file}.pub
    EOH
    not_if { ::File.exists? "#{key_file}.pub" }
  end        

  config_file = "#{ssh_path}/config"
  
  bash "setup #{config_file} for #{user}" do
    user user
    group user
    code Rds::Commands.add_entry_ssh_config host, ssh_path, key_name
    #TODO: is regexp working?
    reg = Regexp.new "Hostname+\s*#{host}$\nIdentityFile+\s*#{key_file}"
    not_if {::File.exists?(config_file)  && ::File.read(config_file).match(reg)}
  end

  file "#{ssh_path}/known_hosts" do
    user user
    group user
  end
end

def add_host_entry host, home_path
  bash "update #{host} entry in #{home_path}/.ssh/known_hosts" do
    user user
    group user
    code Rds::Commands.add_entry_in_known_hosts host, home_path
    only_if Rds::Checks.entry_in_known_hosts host
  end

end
