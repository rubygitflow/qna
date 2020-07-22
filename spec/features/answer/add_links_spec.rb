require 'rails_helper'

feature 'User can add links to answer', %(
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/rubygitflow/62df15d04b4114e75e068c2bb07660e3' }
  given(:google_url) { 'https://www.google.com/' }

  scenario 'User adds links when asks answer', js: true do
    login(user)
    visit question_path(question)

    fill_in "Answer", with: "Test answer"

   click_on 'add link'
    within '.nested-fields:last-of-type' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end
    click_on 'add link'
    within '.nested-fields:last-of-type' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on "Reply"

    within '.answers' do
      expect(page).to have_content 'Gist for debugging the algorithm'
      expect(page).to have_link 'Google', href: google_url
    end
  end
end
