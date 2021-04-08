require './record'
require './role'

# Implementar validaciones, que previo a guardar o updetear, se garantice
# name, lastname, username, password esten presentes.
# Password no se menos a 8 caracteres e incluya al menos una mayuscula y un numero.

class User < Record
  attr_accessor :id, :name, :lastname, :username, :password, :token, :role_id

  def initialize(params = {})
    @id = params[:id]
    @name = params[:name]
    @lastname = params[:lastname]
    @username = params[:username]
    @password = params[:password]
    @token = params[:token]
    @role_id = params[:role_id]
    super(params)
  end

  def role
    Role.find(@role_id)
  end

  def role=(role_model)
    @role_id = role_model.id
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
      token: @token,
      role_id: @role_id}
  end

  def validate_format_password
    return if @password.to_s.match?(/[A-Z]/) && @password.to_s.match?(/[0-9]/)

    initialize_key_error(:password)
    @errors.details[attr] += [{ error: :format }]
  end

  def valid?
    @errors.details = {}

    validate_presence([:name, :lastname, :username, :password])
    validate_length({ password: 8 })
    validate_format_password

    @errors.details.empty?
  end

  def table_name
    self.class.table_name
  end

  def self.table_name
    'users'
  end

  def self.build_instance(tuples)
    tuples.map do |tupla|
      User.new({id: tupla[0],
                name: tupla[1],
                lastname: tupla[2],
                username: tupla[3],
                password: tupla[4],
                token: tupla[5],
                role_id: tupla[6]})
    end
  end
end
