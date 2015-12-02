require 'minitest/autorun'
require_relative 'lohnsteuer2016'

class Lohnsteuer2016Test < Minitest::Test
  def test_general_tax_class_1
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 1, period: :year)
    assert_equal 6_350, res[:income_tax]
    assert_equal 349, res[:solidarity_surcharge]
  end

  def test_general_tax_class_2
    res = Lohnsteuer2016.calculate(
      salary: 40_000, period: :year,
      tax_class: 2, no_nursing_care_insurance: true)
    assert_equal 5_768, res[:income_tax]
    assert_equal 317, res[:solidarity_surcharge]
  end

  def test_general_tax_class_3
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 3, period: :year)
    assert_equal 3_236, res[:income_tax]
  end

  def test_general_tax_class_4
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 4, period: :year)
    assert_equal 6_350, res[:income_tax]
    assert_equal 349, res[:solidarity_surcharge]
  end

  def test_general_tax_class_5
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 5, period: :year)
    assert_equal 10_513, res[:income_tax]
    assert_equal 578, res[:solidarity_surcharge]
  end

  def test_general_tax_class_6
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 6, period: :year)
    assert_equal 10_948, res[:income_tax]
    assert_equal 602, res[:solidarity_surcharge]
  end
end
