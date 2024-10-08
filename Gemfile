source 'https://rubygems.org'

# Core stuff
ruby '3.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'bundler'
gem 'activemodel', '7.1.3.4'
gem 'activesupport', '7.1.3.4'

# Use Puma as the app server
gem 'puma', '>= 6.4.2'

gem 'httparty'
gem 'dry-validation'
gem 'wannabe_bool'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'pry', '~> 0.14.2'
  gem 'pry-byebug', '~> 3.10.1'
  gem 'pry-rescue', '~> 1.5.1', require: false
  gem 'pry-stack_explorer', '~> 0.6.1', require: false

  gem 'minitest-ci', require: false
  gem 'minitest-reporters'
end

group :development do
  gem 'guard', require: false
  gem 'guard-minitest', require: false
  gem 'guard-puma', require: false
end

group :test do
  gem 'fabrication'
  gem 'faker'
  gem 'minitest-rails'
  gem 'mocha', require: false # Object stubbing
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end
