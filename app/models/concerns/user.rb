class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_accessor :admin

  attr_writer :login

  validate :validate_username

  validate :password_complexity

  validates :username, format: { without: /\s/ }

  def login

    @login || self.username || self.email

  end

  def self.find_for_database_authentication(warden_conditions)

    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase}]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)

      where(conditions.to_h).first

    end

  end

  def validate_username

    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end

  end


  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./)
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit"
    end
  end


  # def password_complexity
  #   if password.present?
  #     if !password.match(/^(?=.*[a-z])(?=.*[A-Z])/)
  #       errors.add :password, "complexity requirement not met"
  #     end
  #   end
  # end

  # def username
  #
  #   return self.email.split('@')[0].capitalize
  #
  # end
end
