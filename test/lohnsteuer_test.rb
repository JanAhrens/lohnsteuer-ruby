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
    (1..12).each { |month| mock.expect(:call, valid_calculate_month_result, [2016, month, 2000.0, options_stub]) }

    Lohnsteuer.stub(:calculate_month, mock) do
      Lohnsteuer.calculate(2016, 24_000, options_stub)
    end

    assert mock.verify
  end

  def test_calculate_month_maps_the_results
    result_to_map = { LSTLZZ: 19500, STS: 1000, STV: 200, SOLZLZZ: 1900, SOLZS: 100 }
    mock = MiniTest::Mock.new
    mock.expect(:applies?, true, [Date.new(2016, 2, 1)])
    mock.expect(:calculate, result_to_map, [default_calculate_params.merge(RE4: 2000 * 100.0)])

    Lohnsteuer.stub(:tax_algorithms, [mock]) do
      res = Lohnsteuer.calculate_month(2016, 2, 2000)
      assert_equal 207.0, res[:income_tax]
      assert_equal 20.0, res[:solidarity_tax]
    end
  end

  def test_calculate_combines_the_results_of_all_months
    options_stub = Object.new
    mock = MiniTest::Mock.new
    (1..12).each do |month|
      mock.expect(:call, valid_calculate_month_result, [2016, month, 2000.0, options_stub])
    end

    Lohnsteuer.stub(:calculate_month, mock) do
      res = Lohnsteuer.calculate(2016, 24_000, options_stub)
      assert_equal 2_400, res[:income_tax]
      assert_equal 240, res[:solidarity_tax]
    end
  end

  private

  def default_calculate_params
    { STKL: 1, LZZ: 2, PKV: 0, KVZ: 1.10, PVZ: 1, ZKF: 0 }
  end

  def valid_calculate_month_result
    { income_tax: 200, solidarity_tax: 20 }
  end
end
