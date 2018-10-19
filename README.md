# Rspec Request Helpers

This gem provides few tools to make testing of API endpoint in your Rails application more effective.
This rules were influenced by real projects experience so
In order to use it in your `rspec/requests` specs you need to follow one rule:

    For every test example you need to define `path`, `valid_headers`, `valid_params`, and `expected_response`.

    NOTE: version 0.1.1 introduced the helpers which ensure naming conventions. They have identical names and in fact are
    wrappers around RSpec `let` functionality.

So what you'll got for that? Few handy methods for the testing routine

* `do_get`, `do_post`, `do_put`, `do_delete`, `do_patch` shorthands for sending appropriate requests.
* `assert_201_json`, `assert_404_xml`, `assert_422_json` etc. shorthands for asserting content type and HTTP status code only. This methods are generated depends on configuration defined in `config/initializers/rspec_request_helpers.rb`.
* `assert_201_json_response_body`, `assert_422_json_responce_body` etc. shorthands for asserting content type, HTTP status code and if parsed body of the response is equal to `valid_response`.
* `assert_201_json_response_object`, `assert_422_json_responce_body` etc. same as previous assert specific attribute rather than whole response body.
* one lined form for simple examples `do_post_and_assert_201_json_response_body`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_request_helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_request_helpers

In project directory run

    $ rails g rspec_request_helpers:install

## Usage

Include helpers into RSpec

```ruby
# spec/rails_helper.rb

RSpec.configure do |config|
  config.include RspecRequestHelpers

  # This will tell RSpec to collect all failures in test example
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true if meta[:type] == :request
  end
end
```

Generate new file for API endpoint

    $ rails g rspec:endpoint show api/v1/users

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andriy-baran/rspec_request_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RspecRequestHelpers project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/andriy-baran/rspec_request_helpers/blob/master/CODE_OF_CONDUCT.md).
