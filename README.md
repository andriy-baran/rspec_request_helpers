# Rspec Request Helpers

This gem provides few tools to make testing of API endpoint in your Rails application more effective.
This rules were influenced by real projects experience so
In order to use it in your `rspec/requests` specs you need to follow one rule:

    For every test example you need to define `path`, `valid_headers`, `valid_params`, and `expected_response`.

    NOTE: version 0.1.1 introduced the helpers which ensure naming conventions. They have identical names and in fact are
    wrappers around RSpec `let` functionality.

So what you'll got for that? - Few handy methods for the testing routine

| Action | Meaning | RSpec Example |
|---|---|---|
| `do_get`, `do_post`, `do_put`, `do_delete`, `do_patch` | Sends apropriate request to endpoint with valid params and headers | `get(path, valid_params, valid_headers)` |
| `assert_201_json`, `assert_404_xml`, `assert_422_json` etc | Assert response status code and mime type (Dynamicly generated based on config ) | `expect(response).to have_http_status(status)`<br>`expect(response.content_type).to eq mime_type` |
| `do_post_and_assert_201_json_response_body` | Shorthand for asserting content type, HTTP status code and if parsed body of the response is equal to | `expect(parsed_body).to eq(expected_response)` |

Version 0.2.0 introduced `database` method which acceps the code block witch allow creation of database records via `FactoryBot` and Rspec `let`, `let!` syntax.

```ruby
#
# Usage:
# user(:user, name: 'Bob') translates to let(:user) { FactoryBot.create(:user, name: 'Bob') }
# user!(:user, name: 'Bob') translates to let!(:user) { FactoryBot.create(:user, name: 'Bob') }
# user_list(:user, name: 'Bob', 3) translates to let(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
# user_list!(:user, name: 'Bob', 3) translates to let!(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
#
database do
  company2!(:company, name: name, domain_name: domain, location: location_name)
  company3!(:company, name: name2, domain_name: domain, location: location_name)
  order1!(:order, :ordered, :with_items, items_count: 1, status: IN_QC, company_id: company3.id, delivered_at: Time.zone.now)
  order2!(:order, :ordered, :with_items, items_count: 1, status: COMPLETED, company_id: company3.id, delivered_at: Time.zone.now, order_date: (Time.zone.now - 1.day))
  order3!(:order, :ordered, :with_items, items_count: 1, status: NOT_READY, company_id: company3.id)
end
```

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

## Configuration

Create file `config/initializers/rspec_request_helpers.rb`

```ruby
RspecRequestHelpers.configure do |config|
  # Supporded content types
  config.content_types = { json: 'application/json' }

  # Supported status codes
  config.status_codes  = [404, 401, 422, 200, 201]
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
