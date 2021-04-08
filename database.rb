require 'sqlite3'

$db = SQLite3::Database.new("development.db")

module Database
  def self.create_user_table
    sql = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY,
                                             name VARCHAR(256),
                                             lastname VARCHAR(256),
                                             username VARCHAR(256),
                                             password VARCHAR(256),
                                             token VARCHAR(256),
                                             role_id INTENGER,
                                             FOREIGN KEY(role_id) REFERENCES roles(id));"
    puts sql

    $db.execute(sql)
  end

  def self.create_role_table
    sql = "CREATE TABLE IF NOT EXISTS roles (id INTEGER PRIMARY KEY,
                                             name VARCHAR(256));"
    puts sql
    $db.execute(sql)
  end

  def self.insert(table, args)
    attrs = args.keys
    symbols = [['?'] * attrs.size].join(', ')
    sql = "INSERT INTO #{table} (#{attrs.join(', ')}) VALUES (#{symbols})"
    puts sql
    $db.execute(sql, args.values)
    $db.execute("SELECT last_insert_rowid()").flatten.first
  end

  def self.update(table, args)
    id = args.delete(:id)

    update = args.map do |key, val|
      if val.to_s.empty?
        "#{key}=''"
      elsif val.instance_of?(String)
        "#{key}='#{val}'"
      else
        "#{key}=#{val}"
      end
    end.join(', ')

    sql = "UPDATE #{table} SET #{update} WHERE id=#{id}"

    $db.execute(sql)
  end

  def self.all(table)
    $db.execute("SELECT * FROM #{table}")
  end

  def self.first(table)
    $db.execute("SELECT * FROM #{table} ORDER BY ID ASC LIMIT 1")
  end

  def self.last(table)
    $db.execute("SELECT * FROM #{table} ORDER BY ID DESC LIMIT 1")
  end

  def self.find(table, id)
    $db.execute("SELECT * FROM #{table} where id=#{id} ORDER BY ID ASC LIMIT 1")
  end

  def self.where(table, args)
    where = args.map do |key, val|
      if val.to_s.empty?
        "#{key}=''"
      elsif val.instance_of?(String)
        "#{key}='#{val}'"
      else
        "#{key}=#{val}"
      end
    end.join(', ')

    $db.execute("SELECT * FROM #{table} WHERE #{where} ORDER BY ID ASC")
  end
end

Database.create_role_table
Database.create_user_table
