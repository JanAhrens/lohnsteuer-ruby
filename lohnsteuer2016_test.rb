require 'minitest/autorun'
require_relative 'lohnsteuer2016'

class Lohnsteuer2016Test < Minitest::Test
  def test_tax_class_1
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 1, period: :year)
    assert_equal 6_350, res[:income_tax]
    assert_equal 349, res[:solidarity_surcharge]
  end

  def test_tax_class_2
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 2, period: :year, children: 3)
    assert_equal 5_768, res[:income_tax]
  end

  def test_tax_class_3
    res = Lohnsteuer2016.calculate(salary: 40_000, tax_class: 3, period: :year)
    assert_equal 3_236, res[:income_tax]
  end
end
