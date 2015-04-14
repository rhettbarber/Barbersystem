module ActiveRecord
  module ConnectionAdapters
    class SQLServerAdapter < AbstractAdapter

      def configure_connection
      #raw_connection_do  "SET TEXTSIZE 10000"
        raw_connection_do "SET TEXTSIZE #{64.megabytes}"
        raw_connection_do  "SET CONCAT_NULL_YIELDS_NULL ON"
      end


      def configure_application_name
        "3_1_3_thread_#{$$}_#{Thread.current.object_id}".to(29)
      end

    end
  end
end