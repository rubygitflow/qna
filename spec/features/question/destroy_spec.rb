require 'rails_helper'

feature 'Автор может удалить свой вопрос, но не может удалить чужой вопрос', %q(
  Чтобы избавиться от ненужного вопроса
  Автор вопроса может удалить вопрос
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, title: 'Bad question') }

  describe 'Аутентифицированный пользователь пытается удалить вопрос' do
    scenario 'являясь автором вопроса' do
      login(question.user)
      visit question_path(question)
      expect(page).to have_content 'Bad question'
      click_on 'Delete'
      expect(page).to_not have_content 'Bad question'

      expect(page).to have_content 'Question was successfully deleted.'
    end

    scenario 'не являясь автором вопроса' do
      login(user)
      visit question_path(question)
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Не аутентифицированный пользователь пытается удалить вопрос' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end
