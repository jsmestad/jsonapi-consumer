# JSONAPI::Consumer

An ActiveModel-compliant consumer framework for communicating with JSONAPI-based APIs.

[![CircleCI](https://circleci.com/gh/jsmestad/jsonapi-consumer/tree/master.svg?style=svg)](https://circleci.com/gh/jsmestad/jsonapi-consumer/tree/master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-consumer', '~> 1.0'
```

And then execute:

    $ bundle

## Usage

It's suggested to create a base resource for the whole API that you can re-use.

```ruby
class Base < JSONAPI::Consumer::Resource
  # self.connection_options = {} # Faraday connection options
  # self.json_key_format = :dasherized_key # (default: underscored_key)
  # self.route_format = :dasherized_route # (default: underscored_route)
  self.site = 'http://localhost:3000/api/'
end
```

Then inherit from that Base class for each resource defined in your API.

```ruby
module Blog
  class Author < Base
    has_many :posts, class_name: 'Blog::Post'
  end

  class Post < Base
    has_one :user, class_name: 'Blog::User'
    has_many :comments, class_name: 'Blog::Comment'
  end

  class User < Base

  end

  class Comment < Base

  end
end
```


## Contributing

1. Fork it ( https://github.com/jsmestad/jsonapi-consumer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright & License

JSONAPI::Consumer is distributed under the Apache 2.0 License. See LICENSE.txt file for more information.

Version v1 is a rewrite is based on the excellent work by [json_api_client](https://github.com/chingor13/json_api_client) [v1.5.3](https://github.com/chingor13/json_api_client/tree/v1.5.3).
