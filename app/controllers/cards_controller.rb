class CardsController < ApplicationController

  def create
    new_card = Card.new(card_params)

    p '#'*88
    p new_card
    p new_card.save

    if new_card.save
      redirect_to congrats_path
    end
  end

  private

  def card_params
    params.require(:card).permit(:custom_message, :signature, :recipient_name,
                  :street_address, :city, :state, :zip_code, :card_template_id)
  end
end
