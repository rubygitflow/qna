require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
   end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end


  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe  '#author?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:user_question) { create(:question, user: user) }


    it 'author of own question' do
      expect(user).to be_author(user_question)
    end

    it 'not author of another question' do
      expect(user).to_not be_author(question)
    end
  end
  
  describe '#subscribed?' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'returns true if has subscription to question' do
      subscription = create(:subscription, user: user, question: question)
      expect(user).to be_subscribed(question)
    end
    it "returns false if has't subscription to question" do
      expect(user).to_not be_subscribed(question)
    end
  end
end
