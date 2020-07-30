require 'rails_helper'

feature 'User can create a question', %(
  In order to receive a response from the community, 
  an authenticated user may ask a question
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'create a question with valid fields' do
      background do
        # save_and_open_page
        fill_in 'Topic of the question', with: 'Test question'
        fill_in 'Your question', with: 'text text text'
      end

      scenario 'asks a question' do
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      scenario 'asks a question with attached files' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'assigns an award for the best answer' do
        fill_in 'Reward title', with: 'Test reward'
        attach_file 'Reward file', "#{Rails.root}/spec/fixtures/files/1579489.png"
        click_on 'Ask'

        expect(page).to have_content 'Test reward'
        expect(page).to have_link '1579489.png'
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user trying to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario "question appears on another user's page", js: true do
    Capybara.using_session('user') do
      login(user)
      visit questions_path
    end

    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'

      fill_in 'Topic of the question', with: 'Test question'
      fill_in 'Your question', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test question'
    end
  end
end
