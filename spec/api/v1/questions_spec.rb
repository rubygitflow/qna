require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
    }
  end

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'
    
    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do 
        do_request(
          method, api_path, 
          params: { access_token: access_token.token }, 
          headers: headers 
        )
      end

      it_behaves_like 'successful status'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(13)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body best created_at updated_at rating].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:method) { :get }
    let(:question) { create(:question, :with_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let(:question_response) { json['question'] }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:link) { links.first }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:comment) { create(:comment, commentable: question) }

      before do 
        do_request(
          method, api_path, 
          params: { access_token: access_token.token }, 
          headers: headers 
        )
      end

      it_behaves_like 'successful status'

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      # describe 'files' do
      #   it 'return list of files' do
      #     expect(question_response['files'].size).to eq 1
      #   end
      # end

      it_behaves_like 'API Fileable' do
        let(:resource_response_with_files) { question_response['files'] }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      # describe 'links' do
      #   let(:link_response) { question_response['links'].first }
      #   let(:link) { links.last }

      #   it 'return list of links' do
      #     expect(question_response['links'].size).to eq 2
      #   end

      #   it 'returns all public fields' do
      #     %w[id name url].each do |attr|
      #       expect(link_response[attr]).to eq link.send(attr).as_json
      #     end
      #   end
      # end
      it_behaves_like 'API Linkable' do
        let(:resource_response_with_links) { question_response['links'] }
      end

      # describe 'comments' do
      #   let(:comment_response) { question_response['comments'].first }

      #   it 'return list of comments' do
      #     expect(question_response['comments'].size).to eq 3
      #   end

      #   it 'returns all public fields' do
      #     %w[id body user_id created_at].each do |attr|
      #       expect(comment_response[attr]).to eq comment.send(attr).as_json
      #     end
      #   end
      # end

      it_behaves_like 'API Commentable' do
        let(:resource_response_with_comments) { question_response['comments'] }
      end
    end
  end
end
