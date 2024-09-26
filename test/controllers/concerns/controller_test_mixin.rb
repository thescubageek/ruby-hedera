module ControllerTestMixin
  def success_response(body)
    OpenStruct.new(code: 200, body: body, parsed_response: JSON.parse(body), success?: true)
  end
end
