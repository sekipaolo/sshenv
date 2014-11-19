
def load_current_resource
  @current_resource = Chef::Resource::Sshenv.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.home(@new_resource.home)
  @current_resource.key_name(@new_resource.key_name)
  @current_resource
end

action :install do
	user = @current_resource.name
  home_path = @current_resource.home
  key = "#{home_path}/.ssh/#{@current_resource.key_name}"
  converge_by("creating the ssh env for #{user}") do  
    install user, home_path, key    
  end   
  new_resource.updated_by_last_action(true)    
end

def install user, home_path, key
  # create .ssh dir
  directory "#{home_path}/.ssh" do
    owner user
    group user
    mode "0700"
    action :create
  end

  bash "create key #{key}" do
    user user
    group user
    cwd "#{home_path}/.ssh"
    code <<-EOH
      ssh-keygen -t rsa -N '' -P '' -f #{key}
      chmod 0600 #{key}
      chmod 0600 #{key}.pub
    EOH
    not_if { ::File.exists? "#{key}.pub" }
  end        

  config_file = "#{home_path}/.ssh/config"
  
  bash "setup ssh config for #{user}" do
    user user
    group user
    txt = <<-TXT

Host            localhost
Hostname        localhost
IdentityFile    #{key}
IdentitiesOnly  yes

    TXT

    code <<-CODE
      touch #{home_path}/.ssh/config &&
      echo '#{txt}' >> #{config_file}
    CODE
    #TODO: is regexp working?
    reg = Regexp.new "Hostname+\s*localhost$\nIdentityFile+\s*#{key}"
    not_if {::File.exists?(config_file)  && ::File.read(config_file).match(reg)}
  end

  file "#{home_path}/.ssh/known_hosts" do
    user user
    group user
  end

  bash "update localhost entry in known_hosts for user #{user}" do
    user user
    group user
    # TODO: we remove the entry and the add it. Find a way to add only with a not_if guard
    code <<-CODE
      ssh-keygen -R localhost
      ssh-keyscan -H localhost >>  #{home_path}/.ssh/known_hosts
    CODE
  end
end  