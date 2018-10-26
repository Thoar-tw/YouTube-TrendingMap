# frozen_string_literal: false

desc 'run tests'
task :spec do
  sh 'ruby spec/osm_api_spec.rb'
  sh 'ruby spec/yt_api_spec.rb'
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Restart my server upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :quality do
  desc 'run all quality checks'
  task all: %i[rubocop flog reek]

  task :flog do
    sh 'flog lib/gateways/'
  end

  task :reek do
    sh 'reek lib/gateways/'
  end
  task :rubocop do
    sh 'rubocop lib/'
    sh 'rubocop spec/'
  end
end
