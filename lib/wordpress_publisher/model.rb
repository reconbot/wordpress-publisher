module WordpressPublisher

  module Model

    def publish(data)
      wp_id = data[:id]
      raise ArgumentError.new('invalid id') if wp_id.nil?
      obj = where(wp_id: wp_id).first_or_create

      data.each do |field, value|
        method = (field.to_s + '=').to_sym
        if obj.respond_to? method
          obj.send method, value
        end
      end

      obj.save if obj.changed?
      obj
    end

  end

end
