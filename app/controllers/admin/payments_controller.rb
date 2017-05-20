module Admin
  class PaymentsController < AdminsController
    def index
      @payments = Payment.all.page(params[:page]).per(20)
    end
  end
end
