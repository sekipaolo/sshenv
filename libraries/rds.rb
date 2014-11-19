# @author Sechi Paolo
# @Licence Apache 2
#
# Collection of helper classes for Chef. 
# The meaning is to separate bash syntax from code in recipes, LWPR etc and give readibility back to ruby style
# Mostly we don't call the included classes directly, but only the module methods (eg: run and check)
module Rds
	
	# run an action executing a call to Checks.method 
	#
	# @param method [Symbol] The name of the method of the class Commands that you want to execute
	# @param *args the list of params to pass to the method
	# @return [String] the output (stdin and stderr) 
	def self.run meth, *args
		cmd = self::Commands.send(meth, *args)
		log "Rds.run   **** #{cmd}"
		res = `#{cmd}`.chomp		
		unless $?.to_i == 0
			log "Error during execution the command #{cmd}"
			log "error was #{res}"
		end		
		res		
	end

	# perform a check executing a call to Checks.method 
	#
	# @param method [Symbol] The name of the method of the class Commands that you want to execute
	# @param *args the list of params to pass to the method
	# @return [Fixnum] the exit code of the subshel where the command was executed (0 is OK, every other code means ERROR) 
	def self.check meth, *args
		cmd = self::Checks.send(meth, *args)
		log "Rds.check **** #{cmd}"
		res = `#{cmd}`.chomp
		unless $?.to_i == 0
			log "Error during execution the check #{cmd}"
			log "error was #{res}"
		end
		$?.to_i
	end

	# simple log with colors (it will be extended soon)
	#
	# @param msg [String] the message to puts as log
	# @return [nil]
	def self.log msg
		puts "\e[1;34m#{msg}\e[0m"
		nil
	end	

	class Commands
		class << self

			# add host to ~/.ssh/known_hosts			
			# 
			# @param host [String]
			# @param home_path [String]
			# @return [String] the command 
			def add_entry_in_known_hosts host, home_path
				"ssh-keyscan -H #{host} >>  #{home_path}/.ssh/known_hosts"
			end

			# remove host from ~/.ssh/known_hosts
			#
			# @param host [String]
			def remove_entry_in_known_hosts host
				"ssh-keygen -R #{host}"
			end

			# configure the ssh per-host setting for that host
			#
			# @param host [String]
			# @param key_name [String] the name of the file containing the ssh secret key
			# @param home_path [String] the user home path
			# @return [String] the command 
			def add_entry_ssh_config host, key_name, home_path
		    txt = <<-TXT

Host            #{host}
Hostname        #{host}
IdentityFile    #{home_path}/.ssh/#{key_name}
IdentitiesOnly  yes

    		TXT

				cmd = <<-CODE
		      touch #{home_path}/.ssh/config && echo '#{txt}' >> #{home_path}/.ssh/config
		    CODE
		    cmd    
			end

			# remove the ssh per-host setting for that host
			#
			# @param host [String]
			# @param key_name [String] the name of the file containing the ssh secret key
			# @param home_path [String] the user home path
			# @return [String] the command 
			def remove_entry_in_ssh_config host, key_name, home_path
				# TODO you can do better? delete all line before another Host\s*someting\
				"sed -i '/Host\s*#{host}/,+3 d' #{home_path}/.ssh/config"   
			end
		end
	end

	class Checks
		class << self

			# check if there host is configured for ssh
			#
			# @param host [String]
			# @param key_name [String] the name of the file containing the ssh secret key
			# @param home_path [String] the user home path
			# @return [String] the command 
			def entry_in_ssh_config host, key_name, home_path
				# TODO: find a way to make a better chek: use awk or sed with regex (check for host and key on the same block)
				"cat #{home_path}/.ssh/config | grep #{key_name}"   
			end

			# check if host is listed in ~/.ssh/known_hosts
			#
			# @param host [String]
			# @return [String] the command 
			def entry_in_known_hosts host
				"ssh-keygen -F #{host}"
			end
		
		end
	end	
end
