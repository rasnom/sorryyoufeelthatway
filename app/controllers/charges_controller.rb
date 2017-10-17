class ChargesController < ApplicationController

  def create
    @amount = 499

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    p "******************************"
    p "******************************"
    p "******************************"
    p "******************************"
    p "******************************"
    p "******************************"
    p "******************************"
    p "******************************"
    p customer
    p "******************************"
    p charge
  rescue Stripe::CardError => e
    p 'in rescue'
    flash[:error] = e.message
    if params[:card_id] == nil || Card.find(params[:card_id])
      redirect_to '/'
    else
      card = Card.find(params[:card_id])
      redirect_to card_template_card_path(
        id: card.id,
        card_template_id: card.card_template_id
      )
    end
  end
end
