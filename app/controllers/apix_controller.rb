class ApixController < ApplicationController

  def index

      render json: {status: "SUCCESS", message: "Fetched all the friends successfully"}, status: :ok
  end

end
