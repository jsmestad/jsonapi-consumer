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
end

RSpec.describe 'Response Parsing' do

  subject(:results) { parser.build }

  context 'for Beta JSONAPI' do
    let(:response) { OpenStruct.new(body: Responses::Beta.sideload) }
    let(:parser) { JSONAPI::Consumer::Parsers::Beta.new(Blog::Post, response) }

    it_behaves_like 'a valid parser'
  end
end

