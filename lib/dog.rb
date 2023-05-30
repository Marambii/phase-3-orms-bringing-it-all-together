class Dog
    attr_accessor :name, :breed, :id

    def initialize(name:, breed:, id: nil)
        @name = name
        @breed = breed
        @id = id
    end

    def self.create_table 
        sql = <<-SQL 
        CREATE TABLE IF NOT EXISTS dogs(
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        );
        SQL

        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-SQL
        DROP TABLE IF EXISTS dogs;
        SQL

        DB[:conn].execute(sql)
    end

    def save
        sql = <<-SQL
        INSERT INTO dogs (name,breed) VALUES(?, ?);
        SQL

        DB[:conn].execute(sql, self.name, self.breed)

        self.id = DB[:conn].last_insert_row_id

        self
    end

    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end

    def self.new_from_db(row)
        id, name, breed = row
        Dog.new(id: id, name: name, breed: breed)
    end

    def self.all
        sql = <<-SQL
        SELECT * FROM dogs
        SQL

        DB[:conn].execute(sql).map do |row|
            id, name, breed = row
            Dog.new(id: id, name: name, breed: breed)
        end
    end

    def self.find_by_name(name)
        sql = <<-SQL
        SELECT * FROM dogs
        WHERE NAME = ?
        LIMIT 1
        SQL

        row = DB[:conn].execute(sql, name).first

        if row
            id, found_name, breed = row
            Dog.new(id: id, name: found_name, breed: breed)
          else
            nil
          end
    end

    def self.find(id)
        sql = <<-SQL 
        SELECT * FROM dogs 
        WHERE id = ?
        LIMIT 1
        SQL
        row = DB[:conn].execute(sql, id).first

        if row
            found_id, name, breed = row
            Dog.new(id: found_id, name: name, breed: breed)
          else
            nil
          end
    end


end
