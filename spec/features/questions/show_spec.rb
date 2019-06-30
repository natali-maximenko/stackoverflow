feature "Show question with answers", type: :feature do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, user: user, question: question) }
  given!(:other_user) { create(:user) }

  scenario 'Authenticated user view question with answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      answers.each do |a|
        expect(page).to have_content a.body
      end
  end

  scenario 'Non-authenticated user view question with answer' do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      answers.each do |a|
        expect(page).to have_content a.body
      end
  end

  scenario 'Authenticated user not owner view question with answer' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      answers.each do |a|
        expect(page).to have_content a.body
      end
  end
end