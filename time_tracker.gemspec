# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "time_tracker/version"

Gem::Specification.new do |s|
  s.name        = "time_tracker"
  s.version     = TimeTracker::VERSION
  s.authors     = ["Horst Mumpitz"]
  s.email       = ["d-staar@gmx.de"]
  s.homepage    = ""
  s.summary     = "Create time sheets with the help of a public iCal file"
  s.description = "goes here"

  s.rubyforge_project = "time_tracker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "icalendar"
	s.add_runtime_dependency "prawn"
	s.add_runtime_dependency "json"
	s.add_runtime_dependency "httpclient"
end
