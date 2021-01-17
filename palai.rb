#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mechanize'
require 'logger'
require 'rake/funnel'

def login(mechanize)
  user = ENV['PALAI_USER'] || (raise 'PALAI_USER is missing')
  pass = ENV['PALAI_PASSWORD'] || (raise 'PALAI_USER is missing')

  login = mechanize.get('https://palai.org/u/sign_in')
  login_form = login.form_with(action: '/u/sign_in')
  login_form.field_with(id: 'user_email').value = user
  login_form.field_with(id: 'user_password').value = pass
  login_form.submit
end

def claim_income(dashboard)
  income = dashboard.link_with(href: %r{/basic_incomes$}).click

  claim = income.form_with(action: %r{/users/\d+/basic_incomes},
                           method: 'POST')

  unless claim
    fail('No income to claim')
    return
  end

  claim.submit
end

def report_balance(mechanize, dashboard)
  dashboard = mechanize.get(dashboard.uri)

  balance = dashboard.at_css('div.stat .value').text.gsub(/[^\d\.]/, '')

  STDOUT.puts(balance)
  Rake::Funnel::Integration::TeamCity::ServiceMessages \
    .build_statistic_value(key: 'Balance', value: balance)
end

def logout(dashboard)
  logout_form = dashboard.form_with(action: '/u/sign_out')
  logout_form.submit
end

Mechanize.start do |m|
  dashboard = login(m)
  claim_income(dashboard)
  report_balance(m, dashboard)
  logout(dashboard)
end
