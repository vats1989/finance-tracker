class Stock < ApplicationRecord

  def self.new_lookup(ticker_symbol)
    iex_client = Rails.application.credentials.iex_client

    client = IEX::Api::Client.new(
      publishable_token: iex_client[:sandbox_publishable_token],
      secret_token: iex_client[:sandbox_secret_token],
      endpoint: iex_client[:sandbox_endpoint]
    )
    client.price(ticker_symbol)
  end

end
