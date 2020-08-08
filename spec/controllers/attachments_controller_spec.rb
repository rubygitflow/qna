require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:other_question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author of record' do
      before do
        question.files.attach(create_file_blob) 
        answer.files.attach(create_file_blob)
      end

      it 'deletes the file from a question' do
        expect {
          delete :destroy, params: {id: question.files.first, format: :js}
        }.to change(question.files, :count).by(-1)
      end

      it 'deletes the file from an answer' do
        expect {
          delete :destroy, params: {id: answer.files.first, format: :js}
        }.to change(answer.files, :count).by(-1)
      end


      it 'renders the destroy view by question' do
        delete :destroy, params: {id: question.files.first, format: :js}
        expect(response).to render_template :destroy
      end

      it 'renders the destroy view by answer' do
        delete :destroy, params: {id: answer.files.first, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'not author of record' do
      before do 
        other_question.files.attach(create_file_blob) 
        other_answer.files.attach(create_file_blob)
      end

      it "doesn't delete the question's file" do
        expect {
          delete :destroy, params: {id: other_question.files.first, format: :js}
        }.to_not change(other_question.files, :count)
      end

      it "doesn't delete the answer's file" do
        expect {
          delete :destroy, params: {id: other_answer.files.first, format: :js}
        }.to_not change(other_answer.files, :count)
      end

      it 'returns forbidden status after other question edition' do
        delete :destroy, params: {id: other_question.files.first, format: :js}
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns forbidden status after other answer edition' do
        delete :destroy, params: {id: other_answer.files.first, format: :js}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
