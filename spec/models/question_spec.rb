require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it {should validate_presence_of :title}
    it {should validate_presence_of :body}
  end
end
