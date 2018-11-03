# frozen_string_literal: true

folders = %w[app config]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
