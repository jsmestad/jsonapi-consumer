RSpec.describe 'Attributes' do
  let(:test_class) do
    AttrRecord ||= Class.new do
      include JSONAPI::Consumer::Resource
      self.host = 'http://localhost:3000/api/'
    end
  end

  subject(:obj) { test_class.new }

  its(:primary_key) { is_expected.to eql(:id) }

  describe 'changing the primary key' do
    it 'is updatable on the class' do
      expect {
        obj.class.primary_key = :name
      }.to change{obj.primary_key}.to(:name)
    end
  end

  describe '#new_record? / #persisted?' do
    it 'changed only after saving' do
      stub_request(:post, "http://localhost:3000/api/attr_records")
        .with(headers: {accept: 'application/json', content_type: "application/json"})
        .to_return(headers: {content_type: "application/json"}, status: 201, body: {
          data: [
            {
              type: 'records',
              id: '1',
              name: "foobar.example",
              created_at: "2014-10-16T18:49:40Z",
              updated_at: "2014-10-18T18:59:40Z"
            }
          ]
        }.to_json)
      obj.id = '8'
      expect {
        obj.save
      }.to change{obj.new_record?}.from(true).to(false)
    end

    it 'is persisted after loading' do
      stub_request(:get, "http://localhost:3000/api/attr_records/1")
        .with(headers: {accept: 'application/json'})
        .to_return(headers: {content_type: "application/json"}, body: {
          data: [
            {type: 'records', id: '1', name: "foobar.example"}
          ]
        }.to_json)

      stub_request(:get, "http://localhost:3000/api/attr_records")
        .with(headers: {accept: 'application/json'})
        .to_return(headers: {content_type: "application/json"}, body: {
          data: [
            {type: 'records', id: '1', name: "foo.example"},
            {type: 'records', id: '2', name: "bar.example"},
            {type: 'records', id: '3', name: "baz.example"}
          ]
        }.to_json)

      expect(test_class.all.all?{|record| record.new_record?}).to eq false
      expect(test_class.all.all?{|record| record.persisted?}).to eq true
      expect(test_class.find(1).first.new_record?).to eq false
      expect(test_class.find(1).first.persisted?).to eq true
    end
  end
end
