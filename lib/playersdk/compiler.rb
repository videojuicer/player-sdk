module PlayerSDK    
   class Compiler
       attr_accessor :config, :compiler
       
       def initialize(config)
          self.config = config.clone
          
          self.compiler = PlayerSDK::Compilers::Flex.new(self.config);
       end
       
       def process
           tasks = self.config['tasks']
           
           puts "Found #{tasks.length} task(s) to process"
           
           tasks.each do |key,value|
              self.run_task(key, value)
           end
           
           puts "\n\n"
           puts "Completed #{tasks.length} tasks(s)"
       end
       
       def run_task(key, value)
          puts "Running task #{key} in #{value['src']}"
           
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
                  puts "Moving Flex framework RSLs to #{config['build_dir']}"
                  
                  self.compiler.run_command("cp #{config['flex_sdk']}/frameworks/rsls/#{value['framework_rsl']}.swz #{config['build_dir']}/framework.swz")
                  self.compiler.run_command("cp #{config['flex_sdk']}/frameworks/rsls/#{value['framework_rsl']}.swf #{config['build_dir']}/framework.swf")
              when "clean"
                  puts "Cleaning directories ..."
                  
                  self.compiler.run_command("rm -rf #{config['build_dir']}/* #{config['tmp_dir']}/*")
              when ""
                  puts "Unknown task type, skipping task ..\n"
                  return
          end
          
          puts "\n"
          puts "Successfully compiled #{key} to target #{value['target']}.\n"      
       end
   end 
end