class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    iex_client = Rails.application.credentials.iex_client

    client = IEX::Api::Client.new(
      publishable_token: iex_client[:sandbox_publishable_token],
      secret_token: iex_client[:sandbox_secret_token],
      endpoint: iex_client[:sandbox_endpoint]
    )

    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end

  def self.find_by_ticker(ticker)
    where(ticker: ticker).first
  end

end
