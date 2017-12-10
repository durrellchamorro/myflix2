require 'spec_helper'

describe "Create payment on successful charge" do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }
  let(:event_data) do
    '{
      "id": "evt_1AGs2WGXpxGLtyRZWdWn7luG",
      "object": "event",
      "api_version": "2017-04-06",
      "created": 1494173720,
      "data": {
        "object": {
          "id": "ch_1AGs2VGXpxGLtyRZFFNwDuPK",
          "object": "charge",
          "amount": 999,
          "amount_refunded": 0,
          "application": null,
          "application_fee": null,
          "balance_transaction": "txn_1AGs2WGXpxGLtyRZZfS1iIMM",
          "captured": true,
          "created": 1494173719,
          "currency": "usd",
          "customer": "cus_Ac6Enrxmt7FfT6",
          "description": null,
          "destination": null,
          "dispute": null,
          "failure_code": null,
          "failure_message": null,
          "fraud_details": {
          },
          "invoice": "in_1AGs2VGXpxGLtyRZGnFi77c9",
          "livemode": false,
          "metadata": {
          },
          "on_behalf_of": null,
          "order": null,
          "outcome": {
            "network_status": "approved_by_network",
            "reason": null,
            "risk_level": "normal",
            "seller_message": "Payment complete.",
            "type": "authorized"
          },
          "paid": true,
          "receipt_email": null,
          "receipt_number": null,
          "refunded": false,
          "refunds": {
            "object": "list",
            "data": [
            ],
            "has_more": false,
            "total_count": 0,
            "url": "/v1/charges/ch_1AGs2VGXpxGLtyRZFFNwDuPK/refunds"
          },
          "review": null,
          "shipping": null,
          "source": {
            "id": "card_1AGs2UGXpxGLtyRZt6ASsMR2",
            "object": "card",
            "address_city": null,
            "address_country": null,
            "address_line1": null,
            "address_line1_check": null,
            "address_line2": null,
            "address_state": null,
            "address_zip": "90210",
            "address_zip_check": "pass",
            "brand": "Visa",
            "country": "US",
            "customer": "cus_Ac6Enrxmt7FfT6",
            "cvc_check": "pass",
            "dynamic_last4": null,
            "exp_month": 1,
            "exp_year": 2020,
            "fingerprint": "lDX58NyMrxeFQZLt",
            "funding": "credit",
            "last4": "4242",
            "metadata": {
            },
            "name": null,
            "tokenization_method": null
          },
          "source_transfer": null,
          "statement_descriptor": "MyFlix Subscription",
          "status": "succeeded",
          "transfer_group": null
        }
      },
      "livemode": false,
      "pending_webhooks": 1,
      "request": "req_Ac6ETsYpIWY7rc",
      "type": "charge.succeeded"
    }'
  end

  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", params: event_data, headers: headers

    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    neo = create(:user, stripe_id: "cus_Ac6Enrxmt7FfT6")
    post "/stripe_events", params: event_data, headers: headers

    expect(Payment.first.user).to eq(neo)
  end

  it "creates the payment with the ammount", :vcr do
    post "/stripe_events", params: event_data, headers: headers

    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with the reference_id", :vcr do
    post "/stripe_events", params: event_data, headers: headers

    expect(Payment.first.reference_id).to eq("ch_1AGs2VGXpxGLtyRZFFNwDuPK")
  end
end
