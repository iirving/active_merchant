require 'test_helper'

class BraintreeTest < Test::Unit::TestCase

  def test_new_with_login_password_creates_braintree_orange
    gateway = BraintreeGateway.new(
      :login => 'LOGIN',
      :password => 'PASSWORD'
    )
    assert_instance_of BraintreeOrangeGateway, gateway
  end

  def test_new_with_merchant_id_creates_braintree_blue
    gateway = BraintreeGateway.new(
      :merchant_id => 'MERCHANT_ID',
      :public_key => 'PUBLIC_KEY',
      :private_key => 'PRIVATE_KEY'
    )
    assert_instance_of BraintreeBlueGateway, gateway
  end

  def test_should_have_display_name_of_just_braintree
    assert_equal "Braintree", BraintreeGateway.display_name
  end

  def test_should_have_homepage_url
    assert_equal "http://www.braintreepaymentsolutions.com", BraintreeGateway.homepage_url
  end

  def test_should_have_supported_credit_card_types
    assert_equal [:visa, :master, :american_express, :discover, :jcb, :diners_club], BraintreeGateway.supported_cardtypes
  end

  def test_should_have_default_currency
    assert_equal "USD", BraintreeGateway.default_currency
  end

  def test_supports_network_tokenization_when_not_supported
    response = ActiveMerchant::Billing::Response.new(false,
      'Merchant account does not support payment instrument. (91577)',
      {"braintree_transaction"=>{"processor_response_code"=>"91577"}}, error_code: 91577)
    gateway.stubs(authorize: response)
    assert_equal false, gateway.supports_network_tokenization?
  end

  def test_supports_network_tokenization_should_raise_when_network_error
    response = ActiveMerchant::Billing::Response.new(false,
      'Merchant account does not support payment instrument. (91577)',
      {"braintree_invalid_response"=> nil})
    assert_raises ActiveMerchant::InvalidResponseError do
      gateway.supports_network_tokenization?
    end
  end

  private

  def gateway
    @gateway ||= BraintreeGateway.new(
      :merchant_id => 'MERCHANT_ID',
      :public_key => 'PUBLIC_KEY',
      :private_key => 'PRIVATE_KEY'
    )
  end
end
