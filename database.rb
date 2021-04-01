require 'sqlite3'

$db = SQLite3::Database.new("development.db")

module Database
  def self.create_user_table
    sql = "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name VARCHAR(256), lastname VARCHAR(256), username VARCHAR(256), password VARCHAR(256), token VARCHAR(256));"
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
      if val.nil? || val.empty?
        "#{key}=''"
      else
        "#{key}='#{val}'"
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
end

Database.create_user_table
