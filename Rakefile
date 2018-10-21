desc 'run tests'
task :spec do 
    sh 'ruby/specs.rb'
end

namespace : quality do 
task :flog do 
    sh 'flog lib/'
end

task :reek do 
    sh 'reek lib'
end
task :rubocop do 
    sh 'rubocop'
end
end

namespace :quality do 
    desc 'run all quality checks'
    task all: [:rubocop, :flog :reek]
end

