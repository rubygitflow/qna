require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe  '#author?' do
    let(:user) { create(:user) }

    it 'author of own question' do
      expect(user).to be_author(create(:question, user: user))
    end

    it 'not author of another question' do
      expect(user).to_not be_author(create(:question))
    end
  end
end
