# JSONAPI::Consumer

An ActiveModel-compliant consumer framework for communicating with JSONAPI-based APIs.

[![Build Status](https://travis-ci.org/jsmestad/jsonapi-consumer.svg?branch=develop)](https://travis-ci.org/jsmestad/jsonapi-consumer)

## Note on develop branch

`master` works with previous JSONAPI standards. The `develop` branch supports
only the latest JSONAPI standard (which is RC3 as of Mar 2015).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-consumer', github: 'jsmestad/jsonapi-consumer', branch: 'develop'
```

And then execute:

    $ bundle

## Usage

It's suggested to create a base resource for the whole API that you can re-use.

```ruby
class Base
  include JSONAPI::Consumer::Resource

  self.host = 'http://localhost:3000/api/'
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

#### Additional Features

##### Dynamic Objects

By default calling `.new` or `.build` on a resource will give you an empty
object with no attributes defined. This is less than ideal when building forms
with something like Rails' FormBuilder.

We suggest setting up your model to do a `GET /{resource_name}/new` if your
server supports it and using `.build` instead of `.new`. This will populate the
object with defaults set by the server response.

```ruby
class User
  include JSONAPI::Consumer::Resource

  self.request_new_object_on_build = true

  # .build will now call GET /users/new
end
```

#### Testing

We suggest [Webmock](https://github.com/bblimke/webmock) at this stage in
development. We plan to add test helpers before the first major release.

## Contributing

1. Fork it ( https://github.com/jsmestad/jsonapi-consumer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright & License

JSONAPI::Consumer is distributed under the Apache 2.0 License. See LICENSE.txt file for more information.
