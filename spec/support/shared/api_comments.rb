shared_examples 'API Commentable' do
  context 'comments' do
    let(:comment_response) { resource_response_with_comments.first }

    it 'returns resource with comments' do
      expect(resource_response_with_comments.size).to eq 3
    end

    it 'returns all public fields of resource comment' do
      %w[id body user_id created_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
