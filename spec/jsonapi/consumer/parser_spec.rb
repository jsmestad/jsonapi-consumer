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

  subject(:result) { parser.build }

  context 'for Beta JSONAPI' do
    let(:parser) { JSONAPI::Consumer::Parsers::Beta.new(Blog::Post, response) }

    context "for a collection" do
      let(:response) { OpenStruct.new(body: Responses::Beta.collection) }
      let(:first_item) { result.first }
    
      it 'contains all records' do
        expect(result.size).to eql(2)
      end

      it 'loads related comments' do
        expect(first_item.comments.size).to eql(2)
      end

      it 'casts to an instance of a class' do
        expect(first_item.user).to be_a(Blog::User)
      end
    end

    context "for a single resource" do
      let(:response) { OpenStruct.new(body: Responses::Beta.single_resource) }

      it 'casts to an instance of a class' do
        expect(result).to be_a(Blog::Post)
      end
    end
  end
end

