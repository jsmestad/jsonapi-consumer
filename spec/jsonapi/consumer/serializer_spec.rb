RSpec.describe 'Serializer' do
  let(:test_class) do
    SerializerTestClass ||= Class.new do
      include JSONAPI::Consumer::Resource

      has_many :users, class_name: 'Account'
      has_one :owner, class_name: 'Owner'
    end
  end

  let(:owner) {
    Owner ||= Class.new do
      include JSONAPI::Consumer::Resource

      def to_param
        1
      end
    end
  }

  let(:user) {
    Account ||= Class.new do
      include JSONAPI::Consumer::Resource
    end
  }

  subject(:obj_hash) { test_class.new(id: '76', owner: owner.new, users: [user.new(id: 'a'), user.new(id: 'b')]).serializable_hash }

  it 'outputs the associated has_one' do
    expect(obj_hash).to have_key(:links)
    expect(obj_hash[:links].keys).to match_array([:owner, :users])
    expect(obj_hash[:links][:owner]).to eql({id: 1, type: 'owners'})
  end

  it 'establishes the proper `type` value' do
    expect(obj_hash).to have_key(:type)
    expect(obj_hash[:type]).to eql(test_class.json_key)
  end

  it 'outputs the associated has_many' do
    expect(obj_hash).to have_key(:links)
    expect(obj_hash[:links].keys).to match_array([:users, :owner])
    expect(obj_hash[:links][:users]).to match_array([{id: 'a', type: 'accounts'}, {id: 'b', type: 'accounts'}])
  end

end
