# features/support/simplecov.rb
require 'simplecov'

SimpleCov.start 'rails' do
  # Add additional filters as needed
  add_filter 'app/channels'
  add_filter 'app/models'
  add_filter 'app/mailers'
  add_filter 'app/jobs'
  add_filter 'app/controllers/sections_controller.rb'
  add_filter 'app/controllers/dev_test_controller.rb'
end
