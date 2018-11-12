# frozen_string_literal: false

folders = %w[domain infrastructure controllers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
