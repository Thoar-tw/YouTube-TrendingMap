# frozen_string_literal: false

folders = %w[models controllers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
