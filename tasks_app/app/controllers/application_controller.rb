class ApplicationController < ActionController::API
  before_action :set_default_response_format

  helper_method :respond_with_success

  private

  def set_default_response_format = request.format = 'json'

  def params_with_session
    params.merge!(session_params)
  end

  def session_params
    { token: }
  end

  def render_errors(fail_result, status: :bad_request)
    if fail_result.is_a?(Hash)
      render json: { status: :error }.merge(fail_result), status:
    else
      render json: { status: :error, error_code: fail_result }, status:
    end
  end

  def respond_with_unauthorized(fail_result)
    render_errors(fail_result, status: :forbidden)
  end

  def respond_with_success(json, root_key, &blk)
    json.status(:ok)

    return unless block_given?

    if root_key
      json.set!(root_key) { blk.() }
    else
      blk.()
    end
  end

  def respond_with_error_messages(error_messages, mapping = nil)
    error_messages = error_messages.transform_keys { |k| mapping.key(k) } if mapping

    render json: {
      status: :error,
      error_code: :validation,
      validation_errors: error_messages,
    }, status: :unprocessable_entity
  end

  def token
    request.headers['Authorization']&.split(/\ABearer /)&.second
  end

  def render_response(obj, params, &block)
    obj.(params) do |m|
      if block_given?
        m.success(&block)
      else
        m.success do |_|
          render json: { status: :ok }
        end
      end

      # Authorization errors handling
      m.failure(:validate_session_token) do |errors|
        respond_with_unauthorized(errors)
      end

      # Validation errors handling
      m.failure(:typecast) do |errors|
        respond_with_error_messages(errors)
      end

      m.failure(:validate_params) do |errors|
        respond_with_error_messages(errors)
      end

      m.failure do |errors|
        if errors == :not_found
          render json: { status: :not_found }, status: :not_found
        else
          render_errors(errors)
        end
      end
    end
  end

end
