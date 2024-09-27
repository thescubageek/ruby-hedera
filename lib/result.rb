# frozen_string_literal: true

# Value-object used for handling responses from an request
class Result
  attr_accessor :success, :data, :errors, :status

  def self.new_success(data: {}, status: nil)
    Result.new(success: true, data:, status:)
  end

  def self.new_failure(errors: [], status: nil)
    Result.new(success: false, errors:, status:)
  end

  def initialize(success:, data: {}, errors: [], status: nil)
    @success = success
    @data = data.respond_to?(:deep_stringify_keys) ? data.deep_stringify_keys : data
    @errors = Array(errors)
    @status = status.presence || (@success ? :ok : :bad_request)

    if @success
      raise ArgumentError, 'errors must be empty for successful results' if @errors.present?
    elsif @data.present?
      raise ArgumentError, 'data must be empty for unsuccessful results'
    end
  end

  alias_method :success?, :success

  def failure?
    !success
  end

  # Formats all of the errors into strings
  #
  # @return [Array<String] errors strings
  def error_strs
    errors.map { |e| e.is_a?(StandardError) ? "#{e.class}: #{e.message}" : e }
  end
end
