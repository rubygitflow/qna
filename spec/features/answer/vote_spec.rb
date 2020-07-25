require 'rails_helper'

feature 'User can vote for the answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, user: user) }

  scenario "Unauthenticated user can't vote" do
    visit question_path(question)
    expect(page).to_not have_link 'Up!'
    expect(page).to_not have_link 'Down!'
  end

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'can vote up for the answer he likes', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Up!'
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down!'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'can vote down for the answer he dislikes', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Down!'
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down!'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'can cancel his vote', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Up!'
        expect(page).to_not have_link 'Up!'
        expect(page).to have_content 'Rating: 1'
        click_on 'Cancel vote'
        expect(page).to have_link 'Up!'
        expect(page).to have_content 'Rating: 0'
      end
    end

    scenario 'tries to vote for his answer' do
      within "#answer-#{user_answer.id}" do
        # save_and_open_page
        expect(page).to_not have_link 'Up!'
        expect(page).to_not have_link 'Down!'
      end
    end
  end
end
