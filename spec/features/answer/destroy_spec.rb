require 'rails_helper'

feature "The author can delete his answer, but can not delete someone else's answer", %(
  To get rid of an unnecessary answer, the author of the answer may delete the answer
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer, user: user, body: 'harmful advice') }
  given(:other_answer) { create(:answer) }

  describe 'Authenticated user tries to delete a question' do
    background { login(user) }

    scenario 'being the author of the question' do
      visit question_path(answer.question)

      within '.answers' do
        expect(page).to have_content 'harmful advice'
        accept_confirm do
          click_on 'Delete answer'
        end
        expect(page).to_not have_content 'harmful advice'
      end
    end

    scenario 'not being the author of the question' do
      visit question_path(other_answer.question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end
end
