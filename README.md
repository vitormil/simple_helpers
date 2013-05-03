# Simple Helpers
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/vitormil/simple_helpers)
[![Build Status](https://secure.travis-ci.org/vitormil/simple_helpers.png)](http://travis-ci.org/vitormil/simple_helpers)

Allow you to easily create helper methods with I18n support and **easy interpolation** with instance variables and methods.

## Example

To display page title in your view:

```ruby
<head>
  <title><%= page_title %></title>
  ...
</head>
```

Create a file `./config/locale/simple_helpers.yml` (could be another name) to store the values, following the convention: `<helper>.<controller>.<action>`

```ruby
en:
  page_title:
    posts:
      new: "New Post"
      show: "{{@post.title}}"
      edit: "Editing {{@post.title}}"
      search: "Search results for {{@query}}..."
    users:
      show: "{{@user.name}}'s profile"
      new: "{{get_title}}"
      edit: "Edit user"
      destroy: "Delete user"
```

### Easy Interpolation

Simple helpers will look for instance variables and methods in the controller, and get the value to interpolate with the i18n values. Awesome!!! :)

### Configuration

Initializer `./config/initializers/simple_helpers.rb`

```ruby
require "simple_helpers"

SimpleHelpers.configure do |config|
  config.helpers = {
    page_title: { prefix: "MyBlog" }  # other options: suffix, separator
  }
end
```

### Aliases

There are some action aliases:

```ruby
"create" => "new"
"update" => "edit"
"remove" => "destroy"
```

## Getting started

### Instalation

```ruby
gem install simple_helpers
```

### Setup

Simple helpers works with Rails 3.0 onwards. You can add it to your Gemfile with:

```ruby
gem 'simple_helpers'
```

Run the bundle command to install it.

After you install and add it to your Gemfile, you need to run the generator to create the initializer file. In this file you will configure the default behavior to your controllers.

```ruby
rails generate simple_helpers
```

## Maintainer

* Vitor Oliveira (<http://github.com/vitormil>)

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
