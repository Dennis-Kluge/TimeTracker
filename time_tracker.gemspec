# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "time_tracker/version"

Gem::Specification.new do |s|
  s.name        = "time_tracker"
  s.version     = TimeTracker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Horst Mumpitz"]
  s.email       = ["d-staar@gmx.de"]
  s.homepage    = ""
  s.summary     = "Create time sheets with the help of a public iCal file"
  s.description = "In some companies you need to track your working time with the help of excel. For that purpose you have to create sheets and put each entry into the file by hand. TimeTracker.rb 
  								 simplifies this workflow by adding your working time into a public iCal feed after calling timetracker a PDF for each month wil be generated. The configuration is very easy with the
  								 help of a JSON file."

  s.rubyforge_project = "time_tracker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "icalendar"
	s.add_runtime_dependency "prawn"
	s.add_runtime_dependency "json"
	s.add_runtime_dependency "httpclient"
end
