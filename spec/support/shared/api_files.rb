shared_examples 'API Fileable' do
  context 'files' do
    it 'returns resource with files' do
      expect(resource_response_with_files.size).to eq 2
    end
  end
end
