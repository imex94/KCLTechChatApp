require 'data_mapper'
require  'dm-migrations'

#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://pshpodoahlqsjx:MolTIvbThmwHMmzI57tO2D3NtO@ec2-54-228-191-114.eu-west-1.compute.amazonaws.com:5432/db9bhvl2fvv9mp')

class Message
  include DataMapper::Resource

  property :id,            Serial
  property :text,          String
  property :createdAt,     DateTime

  belongs_to :user
end

class User
  include DataMapper::Resource

  property :id,            Serial
  property :name,          String
end

class Conversation
  include DataMapper::Resource

  property :id,            Serial
  property :name,          String

  has n, :messages, :through => Resource
  has n, :users, :through => Resource
end

DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!
