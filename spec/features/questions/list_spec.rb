feature "Questions list" do
  let!(:user) { create(:user) }
  let(:titles) { ['First question', 'Second question', 'Third question'] }
  let!(:questions) { create_list(:question, 3, user: user) }

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