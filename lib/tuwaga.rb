class Tuwaga
  attr_reader :base, :symbols, :symbol_value_map

  def initialize base = 10, symbols = nil
    @base = base
    validate_base

    @symbols = blank?(symbols) ? guess_symbols : symbols.split('')
    validate_symbols

    @symbol_value_map = Hash[* @symbols.enum_with_index.to_a.flatten]
  end

  def to_decimal input
    raise 'Input must be a string' if (!input.is_a?(String))

    result = 0
    power = 0
    input.split('').reverse.each do |char|
      result += @symbol_value_map[char] * (@base ** power)
      power += 1
    end

    result
  end

  def from_decimal input
    raise 'Input must be an integer' if (!input.is_a?(Integer))

    return @symbols[0] if input == 0

    result = ''
    in_decimal = input
    while (in_decimal > 0) do
      result = @symbols[in_decimal % @base] + result
      in_decimal = in_decimal / @base
    end

    result
  end

  def convert_to value, number_base
    raise 'Value must be a String' if (!value.is_a?(String))
    raise 'Number_base must be an instance of Tuwaga' if (!number_base.is_a?(Tuwaga))

    number_base.from_decimal(to_decimal(value))
  end

  def convert_from value, number_base
    raise 'Value must be a String' if (!value.is_a?(String))
    raise 'Number_base must be an instance of Tuwaga' if (!number_base.is_a?(Tuwaga))

    from_decimal(number_base.to_decimal(value))
  end

  private

  def blank? value
    !value || (value.respond_to?('empty?') && value.empty?)
  end

  def guess_symbols
    raise 'Can not guess what should be the symbols when base > 36 and symbols are not defined' if (@base > 36)

    num_alpha = ('0'..'9').to_a + ('a'..'z').to_a
    num_alpha[0, @base]
  end

  def validate_base
    raise 'Base cannot be less than 2' if (@base < 2)
    raise 'Base must be an integer' if (!@base.is_a?(Integer))
  end

  def validate_symbols
    raise 'Symbols contains duplicate(s)' if (@symbols != @symbols.uniq)
    raise 'Symbols length is not equal to base' if (@symbols.length != @base)
  end
end
