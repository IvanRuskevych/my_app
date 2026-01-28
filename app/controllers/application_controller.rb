class ApplicationController < ActionController::Base
  require "rotp"

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # # variant 1
  # def auth
  #   # session[:verified] = false
  #   unless session[:verified]
  #     input_code = params[:auth_code].to_s.strip
  #     secret = "ICE2GBVAZXTNFQBUQMX2LHFCFE6H5T45"
  #     validator = ROTP::TOTP.new(secret)
  #
  #     if validator.verify(input_code)
  #       session[:verified] = true
  #     else
  #       render plain: "Not Authorized", code: 401
  #     end
  #   end
  # end

  #   variant 2
  def auth
    unless session[:verified]
      input_code = params[:auth_code].to_s.strip
      secret = "HCKCAVHFVMP2ISC6HS7H2PLBVAJH4IDP"
      totp = ROTP::TOTP.new(secret)

      if totp.verify(input_code, drift_behind: 1, drift_behind: 1)
        session[:verified] = true
        render plain: "✅ Authorized"
      else
        render plain: "❌ Not Authorized", status: 401
      end
    else
      render plain: "✅ Already Verified"
    end
  end

  def reset_verification
    session[:verified] = false
    redirect_to otp_form_path, notice: "✅ Verification reset!"
  end

  # Тестова сторінка для вводу OTP
  def otp_form
    render inline: <<-HTML
        <h1>OTP Verification Test</h1>
        <% if session[:verified] %>
            <p style="color: green;">✅ Already Verified!</p>
        <% end %>
        <form action="/auth" method="get">
        <label>Enter OTP:</label>
        <input type="text" name="auth_code" />
        <button type="submit">Verify</button>
      </form>
#{'      '}
      <!-- Кнопка для скидання -->
<form action="/reset" method="get" style="margin-top: 1em;">
  <button type="submit">Reset Verification</button>
</form>
      <p>Current OTP (for testing only): <%= ROTP::TOTP.new("HCKCAVHFVMP2ISC6HS7H2PLBVAJH4IDP").now %></p>
    HTML
  end
end
