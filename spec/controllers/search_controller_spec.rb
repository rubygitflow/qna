require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:service) { double('Services::Search') }

  describe 'GET #index' do
    it 'calls Search#call' do
      expect(Search).to receive(:new).with('All', '').and_return(service)
      expect(service).to receive(:call)
      get :index, params: {q: '', context: 'All'}
    end

    it 'renders template index' do
      allow(Search).to receive(:new).and_return(service)
      allow(service).to receive(:call)
      get :index, params: {q: '', context: 'All'}
      expect(response).to render_template :index
    end
  end
end
