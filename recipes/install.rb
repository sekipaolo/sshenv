group "deploy"
user "deploy" do
  supports :manage_home => true
  comment "Deploy User"
  group "deploy"
  home "/home/deploy"
  shell "/bin/bash"
  password "$1$JJsvHslV$szsCjVEroftprNn4JHtDi."
end
puts "installing"
sshenv "deploy" do
	action :install
end	
