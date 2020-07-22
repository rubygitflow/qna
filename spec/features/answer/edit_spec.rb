require 'rails_helper'

feature 'User can edit his answer', %(
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
) do

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
      given(:google_url) { 'https://www.google.com/' }
      given(:gist_url) { 'https://gist.github.com/rubygitflow/62df15d04b4114e75e068c2bb07660e3' }

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

        scenario 'can adds links' do
          within "#answer-#{answer.id}" do
            click_on 'add link'
            within '.nested-fields:last-of-type' do
              fill_in 'Link name', with: 'Google'
              fill_in 'Url', with: google_url
            end
            click_on 'add link'
            within '.nested-fields:last-of-type' do
              fill_in 'Link name', with: 'My gist'
              fill_in 'Url', with: gist_url
            end

            click_on 'Save'

            expect(page).to have_content 'Gist for debugging the algorithm'
            expect(page).to have_link 'Google', href: google_url
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
