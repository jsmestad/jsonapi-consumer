RSpec.describe 'Connection' do
  let(:test_class) do
    Record ||= Class.new do
      include JSONAPI::Consumer::Resource
      self.host = 'http://localhost:3000/api/'

      has_one :domain
    end
  end

  let(:obj) { test_class.new(name: 'jsonapi.example') }

  describe '#all' do
    it 'returns all results as objects' do
      stub_request(:get, "http://localhost:3000/api/records")
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
  end

  describe '#find' do
    it 'returns proper objects' do
      stub_request(:get, "http://localhost:3000/api/records?id=1")
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
    it 'can save successfully' do
      stub_request(:post, "http://localhost:3000/api/records")
        .to_return(headers: {content_type: "application/json"}, body: {
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
  end
end

