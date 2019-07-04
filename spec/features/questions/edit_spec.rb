feature 'User can edit his question' do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

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
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.questions' do
      expect(page).to_not have_link 'Edit question'
    end
  end
end
