RSpec.describe 'Resource' do
  let(:sample_attrs) {
    {
      id: SecureRandom.uuid,
      name: 'foo',
      content: 'bar'
    }
  }

  subject(:test_class) do
    Record ||= Class.new do
      include JSONAPI::Consumer::Resource
    end
  end

  describe 'accepts any passed in params through #attributes=' do
    subject(:instance) { test_class.new }

    before do
      instance.attributes = sample_attrs
    end

    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:content) }
  end

  describe 'accepts attributes through .new' do
    subject(:instance) { test_class.new(sample_attrs) }

    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:content) }
  end

  describe '#serializable_hash' do
    subject(:obj_hash) { test_class.new(sample_attrs).serializable_hash }

    it 'has proper keys' do
      expect(obj_hash).to have_key(:id)
      expect(obj_hash).to have_key(:name)
      expect(obj_hash).to have_key(:content)
    end
  end

  describe '#to_json' do
    subject(:obj_hash) { test_class.new(sample_attrs).to_json }

    it 'has a root key' do
      json_hash = JSON.parse(obj_hash)
      expect(json_hash.keys).to eql(['record'])
    end
  end

end
