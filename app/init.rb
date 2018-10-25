folders = %w[config app]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
