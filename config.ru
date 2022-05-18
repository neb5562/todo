#config.ru

require_relative './config/environment'
require 'sinatra/activerecord'

use Rack::MethodOverride
run ApplicationController
use UsersController
use AuthController
use TodoController

