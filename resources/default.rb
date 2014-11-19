actions :create, :install

attribute :home, :kind_of => String
attribute :key_name, :kind_of => String, :default => 'id_rsa'

def initialize(*args)
  super
  @home = "/home/#{@name}" unless @home
  @action = :create
end
