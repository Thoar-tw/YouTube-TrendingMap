# frozen_string_literal: false

folders = %w[app config]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
