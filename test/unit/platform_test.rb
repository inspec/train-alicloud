# This is a unit test for the AliCloud Train plugin
# Its job is to verify that platform detection is setup correctly.

# Include our test harness
require_relative "../helper"

# Load the class under test, the Connection definition.
# We're actually testig the Platform module, but it's exposed via the Connection.
require "train-alicloud/connection"

# Because InSpec is a Spec-style test suite, we're going to use MiniTest::Spec
# here, for familiar look and feel. However, this isn't InSpec (or RSpec) code.
describe TrainPlugins::AliCloud::Platform do
  it "should implement a platform method" do
    _(TrainPlugins::AliCloud::Platform.instance_methods(false)).must_include(:platform)
  end

  it "should force platform to 'alicloud'" do
    plat = TrainPlugins::AliCloud::Connection.new({}).platform
    _(plat.name).must_equal "alicloud"
    _(plat.linux?).must_equal false
    _(plat.cloud?).must_equal true
    _(plat.family).must_equal "cloud"
    _(plat.family_hierarchy).must_equal %w{cloud api}
  end

  it "provides api details in the platform data" do
    alicloud_version = Gem.loaded_specs["aliyunsdkcore"].version
    alicloud_version = "aliyunsdkcore: v#{alicloud_version}"
    plugin_version = "train-alicloud: v#{TrainPlugins::AliCloud::VERSION}"
    expected_release = "#{plugin_version}, #{alicloud_version}"
    plat = TrainPlugins::AliCloud::Connection.new({}).platform
    _(plat.release).must_equal expected_release
  end
end
