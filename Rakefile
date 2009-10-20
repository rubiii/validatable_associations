require "rubygems"
require "rake"
require "spec/rake/spectask"
require "rake/rdoctask"

task :default => :spec

Spec::Rake::SpecTask.new do |spec|
  spec.spec_files = FileList["spec/**/*_spec.rb"]
  spec.spec_opts << "--color"
end

Rake::RDocTask.new do |rdoc|
  rdoc.title = "ValidatableAssociations"
  rdoc.rdoc_dir = "rdoc"
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rdoc.options = ["--line-numbers", "--inline-source"]
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |spec|
    spec.name = "validatable_associations"
    spec.author = "Daniel Harrington"
    spec.email = "me@rubiii.com"
    spec.homepage = "http://github.com/rubiii/validatable_associations"
    spec.summary = "Association add-on for the Validatable gem"
    spec.description = spec.summary

    spec.files = FileList["init.rb", "[A-Z]*", "{lib,spec}/**/*.{rb,xml}"]

    spec.rdoc_options += [
      "--title", "validatable_associations",
      "--main", "README.rdoc",
      "--line-numbers",
      "--inline-source"
    ]

    spec.add_development_dependency("validatable", "1.6.7")
    spec.add_development_dependency("rspec", ">= 1.2.8")
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
