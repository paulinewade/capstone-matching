class ChangeweightsController < ApplicationController
    def index
        @score_attributes = ScoresAttribute.all
    end
end