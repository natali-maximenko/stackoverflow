feature "Questions list" do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'Authenticated user view questions' do
    sign_in(user)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Questions list'
    questions.each do |q|
      expect(page).to have_content q.title
    end
  end

  scenario 'Non-authenticated user view questions' do
    visit questions_path

    expect(page).to have_content 'Questions list'
    questions.each do |q|
      expect(page).to have_content q.title
    end  
  end
end