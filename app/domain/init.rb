# frozen_string_literal: true

folders = %w[popular_lists rankings]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
