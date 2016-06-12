module BaseHelpers
  def halt_request(status, body = {})
    response.status = status
    response.write(body.to_json)
    request.halt
  end
end