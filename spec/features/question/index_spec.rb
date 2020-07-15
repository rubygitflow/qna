require 'rails_helper'

feature 'User can view a list of questions', %q(
  To find his questions, any user can view a list of all questions
) do
  given!(:questions) { create_list(:question, 2) }

  scenario 'User is viewing a list of questions' do
    visit questions_path

    expect(page).to have_content 'Questions list'
    questions.each { |question| expect(page).to have_content question.title }
  end
end
