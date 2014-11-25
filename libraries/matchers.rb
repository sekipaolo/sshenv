if defined?(ChefSpec)
 
  def create_ssh_known_hosts_entry(host)
    ChefSpec::Matchers::ResourceMatcher.new(:ssh_known_hosts_entry, :create, host)
  end
 
  def create_ssh_env(user)
    ChefSpec::Matchers::ResourceMatcher.new(:sshenv, :create, user)
  end

end
