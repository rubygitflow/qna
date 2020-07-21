require 'rails_helper'

feature 'Author of answer can delete attached files' do
  given(:first_user) { create(:user, email: 'first@example.com') }
  given(:second_user) { create(:user, email: 'second@example.com') }
  given(:question) { create(:question, user: second_user) }
  given(:first_answer) { create(:answer, question: question, user: first_user) }
  given(:second_answer) { create(:answer, question: question, user: second_user) }

  background do 
    login(first_user) 
    visit question_path(first_answer.question)
    first_answer.files.attach(create_file_blob) 
    click_on 'Log out'

    login(second_user) 
    visit question_path(second_answer.question)
    second_answer.files.attach(create_file_blob(filename: 'example2.jpg')) 
    click_on 'Log out'
  end

  describe 'Authenticated user' do
    background do 
      login(second_user) 
      visit question_path(second_answer.question)
    end

    scenario 'deletes file from answer', js: true do
      within "#answer-#{second_answer.id}" do
        expect(page).to have_content 'example2.jpg'
        accept_confirm do
          click_on 'Delete file'
        end
        expect(page).to_not have_content 'example.jpg'
      end
    end

    scenario "tries to delete file from other user's answer", js: true do
      within "#answer-#{first_answer.id}" do
        # save_and_open_page
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  scenario "Unauthenticated user can't delete attached files" do
    visit question_path(first_answer.question)
    within '.answers' do
      expect(page).to_not have_link 'Delete file'
    end
  end
end
