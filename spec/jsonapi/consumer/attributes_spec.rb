RSpec.describe 'Attributes' do
  let(:test_class) do
    Class.new do
      include JSONAPI::Consumer::Resource
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

  describe '#persisted?' do
    it 'uses the primary key to decide' do
      expect {
        obj.id = '8'
      }.to change{obj.persisted?}.from(false).to(true)
    end
  end
end
