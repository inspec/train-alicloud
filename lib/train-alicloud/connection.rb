# Connection definition file for an example Train plugin.

# Most of the work of a Train plugin happens in this file.
# Connections derive from Train::Plugins::Transport::BaseConnection,
# and provide a variety of services.  Later generations of the plugin
# API will likely separate out these responsibilities, but for now,
# some of the responsibilities include:
# * authentication to the target
# * platform / release /family detection
# * caching
# * API execution
# * marshalling to / from JSON
# You don't have to worry about most of this.

# Push platform detection out to a mixin, as it tends
# to develop at a different cadence than the rest
require_relative "platform"
require "train"
require "train/plugins"

require "aliyunsdkcore"

module TrainPlugins
  module AliCloud
    # You must inherit from BaseConnection.
    class Connection < Train::Plugins::Transport::BaseConnection
      # We've placed platform detection in a separate module; pull it in here.
      include TrainPlugins::AliCloud::Platform

      def initialize(options)
        # 'options' here is a hash, Symbol-keyed,
        # of what Train.target_config decided to do with the URI that it was
        # passed by `inspec -t` (or however the application gathered target information)
        # Some plugins might use this moment to capture credentials from the URI,
        # and the configure an underlying SDK accordingly.
        # You might also take a moment to manipulate the options.
        # Have a look at the Local, SSH, and AWS transports for ideas about what
        # you can do with the options.

        # Override for any cli options
        # alicloud://region
        options[:region] = options[:host] || options[:region]

        # Now let the BaseConnection have a chance to configure itself.
        super(options)

        # Force enable caching.
        enable_cache :api_call

        # Why are we doing this?
        ENV["ALICLOUD_REGION"] = @options[:region] if @options[:region]
      end

      def alicloud_client(api:, api_version:)
        region = @options[:region]

        endpoint ||= if api == 'sts'
                       "https://#{api}.aliyuncs.com"
                     else
                       "https://#{api}.#{region}.aliyuncs.com"
                     end

        RPCClient.new(
          access_key_id:     @options[:access_key_id],
          access_key_secret: @options[:secret_access_key],
          endpoint:          endpoint,
          api_version:       api_version
        )
      end

      def alicloud_resource(klass, args)
        klass.new(args)
      end

      # TODO: determine exactly what this is used for
      def uri
        "alicloud://#{@options[:region]}"
      end

      def unique_identifier
        # use alicloud account id
        caller_identity = alicloud_client(api: 'sts', api_version: '2015-04-01').request(action: 'GetCallerIdentity')
        caller_identity['AccountId']
      end
    end
  end
end
