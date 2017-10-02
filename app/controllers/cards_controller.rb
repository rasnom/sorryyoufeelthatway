class CardsController < ApplicationController

  def create
    new_card = Card.new(card_params)

    unless new_card.save
      flash[:error] = "Unable to create this card for some reason."
      redirect_to "/card_templates/#{new_card.card_template_id}"
    end

  #    #amount is in cents
  #   @amount = 499

  #   customer = Stripe::Customer.create(
  #     email: params[:stripeEmail],
  #     source: params[:stripeToken]
  #   )

  #   charge = Stripe::Charge.create(
  #     customer: customer.id,
  #     amount: @amount,
  #     description: 'Sorry you feel that way . biz Customer',
  #     currency: 'usd',
  #     metadata: {
  #       card_id: new_card.id,
  #       card_template_id: new_card.card_template_id,
  #       message: new_card.custom_message
  #     }
  #   )

  # rescue Stripe::CardError => e
  #   flash[:error] = e.message
  #   redirect_to "/card_templates/#{new_card.card_template_id}"
  end

  private

  def card_params
    params.require(:card).permit(:custom_message, :signature, :recipient_name,
                  :street_address, :city, :state, :zip_code, :card_template_id)
  end
end
