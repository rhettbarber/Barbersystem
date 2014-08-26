module Rack
  class Request
    def trusted_proxy?(ip)
      ip =~ /^(1\.2\.3\.4|127\.0\.0\.1)$/
    end
  end
end