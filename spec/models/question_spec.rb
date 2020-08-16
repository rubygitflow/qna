require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }

  it_behaves_like 'votable'

  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should belong_to(:user) }
    it { should have_many(:answers).order('best DESC, created_at').dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_one(:reward).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }

    it { should accept_nested_attributes_for :links }
    it { should accept_nested_attributes_for :reward }

    it 'has many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'Scopes' do
    let(:question) { create(:question) }
    let(:questions) { create_list(:question, 2, created_at: Date.yesterday) }

    it 'is questions for the last day' do
      expect(Question.created_prev_day).to eq questions
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'user creates subscription' do
    let(:question) { build(:question) }

    it 'calls create_subscription' do
      expect(question).to receive(:create_subscription)
      question.save!
    end
    
    it 'is subscribed to question' do
      question.save!
      expect(question.user).to be_subscribed(question)
    end
  end
end
