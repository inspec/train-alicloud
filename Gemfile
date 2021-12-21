source "https://rubygems.org"

gemspec

gem "train-core", "~> 3.0"
gem "aliyunsdkcore"
gem "aliyun-sdk"

if Gem.ruby_version.to_s.start_with?("2.5")
  # 16.7.23 required ruby 2.6+
  gem "chef-utils", "< 16.7.23" # TODO: remove when we drop ruby 2.5
end

if Gem.ruby_version < Gem::Version.new("2.7.0")
  gem "activesupport", "6.1.4.4"
end

group :development do
  gem "pry"
  gem "bundler"
  gem "byebug"
  gem "minitest"
  gem "mocha"
  gem "m"
  gem "rake"
  gem "chefstyle"
end
