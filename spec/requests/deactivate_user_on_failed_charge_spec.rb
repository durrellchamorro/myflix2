require 'spec_helper'

describe "Deactive user on failed charge" do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }
  let(:event_data) do
    '{
      "id": "evt_1AHK8XGXpxGLtyRZgXfUWmeu",
      "object": "event",
      "api_version": "2017-04-06",
      "created": 1494281725,
      "data": {
        "object": {
          "id": "ch_1AHK8XGXpxGLtyRZ5hhUf6Tt",
          "object": "charge",
          "amount": 999,
          "amount_refunded": 0,
          "application": null,
          "application_fee": null,
          "balance_transaction": null,
          "captured": false,
          "created": 1494281725,
          "currency": "usd",
          "customer": "cus_AcCPCYLTWeH2pw",
          "description": "",
          "destination": null,
          "dispute": null,
          "failure_code": "card_declined",
          "failure_message": "Your card was declined.",
          "fraud_details": {
          },
          "invoice": null,
          "livemode": false,
          "metadata": {
          },
          "on_behalf_of": null,
          "order": null,
          "outcome": {
            "network_status": "declined_by_network",
            "reason": "generic_decline",
            "risk_level": "normal",
            "seller_message": "The bank did not return any further details with this decline.",
            "type": "issuer_declined"
          },
          "paid": false,
          "receipt_email": null,
          "receipt_number": null,
          "refunded": false,
          "refunds": {
            "object": "list",
            "data": [
            ],
            "has_more": false,
            "total_count": 0,
            "url": "/v1/charges/ch_1AHK8XGXpxGLtyRZ5hhUf6Tt/refunds"
          },
          "review": null,
          "shipping": null,
          "source": {
            "id": "card_1AHK8AGXpxGLtyRZ540lKB4B",
            "object": "card",
            "address_city": null,
            "address_country": null,
            "address_line1": null,
            "address_line1_check": null,
            "address_line2": null,
            "address_state": null,
            "address_zip": null,
            "address_zip_check": null,
            "brand": "Visa",
            "country": "US",
            "customer": "cus_AcCPCYLTWeH2pw",
            "cvc_check": "pass",
            "dynamic_last4": null,
            "exp_month": 5,
            "exp_year": 2018,
            "fingerprint": "XHMbPWoae4dMr1vt",
            "funding": "credit",
            "last4": "0341",
            "metadata": {
            },
            "name": null,
            "tokenization_method": null
          },
          "source_transfer": null,
          "statement_descriptor": null,
          "status": "failed",
          "transfer_group": null
        }
      },
      "livemode": false,
      "pending_webhooks": 1,
      "request": "req_AcZHUhxIegmkZ4",
      "type": "charge.failed"
    }'
  end

  it "deactivates a user with the web hook data from stripe for a failed charge", :vcr do
    neo = create(:user, stripe_id: "cus_AcCPCYLTWeH2pw")
    post "/stripe_events", event_data, headers

    expect(neo.reload).not_to be_active
  end
end
