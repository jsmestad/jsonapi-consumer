class Base
  include JSONAPI::Consumer::Resource

  self.host = 'http://localhost:3000/api/'
end


class BasicResource < Base

end

class BuildRequest < Base
  self.request_new_object_on_build = true
end


# BEGIN - Blog example
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
    # belongs_to :post, class_name: 'Blog::Post'
    # has_one :author, class_name: 'Blog::Author'
  end
end
# END - Blog example


class NotCalled < Faraday::Response::Middleware
  class ::NotCalledError < StandardError; end
  def parse(body)
    raise NotCalledError, "this should not be called"
  end
end
