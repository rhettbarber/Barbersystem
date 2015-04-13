#
#module ActiveRecord
#      class Base
#                class << self
#                protected
#                      def current_scoped_methods #:nodoc:
#                                  method = scoped_methods.last
#                                  if method.respond_to?(:call)
#                                    unscoped(&method)
#                                  else
#                                    method
#                                  end
#                      end
#        end
#
# def current_scoped_methods #:nodoc:
#      last = scoped_methods.last
#      if last.is_a?(Proc)
#        unscoped(&last)
#      else
#        last
#      end
#    end
#
#
#
#      end
#    end
#

#
#module ActiveRecord #:nodoc:
#
#  class Base
#
#        def default_scope(scope_options = {})
#
#          $stdout.puts "GREAT ITS WORKING"
#
#          reset_scoped_methods
#          self.default_scoping << lambda {
#            construct_finder_arel(
#              scope_options.is_a?(Proc) ? scope_options.call : scope_options)
#          }
#        end
#
#        def current_scoped_methods #:nodoc:
#         method = scoped_methods.last
#         if method.is_a? Proc
#            unscoped(&method)
#          else
#            method
#          end
#        end
#
#
#  end
#
#
#  end
#

