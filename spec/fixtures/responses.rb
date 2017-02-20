module Responses
  def self.sideload
    {
      data: [
        {
          type: :posts,
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
          type: :posts,
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
            type: :users,
            id: "6a45992f-cd20-497a-a753-21b2a1a82356",
            name: "Jane Smith"
          },
          {
            type: :users,
            id: "d65dda70-73eb-461a-bb34-5484e6e8c194",
            name: "Jim Bob"
          }
        ],
        comments: [
          {
            type: :users,
            id: "82083863-bba9-480e-a281-f5d34e7dc0ca",
            content: "Awesome article",
            created_at: "2014-10-19T22:32:52.933Z",
            updated_at: "2014-10-19T22:32:52.969Z"
          },
          {
            type: :users,
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
