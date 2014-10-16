RSpec.describe 'Connection' do
  let(:test_class) do
    Record ||= Class.new do
      include JSONAPI::Consumer::Resource
      self.host = 'http://oz.dev/api/'

      has_one :domain
    end
  end

  let(:obj) { test_class.new(record_type: 'A', name: 'www3', content: '127.0.0.1', ttl: 64) }

  describe '#save' do
    it 'can save successfully' do
      expect(obj.save).to eql(true)
    end
  end
end
