
class ErrorPorPreCondicion < StandardError
  def initialize(msg="My default message")
    super
  end
end

class ErrorPorPostCondicion < StandardError
  def initialize(msg="My default message")
    super
  end
end

module PrePost

  def self.included(base)
    base.class_eval do

      def self.pre(&bloque_pre)
        @pre = proc do
          begin
            if !self.instance_eval(&bloque_pre)
              raise ErrorPorPreCondicion, "No se cumplio la pre-condicion"
            end
          rescue NoMethodError
            # nada
          end
        end
      end

      def self.post(&bloque_post)
        @post = proc do |args|
          begin
            if !self.instance_exec args, &bloque_post
              raise ErrorPorPostCondicion, "No se cumplio la post-condicion"
            end
          rescue NoMethodError
            # nada
          end
        end
      end

      def self.reset_pre_y_post
        @pre = proc{}
        @post = proc{}
      end

      def self.get_pre
        @pre ||= proc{}
      end

      def self.get_post
        @post ||= proc{}
      end

    end #class eval
  end #def include

end
