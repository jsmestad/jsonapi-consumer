RSpec.describe 'Connection' do
  let(:test_class) do
    Record ||= Class.new do
      include JSONAPI::Consumer::Resource
      self.host = 'http://localhost:3000/api/'

      has_one :domain
    end
  end

  let(:obj) { test_class.new(name: 'jsonapi.example', id: 'client_provided_id') }

  describe 'custom connection middleware' do

    it 'handles custom middleware' do
      stub_request(:get, "http://localhost:3000/api/basic_resources")
        .with(headers: {accept: 'application/json'})
        .to_return(headers: {content_type: "application/json"}, body: {
          basic_resources: [
            {id: '1'}
          ]
        }.to_json)

      expect { BasicResource.all }.to_not raise_error

      BasicResource.middleware do |conn|
        conn.use NotCalled
      end

      expect { BasicResource.all }.to raise_error(NotCalledError)
    end
  end

  describe '.all' do
    it 'returns all results as objects' do
      stub_request(:get, "http://localhost:3000/api/records")
        .with(headers: {accept: 'application/json'})
        .to_return(headers: {content_type: "application/json"}, body: {
          records: [
            {id: '1', name: "foo.example"},
            {id: '2', name: "bar.example"},
            {id: '3', name: "baz.example"}
          ]
        }.to_json)

      records = test_class.all
      expect(records.size).to eql(3)

      record = records.first
      expect(record).to be_a(Record)
    end

    it 'accepts additional params' do
      stub_request(:get, "http://localhost:3000/api/records")
        .with(headers: {accept: 'application/json'})
        .to_return(headers: {content_type: "application/json"}, body: {
          records: []
        }.to_json) # This should not get called.

      stub_request(:get, "http://localhost:3000/api/records?name=foo&email=bar@example.com")
        .with(headers: {accept: 'application/json'})
        .to_return(headers: {content_type: "application/json"}, body: {
          records: [
            {id: '1', name: 'bar', email: "bar.example"},
            {id: '2', name: 'foo', email: "bar.example"},
          ]
        }.to_json)

      records = test_class.all(name: 'foo', email: 'bar@example.com')
      expect(records.size).to eql(2)
    end
  end

  describe '.find' do
    it 'returns proper objects' do
      stub_request(:get, "http://localhost:3000/api/records/1")
        .with(headers: {accept: 'application/json'})
        .to_return(headers: {content_type: "application/json"}, body: {
          records: [
            {id: '1', name: "foobar.example"}
          ]
        }.to_json)

      records = test_class.find(1)
      expect(records.size).to eql(1)

      record = records.first
      expect(record).to be_a(Record)
      expect(record.id).to eql('1')
      expect(record.name).to eql('foobar.example')
    end
  end

  describe '#save' do
    it 'can save successfully if called on a new item' do
      stub_request(:post, "http://localhost:3000/api/records")
        .with(headers: {accept: 'application/json', content_type: "application/json"})
        .to_return(headers: {content_type: "application/json"}, status: 201, body: {
          records: [
            {id: '1', name: "foobar.example", created_at: "2014-10-16T18:49:40Z", updated_at: "2014-10-18T18:59:40Z"}
          ]
        }.to_json)

      expect(obj.save).to eql(true)

      expect(obj.id).to eql('1')
      expect(obj.name).to eql('foobar.example')

      expect(obj.created_at).to eql('2014-10-16T18:49:40Z')
      expect(obj.updated_at).to eql('2014-10-18T18:59:40Z')

      expect(obj).to respond_to(:created_at)
      expect(obj).to respond_to(:updated_at)
      expect(obj.persisted?).to eql(true)
    end

    it 'can update when called on an existing item' do
      stub_request(:put, "http://localhost:3000/api/records/1")
        .with(headers: {accept: 'application/json', content_type: "application/json"})
        .to_return(headers: {content_type: "application/json"}, body: {
          records: [
            {id: '1', name: "foobar.example", created_at: "2014-10-16T18:49:40Z", updated_at: "2016-10-18T18:59:40Z"}
          ]
        }.to_json)

      obj.id = '1'
      obj.instance_variable_set(:@new_record, false)
      obj.updated_at = "2014-10-18T18:59:40Z"
      expect(obj.updated_at).to eql("2014-10-18T18:59:40Z")

      expect(obj.save).to eql(true)
      expect(obj.updated_at).to eql("2016-10-18T18:59:40Z")
    end
  end

  describe '#destroy' do
    before { obj.id = '1' }

    it 'returns true when successful' do
      stub_request(:delete, "http://localhost:3000/api/records/1")
        .with(headers: {accept: "application/json"})
        .to_return(status: 204, body: nil)

      expect(obj.destroy).to eql(true)
    end
  end
end

