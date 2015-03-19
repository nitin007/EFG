require 'rails_helper'

describe 'disabled user' do

  let(:current_user) { FactoryGirl.create(:lender_user) }

  it 'redirects all request when disabled mid-session' do
    login_as(current_user, scope: :user)

    visit root_path

    # disable user
    current_user.disabled = true
    current_user.save!

    click_link 'New Loan Application'
    expect(page).to have_content('Your account has been disabled')

    # navigation should not be present
    expect(page).not_to have_content('Search')

    # ensure user can logout
    click_link 'Logout'
    expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
  end

  it 'when logging in' do
    current_user.disabled = true
    current_user.save

    visit root_path
    fill_in 'user_username', with: current_user.username
    fill_in 'user_password', with: current_user.password
    click_button 'Sign In'

    expect(page).to have_content('Your account has been disabled')
  end

end
