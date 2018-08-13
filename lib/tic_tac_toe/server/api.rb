require 'time'
require 'grape'

module TicTacToe
  module Server
    class API < Grape::API
      @@max_game_id = 0

      NEW_GAME_PROC = -> {
        @@max_game_id += 1
        {
          id: @@max_game_id,
          board:
          [
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
            ['', '', '', '', '', '', '', '', ''],
          ],
          winner: '',
          turn: 'X',
          valid_subgames: [0, 1, 3, 4, 5, 6, 7, 8]
        }
      }

      @@games = [NEW_GAME_PROC.call()]

      FIND_GAME_PROC = ->(id){
        @@games.find{|game| game[:id] == id} || raise("No Such Game")
      }

      version 'v1', using: :header, vendor: 'tic-tac-toe'
      format :json

      resource :game do
        desc "Return a specific game"
        params do
          requires :id, type: Integer, desc: 'Game ID'
        end

        get do
          FIND_GAME_PROC.call(params[:id])
        end

        desc "Create a game"
        post do
          game = NEW_GAME_PROC.call()
          @@games << game
          game
        end
      end

      resource :move do
        desc "Make a move in a game"
        params do
          requires :id,       type: Integer, desc: 'Game ID'
          requires :subgame,  type: Integer, desc: 'ID of the sub-game'
          requires :cell,     type: Integer, desc: 'The cell within the sub-game'
        end

        post do
          status :ok

          game = FIND_GAME_PROC.call(params[:id])

          player = game[:turn]
          if player == 'X'
            game[:turn] = 'Y'
          else
            game[:turn] = 'X'
          end

          subgame = game[:board][params[:subgame]]

          subgame[params[:cell]] = player

          game[:valid_subgames] = [params[:cell]]

          game
        end
      end
    end
  end
end
