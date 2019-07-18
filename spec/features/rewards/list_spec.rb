feature 'Authenticated user can see rewards list' do
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_reward, user: user) }
  given!(:user_rewards) { create_list(:reward, 3, user: user) }

  background do
    visit new_user_session_path
    sign_in(user)
  end

  scenario 'User see rewards list' do
    visit rewards_path

    user_rewards.each do |reward|
      expect(page).to have_content reward.name
      expect(page).to have_content reward.question.title
    end
  end
end
