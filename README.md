# Hibachi

An object-resource mapper for your Chef server. Enables a Rails app to
manipulate its own Chef node attributes and trigger a +chef-client+
run on its local machine, as well as others.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hibachi'
```

And then execute:

```bash
$ bundle
```

## Usage

Generate a new model with the following command:

```bash
$ rails generate hibachi:model network_interface name is_static:boolean address netmask gateway --plural
```

This will generate the following model and an accompanying test:

```ruby
class NetworkInterface < Hibachi::Model
  pluralized!

  field :name, type: String
  field :is_static, type: Boolean
  field :address, type: String
  field :netmask, type: String
  field :gateway, type: String
end
```

To learn more about how to use Hibachi, [visit the Wiki][wiki]

## Development

You can run `bin/setup` to install all dependencies in one go, and
`bin/console` for an interactive console prompt. We also provide `rake`
and `rspec` commands for running regular shell tasks.

### Running Tests

To run tests and check against the Ruby style guide:

```bash
$ bin/rake test
```

### Will It Build?

Make sure the gem builds properly with the default Rake task:

```bash
$ rake
```

**NOTE:** This also runs tests.

### Releasing

To release a new version of this gem, bump the version number in
`lib/hibachi/version.rb` and run the following command to push a Git tag
to the server. Travis will handle deploying the gem to RubyGems on new
successful tag builds:

```bash
$ rake publish
```

### Contributing

A passing build is required for any contributions made to this project.
We also prefer you write tests for any new features you wish to add and
use the test framework to highlight how and why bug fixes had to occur.

1. Fork it ( https://github.com/tubbo/hibachi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[wiki]: https://github.com/tubbo/hibachi/wiki
