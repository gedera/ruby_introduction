require './record'

class Role < Record
  attr_accessor :id, :name

  def initialize(params = {})
    @id = params[:id]
    @name = params[:name]
    super(params)
  end

  def users
    User.where(role_id: id)
  end

  def attributes
    { id: @id, name: @name }
  end

  def table_name
    self.class.table_name
  end

  def valid?
    @errors.details = {}

    validate_presence([:name])

    @errors.details.empty?
  end

  def self.table_name
    'roles'
  end

  def self.build_instance(tuples)
    tuples.map do |tupla|
      Role.new({id: tupla[0], name: tupla[1]})
    end
  end

end
