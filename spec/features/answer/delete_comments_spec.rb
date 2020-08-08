require 'rails_helper'

feature 'User can delete comments from answer' do
  given(:first_user) { create(:user, email: 'first@comments.com') }
  given(:second_user) { create(:user, email: 'second@comments.com') }
  given(:question) { create(:question, user: first_user) }
  given(:answer) { create(:answer, question: question, user: second_user) }  

  given!(:first_comment) { create(:comment, commentable: answer, user: first_user, body: 'useful') }
  given!(:second_comment) { create(:comment, commentable: answer, user: second_user, body: 'awful') }

  scenario "Unauthenticated user can't delete comments" do
    visit question_path(answer.question)
    within "#answer-#{answer.id}" do
      expect(page).to_not have_link 'Delete comment'
    end
  end

  describe 'Authenticated user tries to delete a comment', js: true do
    background do 
      login(second_user) 
      visit question_path(answer.question)
    end

    scenario 'being the author of the comment' do
      within "#comment-#{second_comment.id}" do
        expect(page).to have_content 'awful'
        # save_and_open_page
        accept_confirm do
          click_on 'Delete comment'
        end
      end
      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'awful'
      end
    end

    scenario 'not being the author of the comment' do
      within "#comment-#{first_comment.id}" do
        expect(page).to have_content 'useful'
        expect(page).to_not have_link 'Delete comment'
      end
    end
  end
end
