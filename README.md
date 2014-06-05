# Hibachi

Hibachi is a bridge between your Rails application and your Chef
configuration. It provides a framework for building Rails models
that persist to a central JSON file rather than a database, as well as
automatically running Chef in an `ActiveJob` in the background.

## Installation

Add the gem to your Gemfile:

```ruby
gem 'hibachi'
```

Run the following command to install:

```bash
$ bundle
```

Now, you can run the generator to set up Hibachi's configuration:

```bash
$ rails generate hibachi:install
```

## Usage

When you want to manipulate settings, generate a new Hibachi model:

```bash
$ rails generate hibachi:model NetworkInterface
```

You'll get a file that looks like this:

```ruby
class NetworkInterface < Hibachi::Model
  recipe :network_interfaces

  attr_accessor :name, :dhcp, :address, :netmask, :gateway

end
```

`Hibachi::Model` is really just an `ActiveModel::Model` with some added
sugar. So you can use all the validation and callbacks you'd expect from
an ActiveModel:

```ruby
class NetworkInterface < Hibachi::Model
  recipe :network_interfaces

  attr_accessor :name, :dhcp, :address, :netmask, :gateway

  validates :name, presence: true
  validates :dhcp, presence: true

  validates :address, presence: true, :if => :dhcp?
  validates :netmask, presence: true, :if => :dhcp?
  validates :gateway, presence: true, :if => :dhcp?

  def dhcp?
    !!dhcp
  end
end
```

When you want to add a new interface, you can do it as if it were a
regular ActiveRecord model:

```ruby
NetworkInterface.create name: 'eth2', dhcp: true
```

Running `create()` will not only persist this new setting to the JSON,
but will also run Chef on the box for the recipe provided in the class
definition.

Other AR-like methods such as `update()` and `destroy()` are also
available. They pretty much take the same parameters.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/hibachi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
