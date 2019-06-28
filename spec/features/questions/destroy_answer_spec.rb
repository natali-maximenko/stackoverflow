feature "Destroy answer", type: :feature do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let!(:other_user) { create(:user) }

  scenario 'Authenticated user destroy the question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to have_link 'destroy'
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