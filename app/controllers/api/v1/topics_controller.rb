# app/controllers/api/v1/topics_controller.rb
module Api
  module V1
    class TopicsController < Api::V1::ApplicationController

      # GET /api/v1/topics/:topic_id
      def show
        response = self.class.get("/api/v1/topics/#{params[:topic_id]}")
        handle_response(response)
      end
    end
  end
end
