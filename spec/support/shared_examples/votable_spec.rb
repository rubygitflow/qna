require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }

  describe '#rating' do
    it 'return rating value' do
      votable.create_positive_vote(create(:user))
      votable.create_positive_vote(create(:user))
      votable.create_negative_vote(create(:user))
      votable.create_positive_vote(create(:user))
      votable.create_negative_vote(create(:user))
      expect(votable.rating).to eq 1
    end
  end

  describe '#create_positive_vote' do
    it 'create positive vote' do
      expect {
        votable.create_positive_vote(user)
      }.to change(votable.votes.positive, :count).by(1)
    end
  end

  describe '#create_negative_vote' do
    it 'create negative vote' do
      expect {
        votable.create_negative_vote(user)
      }.to change(votable.votes.negative, :count).by(1)
    end
  end
end
