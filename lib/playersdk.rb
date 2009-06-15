$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed
 
# rubygems
require 'rubygems'
 
# core
require 'fileutils'
require 'yaml'
require 'zip/zip'
 
# internal requires
require 'playersdk/core_ext/hash.rb'
require 'playersdk/compiler.rb'
require 'playersdk/compilers/flex.rb'
 
module PlayerSDK
  # Default options. Overriden by values in config.yml or command-line opts.
  # (Strings rather symbols used for compatability with YAML)
  DEFAULTS = {
      'build_dir' => 'builds',
      'temp_dir' => 'tmp',
      'workspace_dir' => '.',
      'flex_sdk' => '',
      'flex_framework_swc' => 'frameworks/libs/framework.swc',
      'flex_framework_version' => '',
      'tasks' => '',
      'verbose' => false,
      'deployment_url' => ''
  }
 
  # Generate a Player SDK configuration Hash by merging the default options
  # with anything in config.yml, and adding the given options on top
  # +override+ is a Hash of config directives
  #
  # Returns Hash
  def self.configuration(override)
    # _config.yml may override default source location, but until
    # then, we need to know where to look for _config.yml
    workspace_dir = override['workspace_dir'] || PlayerSDK::DEFAULTS['workspace_dir']
 
    # Get configuration from <source>/config.yml
    config = {}
    config_file = File.join(workspace_dir, 'config.yml')
    begin
      config = YAML.load_file(config_file)
      puts "Configuration from #{config_file}"
    rescue => err
      puts "WARNING: Could not read configuration. Using defaults (and options)."
      puts "\t" + err
    end
 
    # Merge DEFAULTS < config.yml < override
    PlayerSDK::DEFAULTS.deep_merge(config).deep_merge(override)
  end
  
  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end
