# coding: utf-8
require 'date'
require 'lohnsteuer/version'
require 'lohnsteuer/lst1215'
require 'lohnsteuer/lst2016'

module Lohnsteuer
  def self.tax_algorithms
    [Lst2016, Lst1215]
  end

  def self.calculate_month(year, month, monthly_salary, options = {})
    params = {
      # The tax class must be 1, 2, 3, 4, 5 or 6.
      STKL: options[:tax_class] || 1,

      # Monthly salary in Euro cent.
      RE4: monthly_salary * 100.0,

      # Configure the algorithm to calculate monthly taxes.
      LZZ: 2,

      # Health insurance state.
      # 0 = general health insurance.
      # 1 = private health insurance without employer supplement.
      # 2 = private health insurance with employer supplement.
      PKV: options[:health_insurance_state] || 0,

      # Additional contribution rate to the general health insurance.
      KVZ: options[:additional_contribution_rate] || 1.10,

      # Allow to deselect the calculation of the nursing care insurance.
      PVZ: options[:no_nursing_care_insurance] ? 0 : 1,

      # Number of children eligible for the children allowance.
      ZKF: options[:children] || 0
    }

    algorithm = tax_algorithms.find { |c| c.applies?(Date.new(year, month, 1)) }
    fail "No tax algorithm found for #{month}/#{year}" unless algorithm

    res = algorithm.calculate(params)

    total_income_tax = (res[:LSTLZZ] || 0) + (res[:STS] || 0) + (res[:STV] || 0)
    total_solidarity_tax = (res[:SOLZLZZ] || 0) + (res[:SOLZS] || 0) + (res[:SOLZV] || 0)

    {
      income_tax: total_income_tax / 100.0,
      solidarity_tax: total_solidarity_tax / 100.0
    }
  end

  def self.calculate(year, annual_salary, options = {})
    (1..12).map do |month|
      calculate_month(year, month, annual_salary / 12.0, options)
    end.inject(income_tax: 0, solidarity_tax: 0) do |res, item|
      res[:income_tax] = res[:income_tax] + item[:income_tax]
      res[:solidarity_tax] = res[:solidarity_tax] + item[:solidarity_tax]
      res
    end
  end
end
