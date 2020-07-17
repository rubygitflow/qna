require 'rails_helper'

feature 'The user, being on the question page, can write the answer to the question', %q(
  An authenticated user can write an answer to a question to help solve a problem
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  # js — attach Capybara's browser emulator
  describe 'Authenticated user', js: true do    
  # describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'writes the answer to the question' do
      fill_in 'Answer', with: 'Test answer'
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'writes an answer to a question with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user trying to answer a question' do
    visit question_path(question)
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end