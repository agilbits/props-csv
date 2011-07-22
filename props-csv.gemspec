# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "props-csv"

Gem::Specification.new do |s|
  s.name        = "props-csv"
  s.version     = PropsCSV::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hugo Corbucci", "Mariana Bravo"]
  s.email       = ["hugo@agilbits.com.br", "marivb@agilbits.com.br"]
  s.homepage    = "https://github.com/agilbits/props-csv"
  s.summary     = %q{A simple gem to make easier to support Java i18n for several languages.}
  s.description = %q{Gem that provides two bin's: to_csv and from_csv.
    The first scans a folder recursively to find .properties files and generate a single csv mapping to all the keys in those files.
    The second reads a csv file and generates several .properties files for each key and languages in the csv file.}
    
  s.add_development_dependency('rspec')

  s.rubyforge_project = "props-csv"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
