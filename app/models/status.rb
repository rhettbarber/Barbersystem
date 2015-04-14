class Status < ActiveRecord::Base
has_many :clone_items


def self.names
    @names = []
    self.all.each do |the_type|
      @names << the_type.name
    end
    return @names
  end


end
