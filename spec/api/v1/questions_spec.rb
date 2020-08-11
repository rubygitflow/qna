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

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it_behaves_like 'API Fileable' do
        let(:resource_response_with_files) { question_response['files'] }
      end

      it_behaves_like 'API Linkable' do
        let(:resource_response_with_links) { question_response['links'] }
      end

      it_behaves_like 'API Commentable' do
        let(:resource_response_with_comments) { question_response['comments'] }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'valid parameters' do
        let(:question_params) do
          {
            'title' => 'Question title',
            'body' => 'Question body',
          }
        end

        it 'creates a new question' do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token, question: question_params }.to_json, 
              headers: headers 
            )
          }.to change { user.questions.count }.by(1)
        end

        it 'returns a question' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, question: question_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:created)
          expect(json['question']).to a_hash_including(question_params)
        end
      end

      context 'invalid parameters' do
        let(:question_params) { {'title' => 'Question title'} }

        it "does't create a new question" do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token, question: question_params }.to_json, 
              headers: headers 
            )
          }.to_not change { user.questions.count }
        end

        it 'returns an error' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, question: question_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let(:method) { :put }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }
      let(:question_params) do
        {
          'title' => 'New title',
          'body' => 'New body',
        }
      end

      context 'author' do
        let(:question) { create(:question, user: user) }

        it 'updates the question' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, question: question_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:ok)
          expect(json['question']).to a_hash_including(question_params)
        end
      end

      context 'not author' do
        let(:question) { create(:question) }

        it 'returns an error' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, question: question_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:forbidden)
          expect(json['errors']).to match('You are not authorized to access this page')
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:method) { :delete }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'author' do
        let!(:question) { create(:question, user: user) }

        it 'deletes the question' do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token }.to_json, 
              headers: headers 
            )
          }.to change { user.questions.count }.by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'not author' do
        let!(:question) { create(:question) }

        it "does't delete the question" do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token }.to_json, 
              headers: headers 
            )
          }.to_not change { user.questions.count }
        end

        it 'returns an error' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:forbidden)
          expect(json['errors']).to match('You are not authorized to access this page')
        end
      end
    end
  end 
end
