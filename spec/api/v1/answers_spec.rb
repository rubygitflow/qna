require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json',
    }
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:method) { :get }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before do 
        do_request(
          method, api_path, 
          params: { access_token: access_token.token }, 
          headers: headers 
        )
      end

      it_behaves_like 'successful status'

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body question_id best created_at updated_at rating].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user_id
      end

      it 'contains short body' do
        expect(answer_response['short_body']).to eq answer.body.truncate(13)
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:method) { :get }
    let(:answer) { create(:answer, :with_files) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let(:answer_response) { json['answer'] }
      let!(:links) { create_list(:link, 2, linkable: answer) }
      let(:link) { links.first }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }

      before do
        do_request(
          method, api_path,
          params: { access_token: access_token.token },
          headers: headers
        )
      end

      it_behaves_like 'successful status'

      it 'returns all public fields' do
        %w[id question_id body best created_at updated_at rating].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it_behaves_like 'API Fileable' do
        let(:resource_response_with_files) { answer_response['files'] }
      end

      it_behaves_like 'API Linkable' do
        let(:resource_response_with_links) { answer_response['links'] }
      end

      it_behaves_like 'API Commentable' do
        let(:resource_response_with_comments) { answer_response['comments'] }
      end
    end
  end


  describe 'POST /api/v1/questions/:id/answers' do
    let(:method) { :post }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'valid parameters' do
        let(:answer_params) do
          {
            'body' => 'Answer body',
          }
        end

        it 'creates a new answer' do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token, answer: answer_params }.to_json, 
              headers: headers 
            )
          }.to change { user.answers.count }.by(1)
        end

        it 'returns an answer' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, answer: answer_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:created)
          expect(json['answer']).to a_hash_including(answer_params)
        end
      end

      context 'invalid parameters' do
        let(:answer_params) { {'body' => ''} }

        it "does't create a new answer" do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token, answer: answer_params }.to_json, 
              headers: headers 
            )
          }.to_not change { user.answers.count }
        end

        it 'returns an error' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, answer: answer_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let(:method) { :put }
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }
      let(:answer_params) do
        {
          'body' => 'New body',
        }
      end

      context 'author' do
        let(:answer) { create(:answer, user: user) }

        it 'updates the answer' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, answer: answer_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:ok)
          expect(json['answer']).to a_hash_including(answer_params)
        end
      end

      context 'not author' do
        let(:answer) { create(:answer) }

        it 'returns an error' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token, answer: answer_params }.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:forbidden)
          expect(json['errors']).to match('You are not authorized to access this page')
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:method) { :delete }
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:oauth_access_token, resource_owner_id: user.id) }

      context 'author' do
        let!(:answer) { create(:answer, user: user) }

        it 'deletes the answer' do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token}.to_json, 
              headers: headers 
            )
          }.to change { user.answers.count }.by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'not author' do
        let!(:answer) { create(:answer) }

        it "does't delete the answer" do
          expect {
            do_request(
              method, api_path, 
              params: { access_token: access_token.token}.to_json, 
              headers: headers 
            )
          }.to_not change { user.answers.count }
        end

        it 'returns an error' do
          do_request(
            method, api_path, 
            params: { access_token: access_token.token}.to_json, 
            headers: headers 
          )
          expect(response).to have_http_status(:forbidden)
          expect(json['errors']).to match('You are not authorized to access this page')
        end
      end
    end
  end
end
