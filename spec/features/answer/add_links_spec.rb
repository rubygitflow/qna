require 'rails_helper'

feature 'User can add links to answer' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://github.com/rubygitflow/qna/' }

  scenario 'User adds links when asks answer', js: true do
    login(user)
    visit question_path(question)

    fill_in "Answer", with: "Test answer"
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on "Reply"

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
