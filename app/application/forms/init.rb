# frozen_string_literal: true

require 'dry-validation'

Dir.glob("#{__dir__}/*.rb").each do |file|
  require file
end
