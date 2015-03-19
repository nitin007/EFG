require 'spec_helper'

describe UsernamesReminder do
  let(:usernames_reminder) { UsernamesReminder.new(email: 'me@example.com') }

  describe 'validations' do
    before { expect(usernames_reminder).to be_valid }

    it 'requires an email address' do
      usernames_reminder.email = nil
      expect(usernames_reminder).to_not be_valid
    end

    it 'validates email address' do
      usernames_reminder.email = 'slkfdlk;'
      expect(usernames_reminder).to_not be_valid
    end
  end

  describe '#send_email' do
    before do
      FactoryGirl.create(:lender_admin, username: 'user1', email: 'not_me@example.com')
    end

    context 'when the email address has associated usernames' do
      before do
        FactoryGirl.create(:lender_admin, username: 'user2', email: usernames_reminder.email)
        FactoryGirl.create(:lender_user,  username: 'user3', email: usernames_reminder.email)
        FactoryGirl.create(:lender_user,  username: 'disableduser4', disabled: true, email: usernames_reminder.email)
      end

      it 'calls UsernamesReminderMailer#usernames_reminder with the correct arguments' do
        expect(UsernamesReminderMailer).to receive(:usernames_reminder)
                               .with('me@example.com', %w(user2 user3))
                               .once
                               .and_return(double("mailer", deliver: true))

        usernames_reminder.send_email
      end
    end

    context 'when the email address has no associated usernames' do
      it 'does not call UsernamesReminderMailer#usernames_reminder' do
        expect(UsernamesReminderMailer).not_to receive(:usernames_reminder)
        usernames_reminder.send_email
      end
    end

    context 'when the email address is only associated with disabled users' do
      before do
        FactoryGirl.create(:lender_admin, username: 'disableduser2', disabled: true, email: usernames_reminder.email)
        FactoryGirl.create(:lender_user,  username: 'disableduser3', disabled: true, email: usernames_reminder.email)
      end

      it 'does not call UsernamesReminderMailer#usernames_reminder' do
        expect(UsernamesReminderMailer).not_to receive(:usernames_reminder)
        usernames_reminder.send_email
      end
    end
  end
end
