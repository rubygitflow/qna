require 'rails_helper'

feature "The author can delete their own question, but they can't delete someone else's question", %(
  To get rid of an unnecessary question the question Author can delete the question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, title: 'Bad question') }

  describe 'The authenticated user tries to delete the question' do
    scenario 'being the author of the question' do
      login(question.user)

      visit question_path(question)
      expect(page).to have_content 'Bad question'
      
      click_on 'Delete question'
      expect(page).to_not have_content 'Bad question'

      expect(page).to have_content 'Question was successfully deleted.'
    end

    scenario 'without being the author of the question' do
      login(user)
      visit question_path(question)
      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end
