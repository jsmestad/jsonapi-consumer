RSpec.describe 'Associations', 'has_many' do
  let(:user_class) do
    User ||= Class.new do
      include JSONAPI::Consumer::Resource

      has_many :posts
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
      }.to change{user_instance.posts}.from(nil).to(['1'])
    end

    it 'can be added as a list of items' do
      expect {
        user_instance.posts = ['1','2','3']
      }.to change{user_instance.posts}.from(nil).to(['1','2','3'])
    end

    it 'can be blanked out' do
      user_instance.posts = '1'
      expect {
        user_instance.posts = nil
      }.to change{user_instance.posts}.from(['1']).to(nil)
    end

    describe 'links parsing' do
      let(:return_hash) {
        {
          users: [
            {id: '1', username: 'foo', links: {posts: ['a', 'b', 'c']}}
          ]
        }.with_indifferent_access
      }

      subject(:obj) { user_class.parse(OpenStruct.new(status: '200', body: return_hash)).first }

      it 'sets the association' do
        expect(obj.posts).to eql(['a','b','c'])
      end
    end
  end

  describe 'the links payload' do
    subject(:payload_hash) { user_instance.serializable_hash }

    it 'has links in output' do
      expect(payload_hash).to have_key(:links)
    end
  end
end

RSpec.describe 'Associations', 'belongs_to' do
  let(:comment_class) do
    Comment ||= Class.new do
      include JSONAPI::Consumer::Resource

      belongs_to :comment
      belongs_to :user
    end
  end

  subject(:comment_instance) { comment_class.new }

  it 'lists association names in #association_names' do
    expect(comment_instance.association_names).to eql([:comment, :user])
  end

  describe 'defined accessors for assocation' do
    it { is_expected.to respond_to(:comment) }
    it { is_expected.to respond_to(:comment=) }
  end

  describe 'adding objects to belongs_to relationship' do
    it 'can be added as a single value' do
      expect {
        comment_instance.comment = '1'
      }.to change{comment_instance.comment}.from(nil).to('1')
    end

    it 'can be blanked out' do
      comment_instance.comment = '1'
      expect {
        comment_instance.comment = nil
      }.to change{comment_instance.comment}.from('1').to(nil)
    end
  end
end

RSpec.describe 'Associations', 'has_one' do
  let(:post_class) do
    Post ||= Class.new do
      include JSONAPI::Consumer::Resource

      has_one :author
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
      }.to change{post_instance.author}.from(nil).to('1')
    end

    it 'can be blanked out' do
      post_instance.author = '1'
      expect {
        post_instance.author = nil
      }.to change{post_instance.author}.from('1').to(nil)
    end
  end

  describe 'links parsing' do
    let(:return_hash) {
      {
        posts: [
          {id: '1', title: 'foobarbaz', links: {author: 'asdf'}}
        ]
      }.with_indifferent_access
    }

    subject(:obj) { post_class.parse(OpenStruct.new(status: '200', body: return_hash)).first }

    it 'sets the association' do
      expect(obj.author).to eql('asdf')
    end
  end
end

