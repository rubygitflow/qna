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
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'authenticated user to be author of answer' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer), format: :js }
        expect(user).to be_author(assigns(:answer))
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      # it only works after "trait :invalid do"
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: {body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :update
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
