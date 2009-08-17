module PlayerSDK    
   class Compiler
       attr_accessor :config, :compiler, :version
       
       def initialize(config)
          self.config = config.clone
          
          self.compiler = PlayerSDK::Compilers::Flex.new(self.config);
       end
       
       def process
           tasks = self.config['tasks']
           
           puts "Found #{tasks.length} task(s) to process"
           
           # find the copy tasks
           tasks.each do |key,value|
               if value['type'] == 'copy'
                   self.run_task(key, value)
               end
           end
           
           find_version
           
           self.config['deployment_url'] = self.config['deployment_url'].gsub("%V", self.version)
           
           puts "Deployment url set to: #{self.config['deployment_url']}"
           
           tasks.each do |key,value|
               if value['type'] != 'copy'
                  self.run_task(key, value)
              end
           end
           
           puts "\n\n"
           puts "Completed #{tasks.length} tasks(s)"
       end
       
       def find_version
           file = File.read("#{self.config['build_dir']}/version.properties")
           
           if (file == nil)
               puts "No version file found"
               return
           end
           
           version_s = ""
           file.scan(/version.([a-z]+) = ('?)([\w]+)('?)/i).each { |key, q1, value, q2|
               if value != ''
                   if key == 'text'
                       version_s = version_s.slice(0, version_s.length - 1)
                   end
                   
                   version_s += "#{value}."
               end
           }
           
           version_s = version_s.slice(0, version_s.length - 1)
           
           self.version = version_s
           
           puts "Using version #{self.version}"
       end
       
       def run_task(key, value)
        if value['src'] != nil && value['src'] != ''
            puts "\nRunning task #{key} in #{value['src']}"
        else
            puts "\nRunning task #{key}"
        end
           
          case value['type']
              when "player"
                  self.compiler.compile_mxmlc(value['src'], value['main'], value['sdk'], value['engine'], value['libs'], value['target'], self.config['build_dir'], self.config['deployment_url'])
              when "engine"
                  self.compiler.compile_compc(value['src'], value['sdk'], value['engine'], value['libs'], value['target'], self.config['build_dir'], self.config['deployment_url'])
                  
                  puts "Optimizing engine swf .."
                  
                  optimize_target = value['optimize_target'] != '' ? value['optimize_target'] : value['target']
                  
                  self.compiler.optimize_swc(value['target'], optimize_target, self.config['build_dir'])
              when "addon"
                  self.compiler.compile_mxmlc(value['src'], value['main'], value['sdk'], value['engine'], value['libs'], value['target'], self.config['build_dir'], self.config['deployment_url'])
              when "framework"
                  if value['target'] == nil || value['target'] == ""
                      value['target'] = 'framework'
                  end
              
                  puts "Moving Flex framework RSLs to #{value['target']}"
                  
                  self.compiler.run_command("cp #{config['flex_sdk']}/frameworks/rsls/#{value['framework_rsl']}.swz #{config['build_dir']}/#{value['target']}.swz")
                  
                  self.compiler.run_command("cp #{config['flex_sdk']}/frameworks/rsls/#{value['framework_rsl']}.swf #{config['build_dir']}/#{value['target']}.swf")
                  
                  self.compiler.run_command("chmod 644 #{config['build_dir']}/#{config['target']}.sw*")
              when "clean"
                  puts "Cleaning directories ..."
                  
                  self.compiler.run_command("rm -rf #{config['build_dir']}/* #{config['tmp_dir']}/*")
              when "copy"
                  puts "Copying over #{value['src']}"
                  
                  self.compiler.run_command("cp #{value['src']} #{config['build_dir']}/#{value['target']}")
              when ""
                  puts "Unknown task type, skipping task ..\n"
                  return
          end
          
          puts "\n"
          puts "Successfully compiled #{key} to target #{value['target']}.\n"      
       end
   end 
end