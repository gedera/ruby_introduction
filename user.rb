require 'byebug'
require 'securerandom'
require './database'

# Implementar validaciones, que previo a guardar o updetear, se garantice
# name, lastname, username, password esten presentes.
# Password no se menos a 8 caracteres e incluya al menos una mayuscula y un numero.

class User
  attr_accessor :id, :name, :lastname, :username, :password, :token

  def initialize(params = {})
    @id = params[:id]
    @name = params[:name]
    @lastname = params[:lastname]
    @username = params[:username]
    @password = params[:password]
    @token = params[:token]
  end

  def signin!
    # IMPLEMENTAR
  end

  def signout!
    # IMPLEMENTAR
  end

  def attributes
    { id: @id,
      name: @name,
      lastname: @lastname,
      username: @username,
      password: @password,
      token: @token }
  end

  def save
    if @id.nil?
      @id = Database.insert('users', attributes)
    else
      update
    end
  end

  def update
    Database.update('users', attributes)
  end

  def destroy
    # IMPLEMENTAR
  end

  def self.build_instance(tuples)
    tuples.map do |tupla|
      User.new({id: tupla[0],
                name: tupla[1],
                lastname: tupla[2],
                username: tupla[3],
                password: tupla[4],
                token: tupla[5]})
    end
  end

  def self.first
    build_instance(Database.first('users')).first
  end

  def self.last
    build_instance(Database.last('users')).first
  end

  def self.all
    build_instance(Database.all('users'))
  end
end
