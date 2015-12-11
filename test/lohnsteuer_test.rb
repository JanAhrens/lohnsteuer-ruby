require 'minitest/autorun'
require 'lohnsteuer'

class LohnsteuerTest < MiniTest::Unit::TestCase
  def test_calculate_month_throws_an_error_when_no_tax_algorithm_applies
    assert_raises(RuntimeError) do
      Lohnsteuer.calculate_month(1991, 12, 2000)
    end
  end

  def test_calculate_month_delegates_to_the_correct_tax_algorithm
    mock = MiniTest::Mock.new
    mock.expect(:applies?, true, [Date.new(2016, 2, 1)])
    mock.expect(:calculate, {}, [default_calculate_params.merge(RE4: 2000 * 100.0)])

    Lohnsteuer.stub(:tax_algorithms, [mock]) do
      Lohnsteuer.calculate_month(2016, 2, 2000)
    end

    assert mock.verify
  end

  def test_calculate_delegates_to_calculate_month
    options_stub = Object.new
    mock = MiniTest::Mock.new
    (1..12).each { |month| mock.expect(:call, {}, [2016, month, 2000.0, options_stub]) }

    Lohnsteuer.stub(:calculate_month, mock) do
      Lohnsteuer.calculate(2016, 24_000, options_stub)
    end

    assert mock.verify
  end

  private

  def default_calculate_params
    { STKL: 1, LZZ: 2, PKV: 0, KVZ: 1.10, PVZ: 1, ZKF: 0 }
  end
end
