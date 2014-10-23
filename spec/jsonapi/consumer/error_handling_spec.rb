RSpec.describe 'Error handling' do
  let(:test_class) do
    Record ||= Class.new do
      include JSONAPI::Consumer::Resource
      self.host = 'http://localhost:3000/api/'

      has_one :domain
    end
  end

  let(:obj) { test_class.new(name: 'jsonapi.example') }

  context 'on model' do
    it 'adds to the errors object on the model' do
      stub_request(:post, "http://localhost:3000/api/records")
        .to_return(headers: {content_type: "application/json"}, status: 400, body: {
          errors: [
            {title: 'cannot be blank', path: "/name", detail: 'name cannot be blank'},
            {title: 'is invalid', path: '/type', detail: 'type is invalid'}
          ]
        }.to_json)

      expect(obj.save).to eql(false)
      expect(obj.is_valid?).to eql(false)
    end
  end

  context 'in general' do
    it 'handles timeout errors' do
      stub_request(:any, "http://localhost:3000/api/records").to_timeout

      expect {
        obj.save
      }.to raise_error(JSONAPI::Consumer::Errors::ServerNotResponding)
    end
  end
end
