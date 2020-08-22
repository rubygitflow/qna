require 'sphinx_helper'

feature 'User can search for a question by different params', "
  In order to find the needed question
  As a User
  I'd like to be able to search for the question
" do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer) }
  given!(:user) { create(:user) }

  background { visit root_path  }

  scenario 'in all context', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select 'All', from: 'context'
      click_on 'Search'
      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email

      fill_in 'Search', with: question.title
      click_on 'Search'
      expect(page).to have_content question.title
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'in questions context', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select 'Question', from: 'context'
      fill_in 'Search', with: question.title
      click_on 'Search'
      expect(page).to have_content question.title
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'in answers context', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select 'Answer', from: 'context'
      fill_in 'Search', with: answer.body
      click_on 'Search'
      expect(page).to_not have_content question.title
      expect(page).to have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'in comments context', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select 'Comment', from: 'context'
      fill_in 'Search', with: comment.body
      click_on 'Search'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'in users context', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      select 'User', from: 'context'
      fill_in 'Search', with: user.email
      click_on 'Search'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to have_content user.email
    end
  end

end
