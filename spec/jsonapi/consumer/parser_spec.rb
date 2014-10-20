RSpec.describe 'Response Parsing' do
  let(:response) { OpenStruct.new(body: Responses.sideload) }
  let(:parser) { JSONAPI::Consumer::Parser.new(Blog::Post, response) }

  subject(:results) { parser.build }

  it 'can handle linked associations' do
    stub_request(:get, 'http://localhost:3000/api/comments/9c9ba83b-024c-4d4c-9573-9fd41b95fc14')
      .to_return(headers: {content_type: "application/json"}, body: {
          comments: [
            {
              id: '9c9ba83b-024c-4d4c-9573-9fd41b95fc14',
              content: "i found this useful."
            }
          ]
        }.to_json)

    stub_request(:get, 'http://localhost:3000/api/comments/27fcf6e8-24b0-41db-94b1-812046a10f54')
      .to_return(headers: {content_type: "application/json"}, body: {
          comments: [
            {
              id: '27fcf6e8-24b0-41db-94b1-812046a10f54',
              content: "i found this useful."
            }
          ]
        }.to_json)

    # puts results.inspect
    expect(results.size).to eql(2)

    result = results.first
    expect(result.comments.size).to eql(2)

    last = results.last
    expect(result.comments.size).to eql(2)

  end
end
