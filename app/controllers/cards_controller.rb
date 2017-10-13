class CardsController < ApplicationController

  def new
    @template = CardTemplate.find(params[:card_template_id])
  end

  def create
    new_card = Card.new(card_params)

    if new_card.save
      new_card.update(session_id: session.id)
      redirect_to card_template_card_url(id: new_card.id)
    else
      flash[:error] = "Unable to create this card for some reason."
      redirect_to new_card_template_card_url
    end
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

  def show
    @template = CardTemplate.find(params[:card_template_id])
    @card = Card.find(params[:id])

    unless @card.session_id == session.id
      redirect_to new_card_template_card_url(card_template_id: @template.id)
    end
  end

  private

  def card_params
    params.require(:card).permit(:custom_message, :signature, :recipient_name,
                  :street_address, :city, :state, :zip_code, :card_template_id)
  end
end
