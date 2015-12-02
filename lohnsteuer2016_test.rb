require 'minitest/autorun'
require_relative 'lohnsteuer2016'

class Lohnsteuer2016Test < Minitest::Test
  def test_tax_class_1
    assert_equal 6_350, Lohnsteuer2016.calculate(salary: 40_000, tax_class: 1)[:income_tax]
    assert_equal 349, Lohnsteuer2016.calculate(salary: 40_000, tax_class: 1)[:solidarity_surcharge]
  end

  def test_tax_class_2
    assert_equal 5_768, Lohnsteuer2016.calculate(salary: 40_000, tax_class: 2, children: 3)[:income_tax]
  end

  def test_tax_class_3
    assert_equal 3_236, Lohnsteuer2016.calculate(salary: 40_000, tax_class: 3)[:income_tax]
  end
end
