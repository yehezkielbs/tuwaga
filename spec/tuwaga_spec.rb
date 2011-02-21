require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Tuwaga' do
  describe 'constructor' do
    it 'should be able to construct Tuwaga with default settings' do
      dec_system = Tuwaga.new
      dec_system.should be_an_instance_of(Tuwaga)
      dec_system.base.should == 10
      dec_system.symbols.should == ('0'..'9').to_a

      expected_symbol_value_map = {}
      ('0'..'9').to_a.each_with_index { |item, index| expected_symbol_value_map[item] = index }
      dec_system.symbol_value_map.should == expected_symbol_value_map
    end

    it 'should be able to construct Tuwaga with given settings' do
      new_system = Tuwaga.new(4, 'abcd')
      new_system.should be_an_instance_of(Tuwaga)
      new_system.base.should == 4
      new_system.symbols.should == %w( a b c d )

      expected_result = {
        'a' => 0,
        'b' => 1,
        'c' => 2,
        'd' => 3
      }
      new_system.symbol_value_map.should == expected_result
    end

    it 'should die when base is less than 2' do
      lambda { Tuwaga.new(-2) }.should raise_error('Base cannot be less than 2')
    end

    it 'should die when base is not an integer' do
      lambda { Tuwaga.new(3.2) }.should raise_error('Base must be an integer')
    end

    it 'should die when base > 36 but symbols are not defined' do
      lambda { Tuwaga.new(37) }.should raise_error('Can not guess what should be the symbols when base > 36 and symbols are not defined')
    end

    it 'should die when symbols length is not equal to base' do
      lambda { Tuwaga.new(2, '012') }.should raise_error('Symbols length is not equal to base')
    end

    it 'should die when symbols contains duplicate(s)' do
      lambda { Tuwaga.new(4, '0112') }.should raise_error('Symbols contains duplicate(s)')
    end
  end

  describe 'converter' do
    [
      #base x, symbols, number in decimal, number in base x
      [16, nil, 16, '10'],
      [16, '0123456789QWERTY', 773037414154, 'W3YE9TR70Q'],
      [10, '9876543210', 1234567890, '8765432109'],
      [4, 'BLAH', 4, 'LB'],
      [2, '01', 0, '0'],
      [16, nil, 10, 'a']
    ].each do |test|
      (base, symbols, number_in_decimal, number_in_base_x) = test

      it "should be able to convert '#{number_in_base_x}' in base #{base} to decimal" do
        number_base = Tuwaga.new(base, symbols)
        number_base.to_decimal(number_in_base_x).should == number_in_decimal
      end

      it "should be able to convert '#{number_in_decimal}' in decimal to base #{base}" do
        number_base = Tuwaga.new(base, symbols)
        number_base.from_decimal(number_in_decimal).should == number_in_base_x
      end

      it "should be able to convert '#{number_in_base_x}' in base #{base} to base 7" do
        number_base = Tuwaga.new(base, symbols)

        base_7 = Tuwaga.new(7, 'qwertyu')
        number_in_base_7 = number_base.convert_to(number_in_base_x, base_7);

        base_7.to_decimal(number_in_base_7).should == number_in_decimal
      end

      it "should be able to convert '#{number_in_decimal}' in base #{base} from base 7" do
        number_base = Tuwaga.new(base, symbols)

        base_7 = Tuwaga.new(7, 'qwertyu')
        number_in_base_7 = number_base.convert_to(number_in_base_x, base_7);

        number_base.convert_from(number_in_base_7, base_7).should == number_in_base_x
      end
    end
  end
end
