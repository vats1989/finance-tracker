class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_tracked?(ticker)
    stock = Stock.find_by_ticker(ticker)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker)
    under_stock_limit? && !stock_already_tracked?(ticker)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.search(param)
    param.strip!
    # to_send_back = (first_name_matches(param) + last_name_matches(param) + email_name_matches(param)).uniq
    to_send_back = []
    %w[first_name last_name email].each { |field| to_send_back += matches(field, param) }
    to_send_back.uniq!
    return nil unless to_send_back
    to_send_back
  end

  # def self.first_name_matches(param)
  #   matches('first_name', param)
  # end
  #
  # def self.last_name_matches(param)
  #   matches('last_name', param)
  # end
  #
  # def self.email_name_matches(param)
  #   matches('email', param)
  # end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end
end
