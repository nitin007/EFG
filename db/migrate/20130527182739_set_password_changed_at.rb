class SetPasswordChangedAt < ActiveRecord::Migration

  def up
    if !SystemUser.first
      system_user = SystemUser.new(:first_name => "system",
                                   :last_name => "system",
                                   :email => "system@example.com")
      system_user.username = "system-20130527182739"
      system_user.save!
    end

    modifier = SystemUser.first

    [AuditorUser,
     CfeAdmin,
     CfeUser,
     LenderAdmin,
     LenderUser,
     PremiumCollectorUser,
     SuperUser,
     SystemUser].each do |user_class|
      user_class.where(:disabled => false).each do |user|
        password_changed = user.user_audits.where(:function => UserAudit::PASSWORD_CHANGED).order("updated_at DESC").first
        user.password_changed_at = if password_changed && password_changed.updated_at
          password_changed.updated_at
        else
          Time.new(2013, 3, 7, 0, 0, 0, 0)
        end

        begin
          user.save!
          AdminAudit.log("password_changed_at forcibly updated", user, modifier)
        rescue Exception => e
          printf("%12s with id %4s raised an %s - %s\n", user.type, user.id, e.class, e)
        end
      end
     end
  end

  def down
  end
end
