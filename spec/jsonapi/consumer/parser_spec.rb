require 'spec_helper'

RSpec.shared_examples 'a valid parser' do
  let(:result) { results.first }

  it 'contains all records' do
    expect(results.size).to eql(2)
  end

  it 'loads related comments' do
    result = results.first
    expect(result.comments.size).to eql(2)
  end

  it 'casts to an instance of a class' do
    expect(result.user).to be_a(Blog::User)
  end

  it 'sets the right attributes' do
    last = results.last
    expect(last.comments.first).to be_a(Blog::Comment)
    expect(last.comments.first.id).to eql("9c9ba83b-024c-4d4c-9573-9fd41b95fc14")
    expect(last.comments.first.content).to eql("i found this useful.")
  end
end

RSpec.describe 'Response Parsing' do

  subject(:results) { parser.build }

  context 'for Beta JSONAPI' do
    let(:response) { OpenStruct.new(body: Responses::Beta.sideload) }
    let(:parser) { JSONAPI::Consumer::Parser.new(Blog::Post, response) }

    before do
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
                content: "i found this useful too."
              }
            ]
          }.to_json)
    end

    it_behaves_like 'a valid parser'
  end

  context 'for stable JSONAPI' do
    let(:response) { OpenStruct.new(body: Responses::Stable.sideload) }
    let(:parser) { JSONAPI::Consumer::Parser.new(Blog::Post, response) }

    before do
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
                content: "i found this useful too."
              }
            ]
          }.to_json)
    end

    it_behaves_like 'a valid parser'
  end
end

