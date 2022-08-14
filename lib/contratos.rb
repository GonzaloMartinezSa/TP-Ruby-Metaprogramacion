
require_relative '../lib/before_y_after'
require_relative '../lib/invariant'
require_relative '../lib/pre_post'

module Contratos
  include Before_Y_After
  include Invariant
  include PrePost

  def self.included(base)
    Before_Y_After.included(base)
    Invariant.included(base)
    PrePost.included(base)
    base.class_eval do

      def ejecutar_bloques(bloques)
        if @no_loopear_por_func != 0
          @no_loopear_por_func = 0

          bloques.each do |bloque|
            self.instance_eval &bloque
          end

          @no_loopear_por_func = 1
        end
      end

      def self.method_added(nombre_metodo)
        # A nivel clase

        if @no_loopear_por_agregar_method != 0
          @no_loopear_por_agregar_method = 0

          metodo_origial = self.instance_method(nombre_metodo)
          befores = self.bloques_before
          afters = self.bloques_after
          pre = self.get_pre
          post = self.get_post

          define_method(nombre_metodo) do |*variables|
            # A nivel objeto

            if metodo_origial.parameters.map{|p| p[1]}.any?
              params = metodo_origial.parameters.map { |p| p[1]}
              params.each_with_index do |arg_name, i|
=begin
                pre.define_singleton_method arg_name do
                  variables[i]
                end
                post.define_singleton_method arg_name do
                  variables[i]
                end
=end
                self.define_singleton_method arg_name do
                  variables[i]
                end
              end # each
            end

            self.ejecutar_bloques(befores)

            self.instance_eval &pre
            #pre.instance_eval &pre

            retornar = metodo_origial.bind(self).call(*variables)

            #post.instance_exec retornar, &post
            self.instance_exec retornar, &post

            self.ejecutar_bloques(afters)

            retornar
          end

          self.reset_pre_y_post

        else
          @no_loopear_por_agregar_method = 1
        end
      end # method added

    end #class eval
    end # def included

end
