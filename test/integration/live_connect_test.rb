# This test is like the functional tests in that it initializes
# a Connection object.  Unlike the functional tests, it uses the
# Connection to actually access AWS.

# To use this test, you must have in your ENV:
#  * ALICLOUD_ACCESS_KEY
#  * ALICLOUD_SECRET_KEY
#  * ALICLOUD_REGION
# These must be set to real values.

require "train"
require_relative "../helper"
require "aliyunsdkcore"

# On load, scrape all AWS_* ENV vars out and store them
# We'll re-inject them as needed
ORIG_ALICLOUD_ENV_VARS = ENV.keys.each_with_object({}) do |var_name, acc|
  if var_name.start_with?("ALICLOUD")
    acc[var_name] = ENV.delete(var_name)
  end
  acc
end

describe "Live-fire connections to AliCloud" do
  # Purge ENV prior to each test
  before do
    ENV.delete_if { |var_name, _| var_name.start_with?("ALICLOUD") }

    skip "Bad ENV!" unless ORIG_ALICLOUD_ENV_VARS.size >= 3
  end

  let(:key_id) { ORIG_ALICLOUD_ENV_VARS["ALICLOUD_ACCESS_KEY"] }
  let(:secret_key) { ORIG_ALICLOUD_ENV_VARS["ALICLOUD_SECRET_KEY"] }
  let(:region) { ORIG_ALICLOUD_ENV_VARS["ALICLOUD_REGION"] }

  describe "that use a variety of authentication methods" do
    let(:transport_options) { { backend: "alicloud" } }
    let(:transport) { Train.create("alicloud", transport_options) }
    let(:connection) { transport.connection }
    let(:uuid) { connection.unique_identifier }

    it "works correctly using a target URI with region" do
      ENV["ALICLOUD_ACCESS_KEY"] = key_id
      ENV["ALICLOUD_SECRET_KEY"] = secret_key
      transport_options = Train.unpack_target_from_uri("alicloud://#{region}")
      # TODO: figure out why memoizing these with let: breaks the test
      transport = Train.create("alicloud", transport_options)
      connection = transport.connection
      uuid = connection.unique_identifier
      _(uuid.length).must_equal 16
    end

    it "works correctly using region directly passed in" do
      ENV["ALICLOUD_ACCESS_KEY"] = key_id
      ENV["ALICLOUD_SECRET_KEY"] = secret_key
      transport = Train.create("alicloud", region: region)
      connection = transport.connection
      uuid = connection.unique_identifier
      _(uuid.length).must_equal 16
    end

    it "works correctly when the key and region are in the ENV" do
      ENV["ALICLOUD_REGION"] = region
      ENV["ALICLOUD_ACCESS_KEY"] = key_id
      ENV["ALICLOUD_SECRET_KEY"] = secret_key
      _(uuid.length).must_equal 16
    end
  end
end
