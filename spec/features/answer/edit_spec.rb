require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:other_question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user' do
    background { login(user) }

    describe 'edit his answer', js: true do
      background do 
        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_on 'Edit answer'
        end
      end

      describe 'without errors' do
        scenario 'changes fields' do
          # save_and_open_page

          within "#answer-#{answer.id}" do
            fill_in 'answer[body]', with: 'edited answer'

            click_on 'Save'

            expect(page).to_not have_content answer.body
            expect(page).to have_content 'edited answer'
            expect(page).to_not have_selector 'textarea'
          end
        end

        scenario 'attaches files' do
          within "#answer-#{answer.id}" do
            attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            
            click_on 'Save'

            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end
      end 

      scenario 'with some errors' do
        # save_and_open_page
        
        within "#answer-#{answer.id}" do
          fill_in 'answer[body]', with: ''

          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_selector 'textarea'
          expect(page).to have_content "can't be blank"
        end
      end
    end

    scenario "tries to edit other user's answer" do
      visit question_path(other_question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end
