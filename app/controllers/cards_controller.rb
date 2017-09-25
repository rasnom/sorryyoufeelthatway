class CardsController < ApplicationController

  def create
    new_card = Card.new(card_params)

    p '############################################'
    p new_card
    p new_card.save
    p '############################################'

    unless new_card.save
      flash[:error] = "Unable to create this card for some reason."
      redirect_to "/card_templates/#{new_card.card_template_id}"
    end

     #amount is in cents
    @amount = 499

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: 'Sorry you feel that way . biz Customer',
      currency: 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to "/card_templates/#{new_card.card_template_id}"
  end

  private

  def card_params
    params.require(:card).permit(:custom_message, :signature, :recipient_name,
                  :street_address, :city, :state, :zip_code, :card_template_id)
  end
end
