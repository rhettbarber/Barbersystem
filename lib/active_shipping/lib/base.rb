#Copyright 2007 New Medio.  This file is part of ActiveShipping.  See README for license and legal information.

module ActiveShipping
	
	#
	# This is the superclass to all included ActiveShipping modules, as well as
	# being the repository of system-wide data about available ActiveShipping 
	# modules (modules is used as a generic term -- these are implemented as 
	# Ruby classes, not modules).
	#
	class Base
		#--
		# Methods to be overridden by subclasses or included as a class method of the subclass.
		#++		

		# NOTE - must be called on a subclass.
		#
		# Initializes the gateway.  It has two ways of calling it:
		#
		# :dsn => "DSN_STRING", :password => "password"
		#
		# In this mechanism, the whole configuration for the shipping module
		# is contained in the DSN string.  For some shipping modules, this
		# is just a username, while others have a whole host of available options.
		#
		# This provides a single mechanism for instantiating shipping modules.  If
		# you can provide the DSN string and the password, you can use a shipping
		# module.  This makes it simple to switch between shipping modules within an 
		# application.
		#
		# Alternatively, you can specify each module-specific option individually.
		# To get a list of available options, use the class method <tt>initializer_properties</tt>
		# for your shipping module.  All shipping modules should support the following options:
		#
		# [:test_mode] Set to true if you are wanting to use the shipper's test gateway
		# [:debug_mode] Set to true to see debugging output from the shipping module
		# [:username] The username.  Some modules don't use this.  Use the module's class method <tt>requires_username?</tt> to determine if this is required
		# [:password] The password.  Some modules don't use this.  Use the module's class method <tt>requires_password?</tt> to determine if this is required.  Note that the password is never specified within the DSN, but always passed separately.
		#
		def initialize(options = {})
			raise "Please use a subclass"
		end

		# NOTE - must be called on a subclass.
		#
		# Returns a list of the properties available for use for initializing the shipping module.  The format is:
		#
		# <tt>[ ["User-friendly name of option", :symbol_for_option, :type_of_input], ... ]</tt>
		#
		# The <tt>:symbol_for_option</tt> is the symbol used in the <tt>options</tt> hash of the initializer.  <tt>:type_of_input</tt>
		# may be one of:
		#
		# [:text] This is a freetext field.  If provided as a user-interface element, it should use a text_field_tag.
		# [:textarea] A multiline freetext field.  If provided as a user-interface element, it should use a text_area_tag.
		# [:select] A predefined selection list.  Use <tt>initializer_select_options</tt> to find the available options for this parameter.
		# [:checkbox] A predefined checkbox selection.  Use <tt>initializer_select_options</tt> to find the available options for this parameter.
		#
		# Note that all modules must also supply methods of the same name as the options for setting these values.
		#
		def self.initializer_properties
			raise "Please use a subclass"
		end

		# NOTE - must be called on a subclass.
		#
		# Returns options for select and checkbox initializer properties.  The format is <tt>[ ["User-friendly name", "Internal Value"], ... ]</tt>
		#
		def self.initializer_select_options(param)
			raise "Please use a subclass"
		end

		# NOTE - must be called on a subclass.
		# 
		# Returns true if this module requires a username.  All modules must accept a username
		# even if one is not required (i.e. it should not raise an error).
		#
		def self.requires_username?
			raise "Please use a subclass"
		end
		
		# NOTE - must be called on a subclass.
		# 
		# Returns true if this module requires a password.  All modules must accept a password
		# even if one is not required (i.e. it should not raise an error).
		#
		def self.requires_username?
			raise "Please use a subclass"
		end

		def self.available_shipping_methods
			raise "Please use a subclass"
		end

		def carrier_code
			raise "Please use a subclass"
		end

		def self.carrier_code
			raise "Please use a subclass"
		end

		def self.carrier_name
			raise "Please use a subclass"
		end

		def estimate_shipping_cost(shipping_method, origin, destination, weight, num_items = nil, value = nil, other_info = nil)
			raise "Please use a subclass"
		end

		#--
		# Methods for user to query API availabilities
		#++		

		def self.gateway_connection(name, dsn, password = nil, options = {})
			@@api_modules[name].new(options.merge({ :dsn => dsn, :password => password }))
		end

		@@api_modules = {}
		def self.registered_shipping_modules
			@@api_modules
		end

		#--
		# Methods for maintenance of the API modules themselves
		#++

		def self.register_shipping_module(klass)
			@@api_modules[klass.carrier_code] = klass
		end
	end
end
