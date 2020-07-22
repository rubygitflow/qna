require 'rails_helper'

feature 'The user, being on the question page, can write the answer to the question', %q(
  An authenticated user can write an answer to a question to help solve a problem
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  # js — attach Capybara's browser emulator
  describe 'Authenticated user', js: true do    
  # describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    describe 'create an answer with valid fields' do
      background do
        fill_in 'Your answer', with: 'Test answer'
      end

      scenario 'writes the answer to the question' do
        click_on 'Reply'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Test answer'
        end
      end

      scenario 'attaches files' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Reply'

        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'writes an answer to a question with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user trying to answer a question' do
    visit question_path(question)
    
    # save_and_open_page
    expect(page).to_not have_button 'Reply'
  end
end
