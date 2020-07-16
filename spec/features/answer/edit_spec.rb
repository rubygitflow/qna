require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated can not edit answer' do
    # visit question_path(question)

    # expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer'  do  # , js: true
      # sign_in user
      # visit question_path(question)

      # click_on 'Edit'


      # within '.answers' do
      #   fill_in 'Your answer', with: 'edited answer'
      #   click_on 'Save'

      #   expect(page).to_not have_content answer.body
      #   expect(page).to have_content 'edited answer'
      #   expect(page).to_not have_selector 'textarea'
      # end
    end

    scenario 'edits his answer with errors' do # , js: true
    end

    scenario "tries to edit other user's question" do # , js: true
    end

  end
end