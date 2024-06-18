<div class="card">
  <div class="form-horizontal">
    <div class="form-body">
      <div class="card-body">
        <h5 class="card-title mb-0">Users & Companies</h5>
      </div>
      <hr class="m-0" />
      <div class="card-body">
        <div class="row">
          <div class="col-md-6">
            <div class="text-bg-light rounded-1 p-6 d-inline-flex align-items-center justify-content-center mb-3">
              <i class="ti ti-users text-primary d-block fs-7" width="22" height="22"></i>
            </div>
            <h4 class="card-title mb-3">2 Active Users</h4>
            <button class="btn btn-primary mb-4">Manage Users</button>
          </div>
          <div class="col-md-6">
            <div class="text-bg-light rounded-1 p-6 d-inline-flex align-items-center justify-content-center mb-3">
              <i class="ti ti-building text-primary d-block fs-7" width="22" height="22"></i>
            </div>
            <h4 class="card-title mb-3">1 Company</h4>
            <button class="btn btn-primary mb-4">Manage Companies</button>
          </div>
        </div>
      </div>
      <hr class="m-0" />
      <div class="card-body d-flex align-items-center">
        <h5 class="card-title mb-0">Security Settings</h5>
        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
          <button type="submit" form="security-settings-form" class="btn btn-success mb-0" id="submit-security-setting-data">Save</button>
        </div>
      </div>
      <hr class="m-0" />
      <div class="card-body">
        <form id="security-settings-form" method="post" action="#">
          <div class="row">
            <div class="col-lg-6">
              <h4 class="card-title mb-0">Max Failed Login Attempt</h4>
              <p class="mb-3">Maximum number of unsuccessful login attempts</p>
              <input class="form-control mb-3" type="number" id="max_failed_login" name="max_failed_login" min="1">
            </div>
            <div class="col-lg-6">
              <h4 class="card-title mb-0">Max Failed OTP Validation Attempt</h4>
              <p class="mb-3">Maximum number of incorrect OTP attempts allowed</p>
              <input class="form-control mb-3" type="number" id="max_failed_otp_attempt" name="max_failed_otp_attempt" min="1">
            </div>
            <div class="col-lg-6">
              <h4 class="card-title mb-0">Password Validity Period</h4>
              <p class="mb-3">Sets the duration of the password expiry</p>
              <div class="input-group mb-3">
                <input class="form-control" type="number" id="password_expiry_duration" name="password_expiry_duration" min="1">
              <span class="input-group-text">day(s)</span>
              </div>
            </div>
            <div class="col-lg-6">
              <h4 class="card-title mb-0">One-Time Password Validity Period</h4>
              <p class="mb-3">The time window during which a one-time password (OTP) is valid</p>
              <div class="input-group mb-3">
                <input class="form-control" type="number" id="otp_duration" name="otp_duration" min="1">
                <span class="input-group-text">minute(s)</span>
              </div>
            </div>
            <div class="col-lg-6">
              <h4 class="card-title mb-0">Password Reset Token Validity Period</h4>
              <p class="mb-3">The time window during which a reset password token remains valid</p>
              <div class="input-group mb-3">
                <input class="form-control" type="number" id="reset_password_token_duration" name="reset_password_token_duration" min="1">
                <span class="input-group-text">minute(s)</span>
              </div>
            </div>
            <div class="col-lg-6">
              <h4 class="card-title mb-0">Session Inactivity Limit</h4>
              <p class="mb-3">Time before inactive sessions end</p>
              <div class="input-group mb-3">
                <input class="form-control" type="number" id="session_inactivity_limit" name="session_inactivity_limit" min="1">
                <span class="input-group-text">minute(s)</span>
              </div>
            </div>
            <div class="col-lg-6">
              <h4 class="card-title mb-0">Password Recovery Link</h4>
              <p class="mb-3">The default URL used for resetting user account password</p>
              <input class="form-control mb-3" type="text" id="password_recovery_link" name="password_recovery_link" maxlength="500">
            </div>
          </div>
        </form>
      </div>
      <hr class="m-0" />
      <div class="card-body d-flex align-items-center">
        <h5 class="card-title mb-0">System Settings</h5>
        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
          <button type="submit" form="system-settings-form" class="btn btn-success mb-0" id="submit-system-setting-data">Save</button>
        </div>
      </div>
    </div>
  </div>
</div>