feature "Destroy answer", type: :feature do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:other_user) { create(:user) }

  scenario 'Authenticated user destroy the answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body
    click_link 'Destroy Answer'

    expect(page).not_to have_content answer.body
  end

  scenario 'Non-authenticated user try to destroy answer', js: true do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).not_to have_link 'Destroy Answer'
  end

  scenario 'Authenticated user, not owner try destroy the answer', js: true do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).not_to have_link 'Destroy Answer'
  end
end