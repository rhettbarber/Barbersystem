# Seymore - Content Management on Rails
# 
# Copyright (c) 2006 - 2007 Thomas Mango
# 
# For license information, please visit:
# http://code.google.com/p/seymore/
# 
# File created by Thomas Mango [tsmango@gmail.com]

class Slug
  def self.generate(string)
          if string
                        trim(string.gsub(/[^a-z1-9]+/i, '-').downcase)
          else
                           ""
            end
  end
  
  def self.trim(string)
    while string[string.length - 1, string.length] == '-'
      string = string.chop
    end
    string
  end
end