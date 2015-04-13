module ActiveShipping
  class ConWayGateway < Base
    attr_accessor :username,:password,:test_mode,:debug_mode,:item_class,:customer_number,:shipping_adjustment,:accessorial_charges,:uom

    def initialize(options = {})
      if options.has_key? :dsn
        options = options.merge(Util.parse_dsn(options.delete(:dsn)))
      end
      @username = options[:username]
      @password = options[:password]
      @test_mode = options[:test_mode] || false
      @debug_mode = options[:debug_mode] || false
      @item_class = options[:item_class]
      @customer_number = options[:customer_number]
      @shipping_adjustment = options[:shipping_adjustment]
      @accessorial_charges = options[:accessorial_charges] || []
      @uom = options[:uom] || "lbs"
    end

    def self.initializer_properties
      [
        ["Item Class",:item_class,:text],
        ["Customer Number",:customer_number,:text],
        ["Shipping Adjustment",:shipping_adjustment,:text]
        # ["Accessorial Charges",:accessorial_charges,:checkbox]
      ]  
    end
    
    def self.initializer_select_options(params)
      case param
      when :item_class
        %w(50 55 60 65 70 775 85 925 100 110 125 150 175 200 250 300 400 500).collect {|ic| [ic,ic]}
      else
        nil
      end
    end

    def self.initializer_checkbox_options(param)
      case param
      when :accessorial_charges
        %w(SSC ZHM CBL DNC DRA ELS EVC GUR DID OIP RSO RSD SRT DLG OLG OSS DSH DMS SWC CSD PEO PED DFD)
      else
        nil # or []?
      end
    end

    def self.requires_username?
      return true
    end

    def self.requires_password?
      return true
    end

    def available_shipping_methods
      self.class.available_shipping_methods
    end

    def self.available_shipping_methods
      [:ground, :priority, :express]
    end

    def carrier_code
      self.class.carrier_code
    end

    def self.carrier_code
      return :conway
    end

    def self.carrier_name
      return "ConWay"
    end

    def estimate_shipping_cost(shipping_method, origin, destination, weight, num_items = nil, value = nil, other_info = nil)
      return calculate_weighted_shipping(shipping_method, weight, origin, destination)
    end

    private

    def calculate_weighted_shipping(shipping_method, weight, origin, destination)
      effective_date = Time.now.strftime("%m/%d/%y") # utc?
      # Note: ConWay doesn't like an <xml> line and they're very picky about
      # the order in which the elements are received
      request = <<-EOF
      <RateRequest>
        <OriginZip country="#{origin.country}">#{origin.postal_code}</OriginZip>
        <DestinationZip country="#{origin.country}">#{destination.postal_code}</DestinationZip>
      EOF
      unless self.customer_number.nil?
        request << "<CustNmbr shipcode=\"S\">#{self.customer_number}</CustNmbr>"
      end
      request << <<-EOF
        <ChargeCode>P</ChargeCode>
        <EffectiveDate>#{effective_date}</EffectiveDate>
      EOF

      #products.each do |product|
      request << <<-EOF
        <Item>
          <CmdtyClass>#{self.item_class}</CmdtyClass>
          <Weight unit="#{self.uom}">#{weight}</Weight>
        </Item>
      EOF
      #end

      self.accessorial_charges.each do |accessorial|
        request << "<Accessorial>#{accessorial}</Accessorial>"
      end
      request << "</RateRequest>"

      post_args = {
        'RateRequest' => request
      }

      data = ActiveShipping::Util.run_http_post_connection(ConWayGateway.gateway_url, post_args, self.username, self.password).body

      extract_price_from_response(data)
    end

    def extract_price_from_response(data)
      if self.debug_mode
        puts "RESPONSE DATA IS: #{data}\n"
      end
      if /<NetCharge[^>]*?>([^<]*?)<\/NetCharge>/im =~ data
        return BigDecimal.new($1)
      end
    end

    def self.gateway_url
      "https://www.Con-way.com/XMLj/X-Rate"
    end
  end
end
ActiveShipping::Base.register_shipping_module(ActiveShipping::ConWayGateway)
