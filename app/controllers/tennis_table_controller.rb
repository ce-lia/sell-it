class TennisTableController < ApplicationController
  def ping
    if current_user
      render json: { response: 'authorized pong' }
    else
      render json: {response: 'unauthorized pong'}
    end
  end
end
