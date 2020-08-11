shared_examples_for 'successful status' do
  it 'returns 200`s status' do
    expect(response).to be_successful
  end
end
