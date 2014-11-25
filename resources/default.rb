actions :create

attribute :home, :kind_of => String
attribute :group, :kind_of => String
attribute :key_name, :kind_of => String, :default => 'id_rsa'
attribute :known_hosts, :kind_of => Array

def initialize(*args)
  super
  @home = "/home/#{@name}" unless @home
  @group = @name unless @group
  @action = :create
end
