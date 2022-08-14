require_relative '../lib/before_y_after'

class ErrorPorInvariant < StandardError
  def initialize(msg="My default message")
    super
  end
end

module Invariant

  include Before_Y_After

  def self.included(base)
    Before_Y_After.included base
    base.class_eval do

      def self.invariant(&bloque_invariant)

        bloque_invariant_improved = proc do
          begin
            if !self.instance_eval(&bloque_invariant)
              raise ErrorPorInvariant, "No se cumplio la condicion de Invariant"
            end
          rescue NoMethodError
            # nada
          end
        end

        after_each_call(bloque_invariant_improved)
      end

    end #class eval
  end #def included

end
