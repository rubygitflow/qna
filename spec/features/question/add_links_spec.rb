require 'rails_helper'

feature 'User can add links to question' do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/rubygitflow/62df15d04b4114e75e068c2bb07660e3' }
  given(:google_url) { 'https://www.google.com/' }

  scenario 'User adds links when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

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

    click_on 'Ask'

    expect(page).to have_content 'Gist for debugging the algorithm'
    expect(page).to have_link 'Google', href: google_url
  end
end
