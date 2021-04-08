require 'byebug'
require 'securerandom'
require './database'
require './error'

class Record
  attr_accessor :error

  def initialize(params)
    @errors = Errors.new
  end

  def initialize_key_error(attr)
    @errors.details[attr] = [] unless @errors.details.key?(attr)
  end

  # args => [:name, :lastname, :username]
  def validate_presence(args)
    args.each do |attr|
      value = send(attr).to_s
      next unless value.empty?

      initialize_key_error(attr)
      @errors.details[attr] += [{ error: :blank }]
    end
  end

  def validate_length(args)
    args.each do |attr, length|
      value = send(attr).to_s
      next if value.size >= length

      initialize_key_error(attr)
      @errors.details[attr] += [{ error: :too_short, count: 8 }]
    end
  end

  def save
    return false unless valid?

    if @id.nil?
      @id = Database.insert(table_name, attributes)
    else
      update
    end
  end

  def update
    return false unless valid?

    Database.update(table_name, attributes)
  end

  def destroy
    # IMPLEMENTAR
  end

  def self.first
    build_instance(Database.first(table_name)).first
  end

  def self.last
    build_instance(Database.last(table_name)).first
  end

  def self.all
    build_instance(Database.all(table_name))
  end

  def self.find(id)
    build_instance(Database.find(table_name, id)).first
  end

  def self.where(args)
    build_instance(Database.where(table_name, args))
  end
end
