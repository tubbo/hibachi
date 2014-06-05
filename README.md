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

Now, you can run the generator to set up Hibachi's configuration
(optional):

```bash
$ rails generate hibachi:install
```

This will generate the following Rails initializer:

```ruby
require 'hibachi'

Hibachi.configure do |config|
  config.chef_json_path = "#{Rails.root}/config/chef.json"
  config.chef_dir = "#{Rails.root}/config/chef"
  config.run_in_background = false # NOTE: will be `true` by default when ActiveJob hits 1.0
end
```

## Configuration

Configuration is stored in the `Rails.application.config.hibachi`
object, which is set up by our Railtie and required upon requiring the
gem. The default settings are specified above, but you can override them
either in the generated initializer or in the Rails environment config,
just use the `config.hibachi` namespace.

- **chef_json_path** defines an absolute path to the JSON file that
  dictates user-specified configuration.
- **chef_dir** defines an absolute path to the Chef repo that has been
  installed on this machine.
- **run_in_background** is a flag that dictates whether to queue Chef
  runs in a background job or run them directly. The default is false,
  but *will* be true whenever ActiveJob is merged in, as this method has
  the best performance.

## Usage

When you want to manipulate settings, generate a new Hibachi model:

```bash
$ rails generate hibachi:model NetworkInterface name dhcp address netmask gateway
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

1. Fork it ( http://github.com/tubbo/hibachi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Commit your tests (`git commit -am 'Tests for my feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
7. ![ship it](https://assets-cdn.github.com/images/icons/emoji/shipit.png)

## License

This software is licensed under [The University of Illinois/NCSA Open
Source License](http://opensource.org/licenses/NCSA)...

    Copyright (c) 2014 Tom Scott
    All rights reserved.

    Developed by:

        Tom Scott
        TelVue Corporation

        http://www.telvue.com/


    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal with the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimers.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimers in the documentation and/or other materials provided with the distribution.
    Neither the names of Tom Scott, TelVue Corporation, nor the names of its contributors may be used to endorse or promote products derived from this Software without specific prior written permission.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE SOFTWARE.
