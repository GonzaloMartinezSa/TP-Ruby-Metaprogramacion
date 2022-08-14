
require_relative '../lib/contratos'

class MiClase

  include Contratos

  before_and_after_each_call(
     proc { puts "Entré a un mensaje" },
     proc { puts "Salí de un mensaje" }
  )

  before_and_after_each_call(
    proc { puts "Entré a un mensaje v2" },
    proc { puts "Salí de un mensaje v2" }
  )

  def mensaje_1
    puts "soy el mensaje 1"
    5
  end

  def mensaje_2(numero, hola)
    #puts "soy el mensaje 2"
    puts "soy el mensaje 2 y me pasaron: #{numero} y #{hola}"
    3
  end

end

class Guerrero

  include Contratos

  attr_accessor :vida, :fuerza

  invariant { vida >= 0 }
  invariant { fuerza > 0 && fuerza < 100}

  def atacar(otro)
    otro.vida -= fuerza
  end

end

class Operaciones

  include Contratos

  pre { divisor != 0 }
  post { |result| result * divisor == dividendo }

  def dividir(dividendo, divisor)
    dividendo / divisor
  end

  # Para que falle la post-condicion
  pre { divisor != 0 }
  post { |result| result * divisor == dividendo }

  def dividir_erroneo(dividendo, divisor)
    dividendo - 3000
  end

  def restar(minuendo, sustraendo)
    minuendo - sustraendo
  end

end


# ------ Pruebas before y after each call

# MiClase.new.mensaje_1
# MiClase.new.mensaje_2 5, 6

# ------ Prubas Invariantes

#guerrero = Guerrero.new
#atacante = Guerrero.new

#guerrero.vida=-2
#guerrero.fuerza=4
#atacante.vida=5
#atacante.fuerza=100

#atacante.atacar(guerrero)
#puts guerrero.vida

# ------ Prubas Pre y Post Condiciones

# clase = Operaciones.new
# puts clase.dividir(10, 5)
# puts clase.dividir(10, 0) # falla la pre-condicion
# puts clase.restar(10, 5)

class Pila

  include Contratos

  attr_accessor :current_node, :capacity

  invariant { capacity >= 0 }

  post { empty? }
  def initialize(capacity)
    @capacity = capacity
    @current_node = nil
    #@current_node = Node.new(2, current_node) #----> Con esto no cumple la post (confirmado)
  end

  pre { !full? }
  post { height > 0 }
  def push(element)
    @current_node = Node.new(element, current_node)
  end

  pre { !empty? }
  def pop
    element = top
    @current_node = @current_node.next_node
    element
  end

  pre { !empty? }
  def top
    current_node.element
  end

  def height
    empty? ? 0 : current_node.size
  end

  def empty?
    current_node.nil?
  end

  def full?
    height == capacity
  end

  Node = Struct.new(:element, :next_node) do
    def size
      next_node.nil? ? 1 : 1 + next_node.size
    end
  end
end

pila = Pila.new(3)
pila.push(2)
pila.push(3)
puts pila.pop
pila.push(4)
pila.push(5)
# pila.push(6) # -----> Con esto no cumple la pre (confirmado), por pasarse del max (3) en la pila
pila.pop
pila.pop
pila.top
pila.pop
# pila.pop #-------> Con esto no cumple la pre (confirmado), por tratar de sacar cuando esta vacio
# pila.top -------> Con esto no cumple la pre (confirmado), por tratar de agarrar el top cuando esta vacio
