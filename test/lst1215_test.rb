require 'minitest/autorun'
require 'lohnsteuer/lst1215'

# Note: The test data was taken from page 40 and 41:
# https://www.bmf-steuerrechner.de/pruefdaten/pap2015Dezember.pdf
class Lst1215Test < Minitest::Test
  def test_applies_to_december_2015
    assert_equal true, Lst1215.applies?(Date.new(2015, 12, 7))
  end

  def test_doesnt_apply_to_november_2015
    assert_equal false, Lst1215.applies?(Date.new(2015, 11, 30))
  end

  def test_general_tax_class_1
    params = general_params.merge(RE4: 40_000 * 100, STKL: 1)
    res = Lst1215.calculate(params)
    assert_equal 6_499, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_2
    params = general_params.merge(RE4: 40_000 * 100, STKL: 2, PVZ: 0)
    res = Lst1215.calculate(params)
    assert_equal 5_912, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_3
    params = general_params.merge(RE4: 40_000 * 100, STKL: 3)
    res = Lst1215.calculate(params)
    assert_equal 3_388, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_4
    params = general_params.merge(RE4: 40_000 * 100, STKL: 4)
    res = Lst1215.calculate(params)
    assert_equal 6_499, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_5
    params = general_params.merge(RE4: 40_000 * 100, STKL: 5)
    res = Lst1215.calculate(params)
    assert_equal 10_656, res[:LSTLZZ] / 100
  end

  def test_general_tax_class_6
    params = general_params.merge(RE4: 40_000 * 100, STKL: 6)
    res = Lst1215.calculate(params)
    assert_equal 11_091, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_1
    params = special_params.merge(RE4: 40_000 * 100, STKL: 1)
    res = Lst1215.calculate(params)
    assert_equal 7_877, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_2
    params = special_params.merge(RE4: 40_000 * 100, STKL: 2)
    res = Lst1215.calculate(params)
    assert_equal 7_222, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_3
    params = special_params.merge(RE4: 40_000 * 100, STKL: 3)
    res = Lst1215.calculate(params)
    assert_equal 4_154, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_4
    params = special_params.merge(RE4: 40_000 * 100, STKL: 4)
    res = Lst1215.calculate(params)
    assert_equal 7_877, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_5
    params = special_params.merge(RE4: 40_000 * 100, STKL: 5)
    res = Lst1215.calculate(params)
    assert_equal 12_367, res[:LSTLZZ] / 100
  end

  def test_special_tax_class_6
    params = special_params.merge(RE4: 40_000 * 100, STKL: 6)
    res = Lst1215.calculate(params)
    assert_equal 12_802, res[:LSTLZZ] / 100
  end

  private

  def general_params
    { LZZ: 1, KVZ: 0.9, PKV: 0, PVZ: 1 }
  end

  def special_params
    { LZZ: 1, KRV: 2, PKV: 1, PKPV: 0 }
  end
end
