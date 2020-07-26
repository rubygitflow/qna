require 'rails_helper'

shared_examples_for 'voted' do
  before { login(user) }

  let(:model) { described_class.name.gsub("Controller", "").singularize.constantize }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:user_votable) { create(model.to_s.underscore.to_sym, user: user) }

  describe 'POST #up' do
    context 'author' do
      it 'not create vote' do
        expect {
          post :up, params: {id: user_votable}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create positive vote' do
        expect {
          post :up, params: {id: votable}
        }.to change(votable.votes.positive, :count).by(1)
      end
    end
  end

  describe 'POST #down' do
    context 'author' do
      it 'not create vote' do
        expect {
          post :down, params: {id: user_votable}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create negative vote' do
        expect {
          post :down, params: {id: votable}
        }.to change(votable.votes.negative, :count).by(1)
      end
    end
  end

  describe 'POST #cancel_vote' do
    before { votable.create_negative_vote(user) }

    it 'delete vote' do
      expect {
        post :cancel_vote, params: {id: votable}
      }.to change(votable.votes.negative, :count).by(-1)
    end
  end
end
