module Before_Y_After

  def self.included(base)
    base.class_eval do

      def self.before_and_after_each_call(proc_bloque_before=proc{}, proc_bloque_after=proc{})

        self.bloques_before << proc_bloque_before
        self.bloques_after << proc_bloque_after

      end

      def self.before_each_call(proc_bloque_before = proc{})
        self.bloques_before << proc_bloque_before
      end

      def self.after_each_call(proc_bloque_after = proc{})
        self.bloques_after << proc_bloque_after
      end

      def self.bloques_before
        @lista_bloques_before ||= [proc{}]
      end

      def self.bloques_after
        @lista_bloques_after ||= [proc{}]
      end

    end #class eval
  end #def included

end
