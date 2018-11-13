# frozen_string_literal: true

folders = %w[trending_lists rankings]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
