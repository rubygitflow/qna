require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  
    it { should accept_nested_attributes_for :links }

    it 'has many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe '#select_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:reward) { create(:reward, question: question) }
    let(:answer) { create(:answer, question: question, user: user) }

    it 'select this answer best' do
      expect(answer).to_not be_best
      answer.select_best!
      expect(answer).to be_best
    end
    
    it 'deselect other answers' do
      best_answer = create(:answer, question: question, best: true)
      answer.select_best!
      best_answer.reload
      expect(best_answer).to_not be_best
    end

    it 'assigns an award from author of the answer' do
      expect(reward.user).to_not eq user
      answer.select_best!
      expect(reward.user).to eq user
    end
  end
end
