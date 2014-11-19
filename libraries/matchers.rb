if defined?(ChefSpec)
 
  def install_sshenv(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sshenv, :install, resource_name)
  end
 
end
