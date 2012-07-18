# Simple Helpers
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/vitormil/simple_helpers)
[![Build Status](https://secure.travis-ci.org/vitormil/simple_helpers.png)](http://travis-ci.org/vitormil/simple_helpers)

Easily create variables with I18n and interpolation support to your controllers and views.

You can configure it to automaticly create some methods (like page_title, page_subtitle) or call the method **simple_helper** manually according to your needs.

To display page title in your view:

**<%= page_title %>**

### Usage

You can configure an automatic behavior to all controllers setting an initializer to your rails app:

```ruby
require "simple_helpers"

SimpleHelpers.configure do |config|
  config.helpers   = [:page_title, :page_subtitle]
  config.blacklist = [SessionsController]
end
```

And/or call the method **simple_helper** manually according to your needs:

```ruby
# some possible calls
simple_helper :page_subtitle, :special_message, :title => @post.title
special_message_options.merge({:author => @post.author.name})
page_subtitle "Keep Calm and %{text}", :text => "Call Batman"
page_subtitle "Keep Calm and Call Batman"
simple_helper :user_alert
```

If you didn't set manually the values, the gem will get it from I18n files.

```ruby
en:
  titles:
    simple_helper_default:
      "Default page title"
    users:
      new: "Sign up"
      show: "%{name}'s Page"
  user_alerts:
    users:
      index: "Heads up! This alert needs your attention."
```

### Interpolation

In many cases you want to abstract your translations so that variables can be interpolated into the translation, just like Rails do.

```ruby
page_title :name => @user.name
or
page_title_options.merge!({:name => "John Doe"})
or
simple_helper :page_title, :name => "John Doe"
```

### Aliases

There are some action aliases:

```ruby
"create" => "new"
"update" => "edit"
"remove" => "destroy"
```

I18n Backend Chain:

```ruby
en:
  <helper method name>:
    simple_helper_default:
      "My default data"
    <controller>:
      <action>: "My custom data for this action"
```

Adding custom aliases:

```ruby
class PostsController < ApplicationController

  SIMPLE_HELPER_ALIASES = {
    "the_custom_action" => "index"
  }

  def index
    ...
  end

  def the_custom_action
    ...
  end

end
```

This means that the I18n scope for the action "the_custom_action" will be the same as "index".

You can also specify a custom location at the "scope" key at the options hash, like rails does.

```ruby
simple_helper :page_title, :scope => "my.awesome.chain", :name => "John"
or
page_title_options.merge!({:scope => "my.awesome.chain", :name => "John"})
```

Make sure you have this scope defined in a locale file:

```ruby
en:
  my:
    awesome:
      chain: "What's up %{name}?"
```

## Getting started

### Instalation

```ruby
gem install simple_helpers
```

### Setup

Simple helpers works with Rails 3.0 onwards. You can add it to your Gemfile with:

**gem 'simple_helpers'**

Run the bundle command to install it.

After you install and add it to your Gemfile, you need to run the generator to create the initializer file. In this file you will configure the default behavior to your controllers.

**rails generate simple_helpers**

Take a look at the generated file:

https://github.com/vitormil/simple_helpers/blob/master/templates/initializer.rb

## Maintainer

* Vitor Oliveira (<http://github.com/vitormil>)

## Special thanks

I have been studying (and learning a lot!) with Nando Vieira (@fnando) and this gem was inspired by the "page_title" feature from his gem @swiss_knife.

Check out his work! Thanks @fnando
- http://nandovieira.com.br/
- http://github.com/fnando

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
