# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  location        :string           not null
#  house           :string           not null
#

class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  after_initialize :ensure_session_token

  attr_reader :password

  has_many :goals,
    foreign_key: :user_id,
    class_name: :Goal,
    dependent: :destroy

  def ensure_session_token
    session_token ||= self.class.generate_session_token
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return user if user && user.is_password?(password)
    nil
  end

  def reset_session_token!
    update!(session_token: self.class.generate_session_token)
    self.session_token
  end

  def is_password?(password)
    bcrypted_pw = BCrypt::Password.create(self.password_digest)
    bcrypted_pw.is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.new(password)
  end

end
