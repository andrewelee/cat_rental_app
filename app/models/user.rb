class User < ActiveRecord::Base
  after_initialize: reset_session_token!


  def self.find_by_credentials(username, password)
    user = User.find(username)
    if user.is_password?(password)
      user
    else
      false
    end
  end

  def reset_session_token!
    self.session_token ||= SecureRandom.new(16)
    self.save!
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
