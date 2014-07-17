class CrawlController < ApplicationController
  before_filter :redirect_unless_admin

  require 'nokogiri'
  require 'open-uri'



  def index
                @doc = Nokogiri::HTML(open('http://www.google.com/search?q=sparklemotion'))
                  #@page =  doc.to_html
  end





  def start
  end





end
