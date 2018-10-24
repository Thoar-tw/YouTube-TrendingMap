# frozen_string_literal: false

require 'http'
require 'yaml'

require 'vcr'
require 'webmock'

CREDENTIALS = YAML.safe_load(File.read('config/secrets.yml'))
GOOGLE_API_TOKEN = CREDENTIALS['token']

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data("API_KEY"){GOOGLE_API_TOKEN}
end

VCR.insert_cassette 'youtube_api', record: :new_episodes

youtubeSampledata_url = 'https://gist.github.com/ChiaEnC/483e77510e8a432cffb211ca3d6512c7'

response = HTTP.get(
  github_url,
  headers: { 'Accept' => '',
             'Authorization' => "token #{GOOGLE_API_TOKEN}" }
)

puts response.status
puts response.body

VCR.eject_cassette
