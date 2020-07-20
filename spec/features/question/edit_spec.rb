require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    background { login(user) }

    describe 'edit his question', js: true do
      background do 
        visit question_path(question) 
        # save_and_open_page
        click_on 'Edit question'
      end

      describe 'without errors' do
        scenario 'changes fields' do
          within "#question" do
            fill_in 'question[title]', with: 'edited question'
            fill_in 'question[body]', with: 'edited explanation'

            click_on 'Save'

            expect(page).to_not have_content question.title
            expect(page).to_not have_content question.body
            expect(page).to have_content 'edited question'
            expect(page).to have_content 'edited explanation'
            expect(page).to_not have_selector 'textarea'
          end
        end

        scenario 'attaches files' do
          within '#question' do
            attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            click_on 'Save'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end
      end

      scenario 'with some errors' do
        
        within "#question" do
          fill_in 'question[title]', with: ''
          fill_in 'question[body]', with: ''

          click_on 'Save'

          expect(page).to have_content question.title
          expect(page).to have_content question.body
          expect(page).to have_content "can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end
    end

    scenario "tries to edit other user's question" do
      visit question_path(other_question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
