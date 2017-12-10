require 'spec_helper'

describe "create subscription on successful subscription event" do
  let(:headers) { { "CONTENT_TYPE" => "application/json" } }
  let(:event_data) do
    '{
      "id": "evt_1AHOmqGXpxGLtyRZxJHSdn9z",
      "object": "event",
      "api_version": "2017-04-06",
      "created": 1494299600,
      "data": {
        "object": {
          "id": "sub_Ace4PVkZr7X3aN",
          "object": "subscription",
          "application_fee_percent": null,
          "cancel_at_period_end": false,
          "canceled_at": null,
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
        }
      },
      "livemode": false,
      "pending_webhooks": 1,
      "request": "req_Ace4BcwRydwqGc",
      "type": "customer.subscription.created"
    }'
  end

  it 'creates a subscription from the webhook from stripe for customer.subscription.created', :vcr do
    post "/stripe_events", params: event_data, headers: headers

    expect(Subscription.count).to eq(1)
  end

  it "creates the subscription associated with the user", :vcr do
    neo = create(:user, stripe_id: "cus_Ace43pxndfZILX")
    post "/stripe_events", params: event_data, headers: headers

    expect(Subscription.first.user).to eq(neo)
  end

  it "creates the subscription with the current_period_start" do
    post "/stripe_events", params: event_data, headers: headers

    expect(Subscription.first.current_period_start).to eq(1494299599)
  end

  it "creates the subscription with the current_period_end" do
    post "/stripe_events", params: event_data, headers: headers

    expect(Subscription.first.current_period_end).to eq(1496977999)
  end

  it "creates the subscription with the ammount", :vcr do
    post "/stripe_events", params: event_data, headers: headers

    expect(Subscription.first.amount).to eq(999)
  end

  it "creates the subscription with the reference_id", :vcr do
    post "/stripe_events", params: event_data, headers: headers

    expect(Subscription.first.reference_id).to eq("sub_Ace4PVkZr7X3aN")
  end
end
