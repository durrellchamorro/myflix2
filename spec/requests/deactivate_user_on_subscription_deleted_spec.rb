require 'spec_helper'

describe "deactivate user on subscription deleted event" do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }
  let(:event_data) do
    '{
      "id": "evt_1AI2T6GXpxGLtyRZMOhHNTew",
      "object": "event",
      "api_version": "2017-04-06",
      "created": 1494452136,
      "data": {
        "object": {
          "id": "sub_AchhyvnL4tZx4i",
          "object": "subscription",
          "application_fee_percent": null,
          "cancel_at_period_end": true,
          "canceled_at": 1494445426,
          "created": 1494313090,
          "current_period_end": 1496991490,
          "current_period_start": 1494313090,
          "customer": "cus_AchhHp5sdUL4EC",
          "discount": null,
          "ended_at": 1494452136,
          "items": {
            "object": "list",
            "data": [
              {
                "id": "si_1AHSIQGXpxGLtyRZrNZH6QGF",
                "object": "subscription_item",
                "created": 1494313090,
                "plan": {
                  "id": "basic_plan_id",
                  "object": "plan",
                  "amount": 999,
                  "created": 1447988118,
                  "currency": "usd",
                  "interval": "month",
                  "interval_count": 1,
                  "livemode": false,
                  "metadata": {
                  },
                  "name": "basic",
                  "statement_descriptor": "MyFlix Subscription",
                  "trial_period_days": null
                },
                "quantity": 1
              }
            ],
            "has_more": false,
            "total_count": 1,
            "url": "/v1/subscription_items?subscription=sub_AchhyvnL4tZx4i"
          },
          "livemode": false,
          "metadata": {
          },
          "plan": {
            "id": "basic_plan_id",
            "object": "plan",
            "amount": 999,
            "created": 1447988118,
            "currency": "usd",
            "interval": "month",
            "interval_count": 1,
            "livemode": false,
            "metadata": {
            },
            "name": "basic",
            "statement_descriptor": "MyFlix Subscription",
            "trial_period_days": null
          },
          "quantity": 1,
          "start": 1494313090,
          "status": "canceled",
          "tax_percent": null,
          "trial_end": null,
          "trial_start": null
        }
      },
      "livemode": false,
      "pending_webhooks": 1,
      "request": "req_AdJ5CWSNBrLxr4",
      "type": "customer.subscription.deleted"
    }'
  end

  it "deactivates a user with the web hook data from stripe for a customer.subscription.deleted", :vcr do
    neo = create(:user, stripe_id: "cus_AchhHp5sdUL4EC")
    post "/stripe_events", params: event_data, headers: headers

    expect(neo.reload).not_to be_active
  end
end
