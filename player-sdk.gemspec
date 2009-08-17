# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{player-sdk}
  s.version = "0.3.9"
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Livesley"]
  s.date = %q{2009-06-12}
  s.default_executable = %q{playersdk}
  s.description = %q{Videojuicer Player SDK runtime and compiler to create and build Player Addons.}
  s.email = %q{sixones@me.com}
  s.executables = ["playersdk"]
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "README.textile",
    "Rakefile",
    "VERSION.yml",
    "bin/playersdk",
    "lib/playersdk.rb",
    "lib/playersdk/core_ext/hash.rb",
    "lib/playersdk/compiler.rb",
    "lib/playersdk/compilers/flex.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://developer.videojuicer.com}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{Videojuicer Player SDK runtime and compiler.}
  #s.test_files = [
  #  "test/suite.rb"
  #]
  
  dependencys_set = false
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubyzip>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<open4>, [">= 0.9.6"])
      
      dependencys_set = true
    end
  end

  if !dependencys_set
    s.add_dependency(%q<rubyzip>, [">= 0.9.1"])
    s.add_dependency(%q<open4>, [">= 0.9.6"])
  end
end