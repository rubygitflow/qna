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

      it 'returns 200`s status' do
        expect(response).to be_successful
      end

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
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:method) { :get }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:oauth_access_token) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let!(:comment) { create(:comment, commentable: question) }

      before do 
        question.files.attach(create_file_blob)
        do_request(
          method, api_path, 
          params: { access_token: access_token.token }, 
          headers: headers 
        )
      end

      it 'returns 200`s status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      describe 'comments' do
        let(:comment_response) { question_response['comments'].first }

        it 'return list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file_response) { question_response['files'].first }

        it 'return list of files' do
          expect(question_response['files'].size).to eq 1
        end
      end

      describe 'links' do
        let(:link_response) { question_response['links'].first }
        let(:link) { links.last }

        it 'return list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end
end
