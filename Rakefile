# frozen_string_literal: false

desc 'run tests'
task :spec do
  sh 'ruby spec/osm_api_spec.rb'
  sh 'ruby spec/yt_api_spec.rb'
end

namespace :quality do
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

namespace :quality do
  desc 'run all quality checks'
  task all: %i[rubocop flog reek]
end
