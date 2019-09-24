# Rspec Request Helpers

This gem provides few helpers for request testing

This rules were influenced by real projects experience so
In order to use it for your `rspec/requests` specs you need to follow convention

```ruby
  RSpec.describe 'Some API' do
    path { '/api/v1/posts' }
    headers do
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'X-App-Token' => user.api_key
      }
    end
    params do
      {
        name: name,
        description: description,
        author_id: author_id
      }
    end
    response do
      { id: 123, name: name, description: description, author: 'Bob Poster' }
    end

    it `creates post` do
      # Ex. do_post_and_assert_201_json_parsed
    end
  end
```

So what you'll got for that? - Few handy methods for the testing routine

| Action | Meaning | RSpec Example |
|---|---|---|
| `do_get`, `do_post`, `do_put`, `do_delete`, `do_patch` | Sends apropriate request to endpoint with valid params and headers | `get(path, params, headers)` |
| `assert_201_json`, `assert_404_xml`, `assert_422_json` etc | Assert response status code and mime type (Dynamicly generated based on config ) | `expect(response).to have_http_status(status)`<br>`expect(response.content_type).to eq mime_type` |
| `assert_200_json_raw`, `assert_201_json_hash`, `assert_201_json_object` | Same as above plus check against raw, hash or object presentation of response | `expect(response_body).to eq(expected_response)`
| `do_post_and_assert_201_json_parsed` | Shorthand for asserting content type, HTTP status code and if parsed body of the response is equal to | `expect(response_hash).to eq(expected_response)` |

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

## Configuration

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

Create file `config/initializers/rspec_request_helpers.rb`

```ruby
RspecRequestHelpers.configure do |config|
  # Supporded content types
  config.content_types = { json: 'application/json' }

  # Supported status codes
  config.status_codes  = [404, 401, 422, 200, 201]
end
```
## Usage

### Generate new rspec file for API endpoint

    $ rails g rspec:endpoint <action name>

    Example:

    $ rails g rspec:endpoint api/v1/users/show

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andriy-baran/rspec_request_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RspecRequestHelpers project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/andriy-baran/rspec_request_helpers/blob/master/CODE_OF_CONDUCT.md).
