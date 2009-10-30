require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
begin
  gem 'jeweler', '>= 1.0.1'
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "vj-player-sdk"
    s.summary = %Q{Videojuicer Player SDK runtime and compiler to create and build Player Addons.}
    s.homepage = "http://videojuicer.com/"
    s.email = "adam@videojuicer.com"
    s.description = "Videojuicer Player SDK runtime and compiler to create and build Player Addons."
    s.authors = ["sixones", "danski"]
    s.files.exclude 'test/dest'
    s.test_files.exclude 'test/dest'
    
    # Dependencies
    s.add_dependency('open4', '>= 0.9.6')
    s.add_dependency('rubyzip', '>= 0.9.1')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler --version '>= 1.0.1'"
  exit(1)
end
 
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = false
end
 
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'playersdk'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
 
begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/test_*.rb']
    t.verbose = true
  end
rescue LoadError
end
 
task :default => [:test, :features]
 
# console
 
desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r player-sdk.rb"
end

begin
  require 'cucumber/rake/task'
 
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format progress"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
