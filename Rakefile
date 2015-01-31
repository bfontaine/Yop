require "inch"
require "rubocop/rake_task"

task default: [:rubocop, :test]
task style: [:rubocop, :doctest]

task :test do
  ruby "-Ilib tests/tests.rb"
end

task :doctest do
  Inch::CLI::Command::Suggest.new.run("--pedantic")
end

desc "Run RuboCop on the lib & bin directories"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ["lib/**/*.rb", "bin/*"]
end
