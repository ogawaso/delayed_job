if defined?(ActiveRecord)
  ActiveRecord::Base.class_eval do
    if instance_methods.include?(:encode_with)
      def encode_with_override(coder)
        encode_with_without_override(coder)
        coder.tag = "!ruby/ActiveRecord:#{self.class.name}"
      end
      alias_method :encode_with_without_override, :encode_with
      alias_method :encode_with, :encode_with_override
    else
      def encode_with(coder)
        coder["attributes"] = attributes
        coder.tag = "!ruby/ActiveRecord:#{self.class.name}"
      end
    end
  end
end

class Delayed::PerformableMethod
  # serialize to YAML
  def encode_with(coder)
    coder.map = {
      "object" => object,
      "method_name" => method_name,
      "args" => args
    }
  end
end
