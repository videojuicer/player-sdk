module PlayerSDK
    module Compilers
       class Flex
           attr_accessor :config

           def initialize(config)
              self.config = config.clone
           end
           
           def executable(name)
              excutable = "#{config['flex_sdk']}/bin/#{name}"
              
              if false
                 excutable += ".exe" 
              end
              
              excutable
           end
           
           def run_command(command)
              if config['verbose']
                  system command
              else
                `#{command}`
              end
           end
           
           def compile_mxmlc(source_path, main_file, include_sdk, include_engine, include_libs, output_file, output_dir, deployment_url)
              command ="#{executable('mxmlc')} -compiler.source-path #{source_path} -file-specs #{source_path}/#{main_file} -static-link-runtime-shared-libraries=false"
          
               if include_sdk
                   command += " -runtime-shared-library-path=#{config['flex_sdk']}/frameworks/libs/framework.swc,framework.swz,#{deployment_url}crossdomain.xml,framework.swf"
               end
           
               if include_engine
                  command += " -runtime-shared-library-path=#{include_engine}.swc,#{deployment_url}#{output_file}" 
               end
               
               if include_libs
                  command += " -compiler.include-libraries #{include_libs}" 
               end
           
               command += " -use-network -benchmark -compiler.strict --show-actionscript-warnings=true -compiler.optimize -compiler.as3"
               command += " -output #{output_dir}/#{output_file}.swf"
           
               run_command(command)
           end
       
           def compile_compc(source_path, include_sdk, include_engine, include_libs, output_file, output_dir, deployment_url)
               command = "#{executable('compc')} -source-path #{source_path} -include-sources #{source_path}"
           
               if include_sdk
                   command += " -runtime-shared-library-path=#{config['flex_sdk']}/#{config['flex_framework_swc']},#{deployment_url}/#{config['flex_framework_version']}.swz,#{deployment_url}crossdomain.xml,#{deployment_url}/#{config['flex_framework_version']}.swf"
               end
           
               if include_engine
                  command += " -runtime-shared-library-path=#{include_engine}.swc,#{deployment_url}#{output_file}.swf" 
               end
           
               if include_libs
                  command += " -compiler.include-libraries #{include_libs}" 
               end
           
               command += " -use-network -benchmark -compiler.strict --show-actionscript-warnings=true -compiler.optimize -compiler.as3"
               command += " -output #{output_dir}/#{output_file}.swc"
           
               run_command(command)
           end
       
           def optimize_swc(output_file, output_dir)
            self.unzip("#{output_dir}/#{output_file}.swc", "#{config['temp_dir']}")
            
            command = "#{executable('optimizer')} -input #{config['temp_dir']}/library.swf -output #{output_dir}/#{output_file}.swf --keep-as3-metadata='Bindable,Managed,ChangeEvent,NonCommittingChangeEvent,Transient'"
            
            run_command(command)
            
            command = "#{executable('digest')} --digest.swc-path #{output_dir}/#{output_file}.swc --digest.rsl-file #{output_dir}/#{output_file}.swf"
            
            run_command(command)
           end
    
           def unzip(file, destination)
              Zip::ZipFile.open(file) { |zip_file|
                  zip_file.each { |f|
                      f_path = File.join(destination, f.name)
                      FileUtils.mkdir_p(File.dirname(f_path))
                      zip_file.extract(f, f_path) unless File.exist?(f_path)
                  }
              } 
           end
       end 
   end
end