require 'rails_helper'

feature "The author can delete his answer, but can not delete someone else's answer", %q(
  To get rid of an unnecessary answer, the author of the answer may delete the answer
) do
  given(:user) { create(:user) }
  given(:answer) { create(:answer, body: 'Bad comment') }

  describe 'Authenticated user tries to delete a question' do
    scenario 'being the author of the question' do
      login(answer.user)

      visit question_path(answer.question)
      expect(page).to have_content 'Bad comment'
      click_on 'Delete answer'
      expect(page).to_not have_content 'Bad comment'
      expect(page).to have_content 'Answer was successfully deleted.'
    end

    scenario 'not being the author of the question' do
      login(user)

      visit question_path(answer.question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete answer'
  end
end
