RSpec.describe 'Serializer' do
  let(:test_class) do
    SerializerTestClass ||= Class.new do
      include JSONAPI::Consumer::Resource

      has_many :users
      has_one :owner
    end
  end

  let(:owner) {
    Class.new do
      include JSONAPI::Consumer::Resource

      def to_param
        1
      end
    end
  }

  let(:user) {
    Class.new do
      include JSONAPI::Consumer::Resource
    end
  }

  subject(:obj_hash) { test_class.new(id: '76', owner: owner.new, users: [user.new(id: 'a'), user.new(id: 'b')]).serializable_hash }

  it 'outputs the associated has_one' do
    expect(obj_hash).to have_key(:links)
    expect(obj_hash[:links]).to have_key(:owner)
    expect(obj_hash[:links][:owner]).to eql(1)
  end

  it 'outputs the associated has_many' do
    expect(obj_hash).to have_key(:links)
    expect(obj_hash[:links]).to have_key(:users)
    expect(obj_hash[:links][:users]).to eql(['a', 'b'])
  end

end
