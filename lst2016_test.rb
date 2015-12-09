require 'minitest/autorun'
require 'date'
require_relative 'lst2016'

# Note: The test data was taken from page 37 and 38:
# https://www.bmf-steuerrechner.de/pruefdaten/pap2016.pdf
class Lst2016Test < Minitest::Test
  def test_applies_to_2016
    assert_equal true, Lst2016.applies?(Date.new(2016, 2, 1))
  end

  def test_doesnt_apply_to_2015
    assert_equal false, Lst2016.applies?(Date.new(2015, 12, 31))
  end

  def test_general_tax_class_1
    params = general_params.merge(RE4: 40_000 * 100, STKL: 1)
    res = Lst2016.new(params).LST2016
    assert_equal 6_350, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_2
    params = general_params.merge(RE4: 40_000 * 100, STKL: 2, PVZ: 0)
    res = Lst2016.new(params).LST2016
    assert_equal 5_768, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_3
    params = general_params.merge(RE4: 40_000 * 100, STKL: 3)
    res = Lst2016.new(params).LST2016
    assert_equal 3_236, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_4
    params = general_params.merge(RE4: 40_000 * 100, STKL: 4)
    res = Lst2016.new(params).LST2016
    assert_equal 6_350, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_5
    params = general_params.merge(RE4: 40_000 * 100, STKL: 5)
    res = Lst2016.new(params).LST2016
    assert_equal 10_513, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_6
    params = general_params.merge(RE4: 40_000 * 100, STKL: 6)
    res = Lst2016.new(params).LST2016
    assert_equal 10_948, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_1
    params = special_params.merge(RE4: 40_000 * 100, STKL: 1)
    res = Lst2016.new(params).LST2016
    assert_equal 7_793, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_2
    params = special_params.merge(RE4: 40_000 * 100, STKL: 2)
    res = Lst2016.new(params).LST2016
    assert_equal 7_143, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_3
    params = special_params.merge(RE4: 40_000 * 100, STKL: 3)
    res = Lst2016.new(params).LST2016
    assert_equal 4_056, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_4
    params = special_params.merge(RE4: 40_000 * 100, STKL: 4)
    res = Lst2016.new(params).LST2016
    assert_equal 7_793, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_5
    params = special_params.merge(RE4: 40_000 * 100, STKL: 5)
    res = Lst2016.new(params).LST2016
    assert_equal 12_321, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_6
    params = special_params.merge(RE4: 40_000 * 100, STKL: 6)
    res = Lst2016.new(params).LST2016
    assert_equal 12_756, res[:LSTLZZ] / 100
  end

  private

  def general_params
    { LZZ: 1, KVZ: 1.10, PKV: 0, PVZ: 1 }
  end

  def special_params
    { LZZ: 1, KRV: 2, PKV: 1, PKPV: 0 }
  end
end
