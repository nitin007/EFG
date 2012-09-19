require 'spec_helper'

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
    user_audit.function.should == UserAudit::INITIAL_LOGIN
    user_audit.modified_by.should == current_user
    user_audit.password.should == current_user.encrypted_password

    # subsequent login should not create user audit record
    click_link "Logout"
    fill_in "user_username", with: current_user.username
    fill_in "user_password", with: current_user.password

    expect {
      click_button "Sign In"
    }.to_not change(current_user.user_audits, :count)
  end

end
