# As plugins are usually packaged and distributed as a RubyGem,
# we have to provide a .gemspec file, which controls the gembuild
# and publish process.  This is a fairly generic gemspec.

# It is traditional in a gemspec to dynamically load the current version
# from a file in the source tree.  The next three lines make that happen.
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "train-alicloud/version"

Gem::Specification.new do |spec|
  # Importantly, all Train plugins must be prefixed with `train-`
  spec.name          = "train-alicloud"

  # It is polite to namespace your plugin under InspecPlugins::YourPluginInCamelCase
  spec.version       = TrainPlugins::AliCloud::VERSION
  spec.authors       = ["Chef InSpec Team"]
  spec.email         = ["inspec@chef.io"]
  spec.summary       = "AliCloud API Transport for Train"
  spec.description   = "Allows applications using Train to speak to AliCloud; handles authentication, cacheing, and SDK dependency management."
  spec.homepage      = "https://github.com/chef-customers/train-alicloud"
  spec.license       = "Apache-2.0"

  # Though complicated-looking, this is pretty standard for a gemspec.
  # It just filters what will actually be packaged in the gem (leaving
  # out tests, etc)
  spec.files = %w{ LICENSE } + Dir.glob(
    "lib/**/*", File::FNM_DOTMATCH
  ).reject { |f| File.directory?(f) }
  spec.require_paths = ["lib"]

  # If you rely on any other gems, list them here with any constraints.
  # This is how `inspec plugin install` is able to manage your dependencies.

  # If you only need certain gems during development or testing, list
  # them in Gemfile, not here.

  # Do not list inspec as a dependency of a train plugin.
  # Do not list train as a dependency of a train plugin.

  spec.add_dependency "aliyunsdkcore", "~> 0.0.0"
  spec.add_dependency "aliyun-sdk", "~> 0.7"
end
