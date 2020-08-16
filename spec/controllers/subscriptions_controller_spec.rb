require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    context 'not subscribed' do
      it 'subscribes to the question' do
        expect {
          post :create, params: {question_id: question, format: :js}
        }.to change(user.subscriptions, :count).by(1)
      end
      it 'renders create view' do
        post :create, params: {question_id: question, format: :js}
        expect(response).to render_template :create
      end
    end

    context 'already subscribed' do
      let!(:subscription) { create(:subscription, user: user, question: question) }

      it "doesn't subscribe twice" do
        expect {
          post :create, params: {question_id: question, format: :js}
        }.to_not change(user.subscriptions, :count)
      end
      it 'renders create view' do
        post :create, params: {question_id: question, format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    before { login(user) }

    it 'unsubscribes from the question' do
      expect {
        delete :destroy, params: {id: question, format: :js}
      }.to change(user.subscriptions, :count).by(-1)
    end
    it 'renders unsubscribe view' do
      delete :destroy, params: {id: question, format: :js}
      expect(response).to render_template :destroy
    end
  end
end
