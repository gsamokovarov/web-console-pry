[![Travis](https://travis-ci.org/gsamokovarov/web-console-pry.png)](https://travis-ci.org/gsamokovarov/web-console-pry)

Pry Support for Web Console
===========================

If you are one of those folks that prefer `Pry` over `IRB` for the Rails'
console you can use this adapter to put a `Pry` session in your [Web Console].

Installation
------------

To install it in your current application, add the following to your `Gemfile`.

```ruby
group :development do
  gem 'web-console-pry', '~> 0.1.0'
end
```

After you save the `Gemfile` changes, make sure to run `bundle install` and
restart your server for the [Web Console] to take affect.

Configuration
-------------

By design, [Web Console] follows Rails' console configuration. This simply
means, that it will use `IRB`, unless configured otherwise.

```ruby
# You may need to require 'pry' to get the ::Pry constant.
require 'pry'

class Application < Rails::Application
  config.console = ::Pry
end
```

For the full list of configuration options, visit [Web Console] homepage.

Compatibility
-------------

[Web Console] doesn't try to be a terminal emulator. While we try to provide
what makes sense for a good user experience, we realize that [Terminal Emulators]
are hard and even harder to put on the Web.

Long story short, we'll explicitly disable `Pry` pager and colored output for
the [Web Console] session.

_(Color support will probably make it into the future versions, though.)_

  [Terminal Emulators]: http://en.wikipedia.org/wiki/Terminal_emulator
  [Web Console]: https://github.com/gsamokovarov/web-console
