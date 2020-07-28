require 'rails_helper'

feature 'Author of question can delete attached files' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'deletes file from question', js: true do
      question.files.attach(create_file_blob)
      visit question_path(question)

      within "#question-#{question.id}" do
        expect(page).to have_content 'example1.jpg'
        accept_confirm do
          click_on 'Delete file'
        end
        expect(page).to_not have_content 'example1.jpg'
      end
    end

    scenario "tries to delete file from other user's question" do
      other_question.files.attach(create_file_blob)
      visit question_path(other_question)

      within "#question-#{other_question.id}" do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  scenario "Unauthenticated user can't delete attached files" do
    visit question_path(question)
    within "#question-#{question.id}" do
      expect(page).to_not have_link 'Delete file'
    end
  end
end
