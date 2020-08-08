require 'rails_helper'

feature 'User can delete comments from question' do
  given(:first_user) { create(:user, email: 'first@comments.com') }
  given(:second_user) { create(:user, email: 'second@comments.com') }
  given(:question) { create(:question, user: first_user) }

  given!(:first_comment) { create(:comment, commentable: question, user: first_user, body: 'useful') }
  given!(:second_comment) { create(:comment, commentable: question, user: second_user, body: 'awful') }

  scenario "Unauthenticated user can't delete comments" do
    visit question_path(question)
    within "#question-#{question.id}" do
      expect(page).to_not have_link 'Delete comment'
    end
  end

  describe 'Authenticated user tries to delete a comment', js: true do
    background do 
      login(first_user) 
      visit question_path(question)
    end

    scenario 'being the author of the comment' do
      within "#comment-#{first_comment.id}" do
        expect(page).to have_content 'useful'
        accept_confirm do
          click_on 'Delete comment'
        end
      end
      within "#question-#{question.id}" do
        expect(page).to_not have_content 'useful'
      end
    end

    scenario 'not being the author of the comment' do
      within "#comment-#{second_comment.id}" do
        expect(page).to have_content 'awful'
        expect(page).to_not have_link 'Delete comment'
      end
    end
  end
end
