require 'spec_helper'

describe UserMailer do

  describe "#new_account_notification" do
    let(:user) { FactoryGirl.build(:lender_user, first_name: 'Joe', username: 'joe123') }
    let(:token) { 'jKMpsc7CC_1ABh1rDUBq' }
    let(:mail) { UserMailer.new_account_notification(user, token) }

    it "should be set to be delivered to the user's email address" do
      mail.to.should == [user.email]
    end

    it "should contain user's first name" do
      mail.body.should include('joe')
    end

    it "should contain user's username" do
      mail.body.should include('joe123')
    end

    it "should contain link to reset password page" do
      mail.body.should include("?reset_password_token=#{user.reset_password_token}")
    end

    it "should contain a link back to the home page to resend the request" do
      mail.body.should include(root_url)
    end

    it "should have a from header" do
      Devise.mailer_sender.should match mail.from[0]
    end
  end

end
