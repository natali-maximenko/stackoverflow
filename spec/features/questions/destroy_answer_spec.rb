feature "Destroy answer", type: :feature do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:other_user) { create(:user) }

  scenario 'Authenticated user destroy the question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body
    click_link 'destroy'

    expect(page).to have_content 'Your answer successfully destroyed.'
    expect(page).not_to have_content answer.body
  end

  scenario 'Non-authenticated user try to destroy answer' do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).not_to have_link 'destroy'
  end

  scenario 'Authenticated user, not owner try destroy the answer' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).not_to have_link 'destroy'
  end
end