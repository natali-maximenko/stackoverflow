feature "Destroy question", type: :feature do
  let!(:user) { create(:user) }
  let!(:user_question) { create(:question, user: user) }
  let!(:other_user) { create(:user) }

  background do
    visit questions_path
    expect(page).to have_content user_question.title
  end

  scenario 'Authenticated user destroy the question' do
    sign_in(user)

    expect(page).to have_link 'destroy'
    click_link 'destroy'

    expect(page).to have_content 'Your question successfully destroyed.'
    expect(page).not_to have_content user_question.title
  end

  scenario 'Non-authenticated user try to destroy question' do
    expect(page).not_to have_link 'destroy'
  end

  scenario 'Authenticated user, not owner try destroy the question' do
    sign_in(other_user)

    expect(page).not_to have_link 'destroy'
  end
end
