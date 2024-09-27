# frozen_string_literal: true

require 'test_helper'

class ResultTest < ActiveSupport::TestCase
  setup do
    @data = { 'foo' => 'bar' }
    @errors = [{ SecureRandom.hex => 'Missing required value' }]
  end

  test '.new_success - creates new successful Result with defaults' do
    result = Result.new_success
    assert_predicate result, :success?
    assert_equal({}, result.data)
    assert_equal [], result.errors
    assert_equal :ok, result.status
  end

  test '.new_success - creates new successful Result with positional arguments' do
    result = Result.new_success(data: @data, status: :no_content)
    assert_predicate result, :success?
    assert_equal @data, result.data
    assert_equal [], result.errors
    assert_equal :no_content, result.status
  end

  test '.new_failure - creates new unsuccessful Result with defaults' do
    result = Result.new_failure
    assert_predicate result, :failure?
    assert_equal({}, result.data)
    assert_equal [], result.errors
    assert_equal :bad_request, result.status
  end

  test '.new_failure - creates new unsuccessful Result with positional arguments' do
    result = Result.new_failure(errors: @errors, status: :forbidden)
    assert_predicate result, :failure?
    assert_equal({}, result.data)
    assert_equal @errors, result.errors
    assert_equal :forbidden, result.status
  end

  test '#new - creates new Result with defaults' do
    result = Result.new(success: true)
    assert result.success
    assert_equal({}, result.data)
    assert_equal [], result.errors
    assert_equal :ok, result.status

    result = Result.new(success: false)
    refute result.success
    assert_equal({}, result.data)
    assert_equal [], result.errors
    assert_equal :bad_request, result.status
  end

  test '#new - create new Result with positional arguments' do
    result = Result.new(success: true, data: @data, errors: [])
    assert result.success
    assert_equal @data, result.data
    assert_equal [], result.errors
    assert_equal :ok, result.status

    result = Result.new(success: false, data: {}, errors: @errors)
    refute result.success
    assert_equal({}, result.data)
    assert_equal @errors, result.errors
    assert_equal :bad_request, result.status
  end

  test '#new - create new Result with keyword arguments' do
    result = Result.new(success: true, data: @data)
    assert result.success
    assert_equal @data, result.data
    assert_equal [], result.errors
    assert_equal :ok, result.status

    result = Result.new(success: false, errors: @errors)
    refute result.success
    assert_equal({}, result.data)
    assert_equal @errors, result.errors
    assert_equal :bad_request, result.status
  end

  test '#new - supports custom success status' do
    result = Result.new(success: true, data: @data)
    assert_equal :ok, result.status

    result = Result.new(success: true, data: @data, status: :created)
    assert_equal :created, result.status
  end

  test '#new - supports custom error status' do
    result = Result.new(success: false, errors: @errors)
    assert_equal :bad_request, result.status

    result = Result.new(success: false, errors: @errors, status: :not_found)
    assert_equal :not_found, result.status
  end

  test '#new - stringify data keys' do
    data = { foo: { bar: 'baz' } }
    result = Result.new(success: true, data: data)
    assert_equal({ 'foo' => { 'bar' => 'baz' } }, result.data)
  end

  test '#new - raises exception if errors are provided for successful result' do
    assert_raises ArgumentError do
      Result.new(success: true, errors: @errors)
    end
  end

  test '#new - raises exception if data is provided for unsuccessful result' do
    assert_raises ArgumentError do
      Result.new(success: false, data: @data)
    end
  end
end
