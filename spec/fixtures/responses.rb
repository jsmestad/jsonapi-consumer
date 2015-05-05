module Responses
  module Stable
    def self.sideload
      {
        posts: [
          {
            links: {
              comments: [
                "82083863-bba9-480e-a281-f5d34e7dc0ca",
                "3b402e8a-7c35-4915-8c72-07ea7779ab76"
              ],
              user: "6a45992f-cd20-497a-a753-21b2a1a82356"
            },
            id: "e6d1b7ac-80d8-40dd-877d-f5bd40feabfb",
            title: "Friday Post",
            created_at: "2014-10-19T22:32:52.913Z",
            updated_at: "2014-10-19T22:32:52.967Z"
          },
          {
            links: {
              comments: [
                "9c9ba83b-024c-4d4c-9573-9fd41b95fc14",
                "27fcf6e8-24b0-41db-94b1-812046a10f54"
              ],
              user: "d65dda70-73eb-461a-bb34-5484e6e8c194"
            },
            id: "ea006f14-6d05-4e87-bfe7-ee8ae3358840",
            title: "Monday Post",
            created_at: "2014-10-19T22:32:52.933Z",
            updated_at: "2014-10-19T22:32:52.969Z"
          }
        ],
        linked: {
          users: [
            {
              id: "6a45992f-cd20-497a-a753-21b2a1a82356",
              name: "Jane Smith"
            },
            {
              id: "d65dda70-73eb-461a-bb34-5484e6e8c194",
              name: "Jim Bob"
            }
          ],
          comments: [
            {
              id: "82083863-bba9-480e-a281-f5d34e7dc0ca",
              content: "Awesome article",
              created_at: "2014-10-19T22:32:52.933Z",
              updated_at: "2014-10-19T22:32:52.969Z"
            },
            {
              id: "3b402e8a-7c35-4915-8c72-07ea7779ab76",
              content: "Hated it",
              created_at: "2014-10-19T22:32:52.933Z",
              updated_at: "2014-10-19T22:32:52.969Z"
            }
          ]
        },
        links: {
          :"posts.comments" => "http://localhost:3000/api/comments/{posts.comments}",
          :"posts.user" => "http://localhost:3000/api/comments/{posts.user}"
        }
      }.with_indifferent_access
    end
  end

  module Beta
    def self.collection
      {
        data: [
          {
            id: "e6d1b7ac-80d8-40dd-877d-f5bd40feabfb",
            type: "posts",
            title: "Friday Post",
            created_at: "2014-10-19T22:32:52.913Z",
            updated_at: "2014-10-19T22:32:52.967Z",
            links: {
              self: "http://localhost:3000/api/posts/e6d1b7ac-80d8-40dd-877d-f5bd40feabfb",
              comments: {
                type: "comments",
                id: [
                  "82083863-bba9-480e-a281-f5d34e7dc0ca",
                  "3b402e8a-7c35-4915-8c72-07ea7779ab76"
                ]
              },
              user: {
                type: "users",
                id: "6a45992f-cd20-497a-a753-21b2a1a82356"
              }
            },
          },
          {
            id: "ea006f14-6d05-4e87-bfe7-ee8ae3358840",
            type: "post",
            title: "Monday Post",
            created_at: "2014-10-19T22:32:52.933Z",
            updated_at: "2014-10-19T22:32:52.969Z",
            links: {
              self: "http://localhost:3000/api/posts/ea006f14-6d05-4e87-bfe7-ee8ae3358840",
              comments: {
                type: "comments",
                id: []
              },
              user: {
                type: "users",
                id: "d65dda70-73eb-461a-bb34-5484e6e8c194"
              }
            }
          }
        ],
        linked: [
          {
            id: "6a45992f-cd20-497a-a753-21b2a1a82356",
            type: "users",
            name: "Jane Smith",
            links: {
              self: "http://localhost:3000/api/users/6a45992f-cd20-497a-a753-21b2a1a82356"
            }
          },
          {
            id: "d65dda70-73eb-461a-bb34-5484e6e8c194",
            type: "users",
            name: "Jim Bob",
            links: {
              self: "http://localhost:3000/api/users/d65dda70-73eb-461a-bb34-5484e6e8c194"
            }
          },
          {
            id: "82083863-bba9-480e-a281-f5d34e7dc0ca",
            type: "comments",
            content: "Awesome article",
            created_at: "2014-10-19T22:32:52.933Z",
            updated_at: "2014-10-19T22:32:52.969Z",
            links: {
              self: "http://localhost:3000/api/comments/82083863-bba9-480e-a281-f5d34e7dc0ca"
            }
          },
          {
            id: "3b402e8a-7c35-4915-8c72-07ea7779ab76",
            type: "comments",
            content: "Hated it",
            created_at: "2014-10-19T22:32:52.933Z",
            updated_at: "2014-10-19T22:32:52.969Z",
            links: {
              self: "http://localhost:3000/api/comments/3b402e8a-7c35-4915-8c72-07ea7779ab76"
            }
          }
        ]
      }.with_indifferent_access
    end

    def self.single_resource
      {
        data: {
          id: "e6d1b7ac-80d8-40dd-877d-f5bd40feabfb",
          type: "posts",
          title: "Friday Post",
          created_at: "2014-10-19T22:32:52.913Z",
          updated_at: "2014-10-19T22:32:52.967Z",
          links: {
            self: "http://localhost:3000/api/posts/e6d1b7ac-80d8-40dd-877d-f5bd40feabfb",
            comments: {
              type: "comments",
              id: [
                "82083863-bba9-480e-a281-f5d34e7dc0ca"
              ]
            },
            user: {
              type: "users",
              id: "6a45992f-cd20-497a-a753-21b2a1a82356"
            }
          }
        },
        linked: [
          {
            id: "6a45992f-cd20-497a-a753-21b2a1a82356",
            type: "users",
            name: "Jane Smith",
            links: {
              self: "http://localhost:3000/api/users/6a45992f-cd20-497a-a753-21b2a1a82356"
            }
          },
          {
            id: "82083863-bba9-480e-a281-f5d34e7dc0ca",
            type: "comments",
            content: "Awesome article",
            created_at: "2014-10-19T22:32:52.933Z",
            updated_at: "2014-10-19T22:32:52.969Z",
            links: {
              self: "http://localhost:3000/api/comments/82083863-bba9-480e-a281-f5d34e7dc0ca"
            }
          }
        ]
      }.with_indifferent_access
    end
  end
end
