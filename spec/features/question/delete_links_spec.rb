require 'rails_helper'

feature 'User can delete links from question', %(
  In order to remove unnecessary links from my question
  As an question's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }
  given!(:link) { create(:link, linkable: question) }
  given!(:other_link) { create(:link, linkable: other_question) }

  scenario "Unauthenticated user can't delete links" do
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated user' do
    background { login(user) }

    scenario "and author can delete links", js: true do
      visit question_path(question)

      within '#question' do
        expect(page).to have_link 'Test link', href: 'http://foo.bar.com'
        accept_confirm do
          click_on 'Delete link'
        end
        # save_and_open_page
        expect(page).to_not have_link 'Test link', href: 'http://foo.bar.com'
      end
    end

    scenario "and not author can't delete links" do
      visit question_path(other_question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end
