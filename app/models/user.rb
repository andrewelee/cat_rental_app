class User < ActiveRecord::Base

  has_many(
    :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :requests,
    class_name: "CatRentalRequest"
  )

  has_many(
    :sessions
  )

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by username: username
    if user.is_password?(password)
      user
    else
      nil
    end
  end

  def delete_session_token!(session_token)
    Session.find_by_token(session_token).delete
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
