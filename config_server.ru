require_relative 'boot'

require 'tic_tac_toe/server/api'

use Rack::TryStatic,
  root: File.expand_path('../public', __FILE__),
  urls: %w[/], :try => ['.html']

run TicTacToe::Server::API
