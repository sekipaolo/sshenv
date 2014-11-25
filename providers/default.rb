use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::Sshenv.new(@new_resource.name)
  [ :name, :group, :home, :key_name, :known_hosts ].each do |k|
    @current_resource.send( k, ( @new_resource.send( k ) ) )
  end
end

action :create do
	create_env @current_resource
end

def create_env resource
  ssh_path = "#{@current_resource.home}/.ssh"
  key_name = @current_resource.key_name  
  key_path = "#{ssh_path}/#{key_name}"
  config_file = "#{ssh_path}/config"


  directory ssh_path do
    owner resource.name
    group resource.group
    mode "0700"
    action :create
  end

  bash "create keys #{key_path}[.pub]" do
    user resource.name
    group resource.group
    cwd ssh_path
    code Rds::Commands.ssh_keys_add key_path
    creates key_path
  end

  if resource.known_hosts
    resource.known_hosts.each do |host|
      bash "setup #{config_file} for #{host}" do
        user resource.name
        group resource.group
        code Rds::Commands.ssh_config_entry_add host, key_path, config_file
        not_if Rds::Checks.ssh_config_entry_present host, config_file, key_name
      end
      ssh_known_hosts_entry host
    end
  end
end

