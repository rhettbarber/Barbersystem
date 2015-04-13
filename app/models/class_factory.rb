class ClassFactory
  def self.create_class(new_class, *fields)
    c = Class.new do
      fields.each do |field|
        define_method field.intern do
          instance_variable_get("@#{field}")
        end
        define_method "#{field}=".intern do |arg|
          instance_variable_set("@#{field}", arg)
        end
      end
    end

    Kernel.const_set new_class, c
  end
end

#      ClassFactory.create_class "Car", "make", "model", "year"

#      new_class = Car.new
#      new_class.make = "Nissan"
#      puts new_class.make # => "Nissan"
#      new_class.model = "Maxima"
#      puts new_class.model # => "Maxima"
#      new_class.year = "2001"
#      puts new_class.year # => "2001"