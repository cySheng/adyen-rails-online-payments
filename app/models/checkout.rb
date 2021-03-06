# Methods from the Adyen API Library for Ruby are defined here in the model and
# called from `CheckoutsController`.

# Note that certain values have been hard-coded for simplicity (i.e., you'll
# want to obtain some data from external resources or generate them at runtime).

require 'adyen-ruby-api-library'

class Checkout < ApplicationRecord
  # Makes the /paymentMethods request
  # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/paymentMethods
  def self.get_payment_methods
    adyen = Adyen::Client.new
    adyen.api_key = ENV["API_KEY"]
    adyen.env = :test

    response = adyen.checkout.payment_methods({
      :merchantAccount => ENV["MERCHANT_ACCOUNT"],
      :countryCode => 'NL',
      :amount => {
        :currency => 'EUR',
        :value => 1000
      },
      :channel => 'Web'
    })

    response
  end

  # Makes the /payments request
  # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/payments
  def self.make_payment(payment_method)
    adyen = Adyen::Client.new
    adyen.api_key = ENV["API_KEY"]
    adyen.env = :test

    response = adyen.checkout.payments({
      :amount => {
        :currency => "EUR",
        :value => 1000
      },
      :shopperIP => "192.168.1.3",
      :channel => "Web",
      :reference => "12345",
      :additionalData => {
        :executeThreeD => "true"
      },
      :paymentMethod => payment_method,
      :returnUrl => "http://localhost:3000/checkout/confirmation",
      :merchantAccount => ENV["MERCHANT_ACCOUNT"],
      :browserInfo => {
        :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36",
        :acceptHeader => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
      }
    })

    response
  end

  # Makes the /payments/details request
  # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/payments/details
  def self.submit_details(details)
    adyen = Adyen::Client.new
    adyen.api_key = ENV["API_KEY"]
    adyen.env = :test

    response = adyen.checkout.payments.details(details)

    response
  end
end
