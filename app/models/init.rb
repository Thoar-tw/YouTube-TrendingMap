# frozen_string_literal: false

%w[entities gateways mappers].each do |folder|
  require_relative "#{folder}/init.rb"
end
