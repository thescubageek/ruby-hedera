# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# require 'support/code_coverage'

# require File.expand_path('../config/environment', __dir__)

require 'rails/test_help'

require 'minitest/autorun'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # include CodeCoverage

  puts "Running tests with Rails #{Rails.version}"
end

require 'minitest/reporters'
reporter_options = { color: true }
Minitest::Reporters.use!([Minitest::Reporters::DefaultReporter.new(reporter_options)])
