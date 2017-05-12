require 'spec_helper'

describe "marks subscription to cancel at period end after receiving the customer.subscription.updated webhook" do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }
  let(:event_data) do
    '{
      "id": "evt_1AI43LGXpxGLtyRZutFKzn0d",
      "object": "event",
      "api_version": "2017-04-06",
      "created": 1494458227,
      "data": {
        "object": {
          "id": "sub_Ace4PVkZr7X3aN",
          "object": "subscription",
          "application_fee_percent": null,
          "cancel_at_period_end": true,
          "canceled_at": 1494458227,
          "created": 1494299599,
          "current_period_end": 1496977999,
          "current_period_start": 1494299599,
          "customer": "cus_Ace43pxndfZILX",
          "discount": null,
          "ended_at": null,
          "items": {
            "object": "list",
            "data": [
              {
                "id": "si_1AHOmpGXpxGLtyRZXUeoXFkl",
                "object": "subscription_item",
                "created": 1494299600,
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
            "url": "/v1/subscription_items?subscription=sub_Ace4PVkZr7X3aN"
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
          "start": 1494299599,
          "status": "active",
          "tax_percent": null,
          "trial_end": null,
          "trial_start": null
        },
        "previous_attributes": {
          "cancel_at_period_end": false,
          "canceled_at": null
        }
      },
      "livemode": false,
      "pending_webhooks": 1,
      "request": "req_AdKi22PEgfdS2C",
      "type": "customer.subscription.updated"
    }'
  end

  it "changes the cancel_at_period_end column in subscriptions to true", :vcr do
    neo = create(:user, stripe_id: "cus_Ace43pxndfZILX")
    create(:subscription, user: neo)
    post "/stripe_events", event_data, headers

    expect(neo.reload.canceling_at_subscription_end?).to be true
  end
end
