# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  	attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

 # before_save { |user| user.email = email.downcase }
 before_save{self.email.downcase!}

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

#  VALID_PASSWORD_REGEX = /^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$/

  validates :password, length: { minimum: 8 } #, format: {with: VALID_PASSWORD_REGEX}
  validates :password_confirmation, presence: true


end
