require 'rails_helper'

RSpec.describe Search do
  context 'search by all models' do
    it 'calls ThinkingSphinx.search' do
      expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape('search_query'))
      Search.new('All', 'search_query').call
    end
  end

  context 'search by model' do
    it 'calls Question.search' do
      expect(Question).to receive(:search).with(ThinkingSphinx::Query.escape('search_query'))
      Search.new('Question', 'search_query').call
    end
  end
end
