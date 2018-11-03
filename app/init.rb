# frozen_string_literal: false

folders = %w[models infrastructure controllers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
