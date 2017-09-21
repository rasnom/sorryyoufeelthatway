class CardTemplatesController < ApplicationController

  def index
    @templates = CardTemplate.all
  end

end
