class StaticAssociation < Struct.new(:id, :name)
  class << self
    attr_accessor :data
  end

  def self.all
    @all ||= data.map { |d|
      new.tap { |item|
        item.id = d[:id]
        item.name = d[:name]
      }
    }
  end

  def self.find(id)
    all.detect { |item|
      item.id == id
    }
  end

  def self.find_by_name(name)
    all.detect { |item|
      item.name == name
    }
  end
end
