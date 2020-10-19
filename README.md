# train-alicloud - Train Plugin for connecting to AliCloud

* **[Project State](https://github.com/chef/chef-oss-practices/blob/master/repo-management/repo-states.md): Prototyping**

This plugin allows applications that rely on Train to communicate with the AliCloud API.  For example, InSpec uses this to perform compliance checks against AliCloud infrastructure components.

The plugin is a wrapper around `aliyunsdkcore` version 0, with additional service-specific gems added where needed by the `inspec-alicloud` resource pack.

Train itself has no CLI, nor a sophisticated test harness.  InSpec does have such facilities, so installing Train plugins will require an InSpec installation.  You do not need to use or understand InSpec.

Train plugins may be developed without an InSpec installation.

## To Install this as a User

Train plugins are distributed as gems.  You may choose to manage the gem yourself, but if you are an InSpec user, InSpec can handle it for you.

You will need InSpec v2.3 or later.

Simply run:

```
$ bundle exec inspec plugin install ../train-alicloud/
```

You can then run:

```
$ bundle exec inspec detect -t alicloud://
────────────────────────────── Platform Details ──────────────────────────────

Name:      alicloud
Families:  cloud, api
Release:   train-alicloud: v0.0.1, aliyunsdkcore: v0.0.16
```

## Authenticating to AliCloud

These instructions assume you are using InSpec.

### Setting up AliCloud credentials for InSpec

InSpec uses the standard AliCloud authentication mechanisms. Typically, you will create an RAM user specifically for auditing activities.

#### Using Environment Variables to provide credentials

You may provide the credentials to InSpec by setting the following environment variables: `AWS_REGION`, `ALICLOUD_ACCESS_KEY`, and `ALICLOUD_SECRET_KEY`.

Once you have your environment variables set, you can verify your credentials by running:

```bash
you$ inspec detect -t alicloud://

────────────────────────────── Platform Details ──────────────────────────────

Name:      alicloud
Families:  cloud, api
Release:   train-alicloud: v0.0.1, aliyunsdkcore: v0.0.16
```

#### Using the InSpec target option to specify a region

You can run InSpec using the `--target` / `-t` option, using the format `-t alicloud://region`.  For example, to connect to the London region, use `-t alicloud://eu-west-1`. In this case, you only need to set `ALICLOUD_ACCESS_KEY`, and `ALICLOUD_SECRET_KEY` as environment variables.

To verify your credentials,

```bash
you$ inspec detect -t alicloud://eu-west-1

────────────────────────────── Platform Details ──────────────────────────────

Name:      alicloud
Families:  cloud, api
Release:   train-alicloud: v0.0.1, aliyunsdkcore: v0.0.16
```

## Reporting Issues

Bugs, typos, limitations, and frustrations are welcome to be reported through the [GitHub issues page for the train-alicloud project](https://github.com/chef-customers/train-alicloud/issues).

You may also ask questions in the #inspec channel of the CHef Community Slack team.  However, for an issue to get traction, please report it as a github issue.

## Development on this Plugin

### Development Process

If you wish to contribute to this plugin, please use the usual fork-branch-push-PR cycle.  All functional changes need new tests, and bugfixes are expected to include a new test that demonstrates the bug.

### Reference Information

[Plugin Development](https://github.com/inspec/train/blob/master/docs/dev/plugins.md) is documented on the `train` project on GitHub.

### Testing changes against AliCloud

Live-fire testing against AliCloud may be performed by the `integration` set of tests.  To run the integration tests, you will need to have a set of AliCloud credentials exported to your environment.  See test/integration/live_connect_test.rb .
