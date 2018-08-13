require 'time'
require 'grape'

module TicTacToe
  module Server
    class API < Grape::API
      @@statuses =
          5.times.map do |i|
            {id: i+1, sent_at: Time.parse("2017-02-13T22:1#{3+i}:53Z").iso8601}
          end


      version 'v1', using: :header, vendor: 'janus'
      format :json
      prefix :api

      resource :statuses do
        desc 'Return an index.'
        get do
          5.times.map do |i|
            {id: i+1, sent_at: Time.parse("2017-02-13T22:1#{3+i}:53Z").iso8601}
          end
        end

        desc 'Return a random status.'
        get :random do
          max = 9_999_999
          min = (max*0.1).ceil
          mid = ((max+min)*0.5).ceil

          rndm = SecureRandom.random_number(min..max)
          delta = (rndm - mid)*10

          {
            id: rndm,
            sent_at: (Time.now.utc + delta).iso8601
          }
        end

        desc "Return a specific status"
        params do
          requires :id, type: Integer, desc: 'Status ID'
        end

        route_param :id do
          get do
            @@statuses.find{|status| status[:id] == params[:id]}
          end

          desc "Create/replace a status"
          params do
            requires :id, type: Integer, desc: "Status ID"
            requires :sent_at, type: String, desc: "When was this sent?"
          end
          put do
            status :created

            if @@statuses[params[:id]]
              status :no_content
            end

            @@statuses[params[:id]] = params
            @@statuses[params[:id]]
          end
        end

        desc "Create a status"
        params do
          requires :id, type: Integer, desc: "Status ID"
          requires :sent_at, type: String, desc: "When was this sent?"
        end

        post do
          if !@@statuses[params[:id]]
            @@statuses[params[:id]] = params
            status :created
          else
            status :conflict
          end
        end
      end
    end
  end
end
