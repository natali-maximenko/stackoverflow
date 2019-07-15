feature 'User can edit his question' do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticated user edits his question', js: true do
      within '.questions' do
        click_on 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Authenticated user edits his question with invalid attributes', js: true do
      within '.questions' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario 'Authenticated user edits his question with attaching files', js: true do
      within '.questions' do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Authenticated user edits his question with adding link', js: true do
      within '.questions' do
        click_on 'Edit'
        click_on 'Add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_link 'My gist'
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.questions' do
      expect(page).to_not have_link 'Edit question'
    end
  end
end
