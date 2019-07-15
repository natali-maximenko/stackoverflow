feature 'User can add links to question' do
  given!(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds links when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'
    
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User try add invalid links when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'
    
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'yandex.ru'
    
    click_on 'Ask'

    expect(page).to have_content 'yandex.ru is not a valid url'
  end
end 
