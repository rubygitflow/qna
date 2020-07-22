require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'associations' do
  	it { should belong_to :linkable }
  end

  describe 'validations' do
	  it { should validate_presence_of :name }
	  it { should validate_presence_of :url }
    it { should allow_values('http://foo.bar', 'https://foo.bar.com').for(:url) }
  end

  describe '#gist?' do
    let(:link_to_gist) { create(:link, url: 'https://gist.github.com/rubygitflow/62df15d04b4114e75e068c2bb07660e3') }
    let(:link) { create(:link) }

    describe 'gist instead link' do
      it { expect(link_to_gist).to be_gist }
    end
    
    describe 'really link' do
      it { expect(link).to_not be_gist }
    end
  end
end
