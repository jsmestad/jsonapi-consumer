RSpec.describe 'Associations', 'has_many' do
  let(:user_class) do
    User ||= Class.new do
      include JSONAPI::Consumer::Resource

      has_many :posts, class_name: 'Post'
    end
  end

  let!(:post_class) do
    Post ||= Class.new do
      include JSONAPI::Consumer::Resource
    end
  end

  subject(:user_instance) { user_class.new(username: 'foobar') }

  it 'lists association names in #association_names' do
    expect(user_instance.association_names).to eql([:posts])
  end

  describe 'defined accessors for assocation' do
    it { is_expected.to respond_to(:posts) }
    it { is_expected.to respond_to(:posts=) }
  end

  describe 'adding objects to array' do
    it 'can be added as a single value' do
      expect {
        user_instance.posts = '1'
      }.to change{user_instance.post_ids}.from(nil).to(['1'])
    end

    it 'can be added as a list of items' do
      expect {
        user_instance.posts = ['1','2','3']
      }.to change{user_instance.post_ids}.from(nil).to(['1','2','3'])
    end

    it 'can be blanked out' do
      user_instance.posts = '1'
      expect {
        user_instance.posts = nil
      }.to change{user_instance.post_ids}.from(['1']).to(nil)
    end
  end

  describe 'the links payload' do
    subject(:payload_hash) { user_instance.serializable_hash }

    describe 'when populated' do
      before do
        user_instance.posts = ['1']
      end

      it 'has links in output, if present' do
        expect(payload_hash).to have_key(:links)
        expect(payload_hash[:links]).to have_key(:posts)
        expect(payload_hash[:links][:posts]).to eql(["1"])
      end
    end

    describe 'when empty' do
      it 'has no links in output' do
        expect(payload_hash).to_not have_key(:links)
      end
    end
  end
end

RSpec.describe 'Associations', 'belongs_to' do
  let(:comment_class) do
    Comment ||= Class.new do
      include JSONAPI::Consumer::Resource

      # belongs_to :comment, class_name: 'Comment'
      belongs_to :user, class_name: 'User'
    end
  end

  let!(:user_class) do
    User ||= Class.new do
      include JSONAPI::Consumer::Resource
    end
  end

  subject(:comment_instance) { comment_class.new }

  it 'lists association names in #association_names' do
    expect(comment_instance.association_names).to eql([:user])
  end

  describe 'defined accessors for assocation' do
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:user=) }
  end

  describe 'adding objects to belongs_to relationship' do
    it 'can be added as a single value' do
      expect {
        comment_instance.user = '1'
      }.to change{comment_instance.user_id}.from(nil).to('1')
    end

    it 'can be blanked out' do
      comment_instance.user = '1'
      expect {
        comment_instance.user = nil
      }.to change{comment_instance.user_id}.from('1').to(nil)
    end
  end
end

RSpec.describe 'Associations', 'has_one' do
  let(:post_class) do
    Poster ||= Class.new do
      include JSONAPI::Consumer::Resource

      has_one :author, class_name: 'Customer'
    end
  end

  let!(:user_class) do
    Customer ||= Class.new do
      include JSONAPI::Consumer::Resource
    end
  end

  subject(:post_instance) { post_class.new }

  it 'lists association names in #association_names' do
    expect(post_instance.association_names).to eql([:author])
  end

  describe 'defined accessors for assocation' do
    it { is_expected.to respond_to(:author) }
    it { is_expected.to respond_to(:author=) }
  end

  describe 'adding objects to belongs_to relationship' do
    it 'can be added as a single value' do
      expect {
        post_instance.author = '1'
      }.to change{post_instance.author_id}.from(nil).to('1')
    end

    it 'can be blanked out' do
      post_instance.author = '1'
      expect {
        post_instance.author = nil
      }.to change{post_instance.author_id}.from('1').to(nil)
    end
  end
end

