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

  def show
    @template = CardTemplate.find(params[:card_template_id])
    @card = Card.find(params[:id])
    check_session
  end

  def edit
    @template = CardTemplate.find(params[:card_template_id])
    @card = Card.find(params[:id])
    check_session
  end

  def update
    @template = CardTemplate.find(params[:card_template_id])
    @card = Card.find(params[:id])
    check_session

    @card.update(card_params)
  end

  def support
    @template = CardTemplate.find_by(greeting: "Sorry you feel that way")
    @prefill = {
      recipient_name: 'SorryYouFeelThatWay Support Team',
      street_address: '1777 9th St',
      city: 'Oakland',
      state: 'CA',
      zip_code: '94607'
    }
    render 'new'
  end

  private

  def check_session
    unless @card.session_id == session.id
      redirect_to new_card_template_card_url(card_template_id: @template.id)
    end
  end

  def card_params
    params.require(:card).permit(:custom_message, :signature, :recipient_name,
                  :street_address, :city, :state, :zip_code, :card_template_id)
  end
end
