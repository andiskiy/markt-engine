shared_examples 'render partial js' do |partial|
  it 'render partial when format js' do
    http_request_js
    expect(response).to render_template(partial: partial, layout: false)
  end
end

shared_examples 'sets status json' do |status|
  it 'sets status when format json' do
    http_request_json
    expect(JSON.parse(response.body)['status']).to eq(status)
  end
end
