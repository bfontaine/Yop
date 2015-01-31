require "inch"
require "rubocop/rake_task"

task :default => [ :rubocop, :test ]

task :test do
  ruby "-Ilib tests/tests.rb"
end

task :doctest do
  Inch::CLI::Command::Suggest.new.run("--pedantic")
end

RuboCop::RakeTask.new
