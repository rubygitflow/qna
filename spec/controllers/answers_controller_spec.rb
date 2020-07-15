require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: {question_id: question} }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: {id: answer} }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'authenticated user to be author of answer' do
        post :create, params: {question_id: answer.question, answer: attributes_for(:answer)}
        expect(user).to be_author(assigns(:answer))
      end

      it 'redirects to show view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      # it only works after "trait :invalid do"
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)} }

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'author' do
      before { login(answer.user) }

      it 'delete the answer' do
        expect { delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
      end
      it 'redirects to index' do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to answer.question
      end
    end

    context 'not author' do
      before { login(user) }

      it 'no delete the answer' do
        expect { delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
      end
      it 'redirects to index' do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to answer.question
      end
    end
  end
end
