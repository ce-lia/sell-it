class User < ApplicationRecord
  has_secure_password

  has_many :classifieds

  validates :firstname, :lastname, :username, :password_digest, presence: true
  validates :username, uniqueness: true

  def fullname
    [firstname, lastname].compact.join(' ')
  end

  def self.from_token_request(request)
    username = request.params['auth'] && request.params['auth']['username']
    self.find_by(username: username)
  end
end
