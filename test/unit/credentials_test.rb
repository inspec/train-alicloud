# Because train-alicloud is an API-type plugin, and AliCloud requires credentials for
# most operations, the plugin must handle obtaining AliCloud credentials in various ways.

# Include our test harness
require "helper"

describe "AWS credential handling" do
  # Note: we re-declare test_options in several blocks
  let(:given_options) { nil }

  let(:transport) do
    ENV["ALICLOUD_REGION"] = "fixture_region_from_env"
    ENV["ALICLOUD_ACCESS_KEY"] = "fixture_key_id_from_env"
    ENV["ALICLOUD_SECRET_KEY"] = "fixture_access_key_from_env"

    # need to load this here as it captures the envs on load
    load "train-alicloud/transport.rb"
    TrainPlugins::AliCloud::Transport.new(given_options)
  end

  let(:connection) { transport.connection }
  let(:observed_options) { connection.instance_variable_get(:@options) }
  let(:cache) { connection.instance_variable_get(:@cache) }

  describe "when no options provided" do
    it "defaults to env options" do
      _(observed_options[:region]).must_equal "fixture_region_from_env"
      _(observed_options[:access_key_id]).must_equal "fixture_key_id_from_env"
      _(observed_options[:secret_access_key]).must_equal "fixture_access_key_from_env"
    end
  end

  describe "when given AWS-specific options" do
    let(:given_options) { { region: "overidden_region", access_key_id: "overidden_key" } }

    it "should override defaults when given options" do
      _(observed_options[:region]).must_equal "overidden_region"
      _(observed_options[:access_key_id]).must_equal "overidden_key"
      # These were not overridden
      _(observed_options[:secret_access_key]).must_equal "fixture_access_key_from_env"
    end
  end

  describe "when parsing a URL" do
    let(:given_options) { { host: "region_from_url" } }

    it "should handle options resulting from a parsed URL" do
      # Train accepts target options in the form of URLs.
      # For AliCloud, the URI looks like:
      #  aws://region
      # When Train.create is called and the URL is parsed, Train exposes the
      # URI parts as a URL with host, path, etc.
      # train-alicloud takes those parsed pieces and re-labels them according
      # to AWS credential components.
      _(observed_options[:region]).must_equal "region_from_url"
    end
  end
end
