require_relative '../lib/prueba'

describe MiClase do

  let(:claseConBYA) { MiClase.new }

  #before_and_after_each_call(
  #  proc { puts "Entré a un mensaje" },
  #  proc { puts "Salí de un mensaje" }
  #)
  #before_and_after_each_call(
  #  proc { puts "Entré a un mensaje v2" },
  #  proc { puts "Salí de un mensaje v2" }
  #)

  describe '# Funca Before y After' do

    it 'should ' do
      expect{ claseConBYA.mensaje_1 }.to output("Entré a un mensaje\nEntré a un mensaje v2\nsoy el mensaje 1\nSalí de un mensaje\nSalí de un mensaje v2\n").to_stdout
    end

    it 'should ' do
      expect{ claseConBYA.mensaje_2(1,0) }.to output("Entré a un mensaje\nEntré a un mensaje v2\nsoy el mensaje 2 y me pasaron: 1 y 0\nSalí de un mensaje\nSalí de un mensaje v2\n").to_stdout
    end

  end
end

describe Guerrero do

  let(:claseConInvariant) { Guerrero.new }
  let(:atacante) { Guerrero.new }

  # invariant { vida >= 0 }
  # invariant { fuerza > 0 && fuerza < 100}

  describe '# Funca Invariante De Vida' do
    it do
      expect{claseConInvariant.vida= -2}.to raise_error(ErrorPorInvariant)
    end

    it do
      expect{claseConInvariant.vida= 500}.not_to raise_error
    end

    it do
      claseConInvariant.vida= 5
      atacante.fuerza= 10
      expect{atacante.atacar(claseConInvariant)}.to raise_error(ErrorPorInvariant)
    end

    it do
      claseConInvariant.vida= 5
      atacante.fuerza= 4
      expect{atacante.atacar(claseConInvariant)}.not_to raise_error
    end

  end

  describe '# Funca Invariante de fuerza' do

    it do
      expect{claseConInvariant.fuerza= -2}.to raise_error(ErrorPorInvariant)
    end

    it do
      expect{claseConInvariant.fuerza= 200}.to raise_error(ErrorPorInvariant)
    end

    it do
      expect{claseConInvariant.fuerza= 50}.not_to raise_error
    end

  end

end

describe Operaciones do

  let(:claseConPrePost) { Operaciones.new }

  # pre { divisor != 0 }
  # post { |result| result * divisor == dividendo }
  # def dividir(dividendo, divisor)
  # pre { divisor != 0 }
  # post { |result| result * divisor == dividendo }
  # def dividir_erroneo(dividendo, divisor)
  # def restar(minuendo, sustraendo)

  describe '# Funciona Pre-Condicion' do

    it 'should ' do
      expect{claseConPrePost.dividir(10, 5)}.not_to raise_error
    end

    it 'should ' do
      expect{claseConPrePost.dividir(10, 0)}.to raise_error(ErrorPorPreCondicion)
    end

    it 'should ' do
      expect{claseConPrePost.restar(0, 0)}.not_to raise_error
    end

  end

  describe '# Funciona Post-Condicion' do

    it 'should ' do
      expect{claseConPrePost.dividir(10, 5)}.not_to raise_error
      expect(claseConPrePost.dividir(10, 5)).to be(2)
    end

    it 'should ' do
      expect{claseConPrePost.dividir_erroneo(10, 5)}.to raise_error(ErrorPorPostCondicion)
    end

  end

end