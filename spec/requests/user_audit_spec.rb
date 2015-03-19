require 'rails_helper'

describe "User audit" do

  let(:current_user) { FactoryGirl.create(:lender_user) }

  it "should create new audit record when user first signs in" do
    visit root_path

    fill_in "user_username", with: current_user.username
    fill_in "user_password", with: current_user.password

    expect {
      click_button "Sign In"
    }.to change(current_user.user_audits, :count).by(1)

    current_user.reload
    user_audit = current_user.user_audits.last
    expect(user_audit.function).to eq(UserAudit::INITIAL_LOGIN)
    expect(user_audit.modified_by).to eq(current_user)
    expect(user_audit.password).to eq(current_user.encrypted_password)

    # subsequent login should not create user audit record
    click_link "Logout"
    fill_in "user_username", with: current_user.username
    fill_in "user_password", with: current_user.password

    expect {
      click_button "Sign In"
    }.to_not change(current_user.user_audits, :count)
  end

  it "should create new audit record when user changes their password" do
    current_user = FactoryGirl.create(:lender_user)
    login_as(current_user, scope: :user)

    visit edit_change_password_path
    click_link 'Change Password'

    new_password = 'new-password-W1bbL3'
    fill_in "lender_user_password", with: new_password
    fill_in "lender_user_password_confirmation", with: new_password

    expect {
      click_button 'Update Password'
    }.to change(current_user.user_audits, :count).by(1)

    current_user.reload
    user_audit = current_user.user_audits.last
    expect(user_audit.function).to eq(UserAudit::PASSWORD_CHANGED)
    expect(user_audit.modified_by).to eq(current_user)
    expect(user_audit.password).to eq(current_user.encrypted_password)
  end

  it "should create new audit record when user first sets their password" do
    raw_reset_password_token, encrypted_reset_password_token = Devise.token_generator.generate(User, :reset_password_token)

    current_user = FactoryGirl.create(
      :lender_user,
      encrypted_password: nil,
      reset_password_token: encrypted_reset_password_token,
      reset_password_sent_at: 1.minute.ago
    )

    strong_password = 'defADSFAEWRE23402398423%'

    visit edit_user_password_path(current_user, reset_password_token: raw_reset_password_token)
    fill_in "user_password", with: strong_password
    fill_in "user_password_confirmation", with: strong_password

    expect {
      click_button 'Change Password'
    }.to change(current_user.user_audits, :count).by(1)

    current_user.reload
    user_audit2 = current_user.user_audits.last
    expect(user_audit2.function).to eq(UserAudit::INITIAL_LOGIN)
    expect(user_audit2.modified_by).to eq(current_user)
    expect(user_audit2.password).to eq(current_user.encrypted_password)

    # resetting password again should not create user audit record

    click_link "Logout"

    raw_reset_password_token, encrypted_reset_password_token = Devise.token_generator.generate(User, :reset_password_token)
    current_user.reset_password_token = encrypted_reset_password_token
    current_user.reset_password_sent_at = 1.minute.ago
    current_user.save

    visit edit_user_password_path(current_user, reset_password_token: raw_reset_password_token)
    new_password = 'new-password-W1bbL3'
    fill_in "user_password", with: new_password
    fill_in "user_password_confirmation", with: new_password

    expect {
      click_button 'Change Password'
    }.to_not change(current_user.user_audits, :count)
  end

end
