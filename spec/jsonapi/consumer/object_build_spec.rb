RSpec.describe 'Object building' do
  let(:class_name) { BuildRequest }

  subject(:obj) { class_name.build }

  it 'returns an object with populated items' do
    stub_request(:get, "http://localhost:3000/api/build_requests/new")
      .to_return(headers: {content_type: "application/json"}, body: {
        data: [
            {type: 'build_requests', name: "", title: "default value"}
          ]
        }.to_json)

    expect(obj).to respond_to(:name)
    expect(obj).to respond_to(:title)

    expect(obj.name).to be_blank
    expect(obj.title).to eql("default value")
  end
end
