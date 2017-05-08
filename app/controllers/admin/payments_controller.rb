module Admin
  class PaymentsController < AdminsController
    def index
      @payments = Payment.all
    end
  end
end
