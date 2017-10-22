class ChargesController < ApplicationController

  def create
    Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
    @amount = 499

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    @charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )
    pp @charge

  rescue Stripe::CardError => e
    flash[:error] = e.message
    if Card.exists?(charge_params[:card_id])
      card = Card.find(charge_params[:card_id])
      redirect_to card_template_card_path(
        id: card.id,
        card_template_id: card.card_template_id
      )
    else
      redirect_to '/'
    end
  end

  private

  def charge_params
    params.permit(:card_id)
  end

end
