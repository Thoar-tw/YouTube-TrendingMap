# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

Dir.glob("#{__dir__}/*.rb").each do |file|
  require file
end
