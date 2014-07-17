# Seymore - Content Management on Rails
# 
# Copyright (c) 2006 - 2007 Thomas Mango
# 
# For license information, please visit:
# http://code.google.com/p/seymore/
# 
# File created by Thomas Mango [tsmango@gmail.com]

class UserType < ActiveRecord::Base
  has_many :users
#  has_and_belongs_to_many :actions
end
