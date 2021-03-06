class ChargesController < ApplicationController

  def create
    Stripe.api_key = Rails.configuration.stripe[:secret_key]
    @amount = 499
    unless Card.exists?(params[:card_id])
      redirect_to '/'
    else
      @card = Card.find(params[:card_id])

      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      @charge = Stripe::Charge.create(
        :customer         => customer.id,
        :amount           => @amount,
        :description      => 'Handwritten greeting card',
        :currency         => 'usd',
        :receipt_email    => params[:stripeEmail],
        :shipping         => {
          :name           => @card.recipient_name,
          :address        => {
            :line1        => @card.street_address,
            :city         => @card.city,
            :state        => @card.state,
            :postal_code  => @card.zip_code
          }
        },
        :metadata         => {
          :card_id        => @card.id,
          :greeting       => @card.card_template.greeting,
          :custom_message => @card.custom_message,
          :signature      => @card.signature
        }
      )
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    if Card.exists?(params[:card_id])
      card = Card.find(params[:card_id])
      redirect_to card_template_card_path(
        id: card.id,
        card_template_id: card.card_template_id
      )
    else
      redirect_to '/'
    end
  end
end
