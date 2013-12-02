
require 'data_mapper'
require_relative '../common/account'
require_relative '../common/balance'
require_relative '../common/category'
require_relative '../common/transaction'
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://localhost/budgie')

DataMapper.auto_migrate!

