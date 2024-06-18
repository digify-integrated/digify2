(function($) {
    'use strict';

    $(function() {
        if($('#security-settings-form').length){
            securitySettingsForm();
            displayDetails('get security setting details');
        }

        $(document).on('click','#discard-create',function() {
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            discardCreate(page_link);
        });
    });
})(jQuery);

function securitySettingsForm(){
    $('#security-settings-form').validate({
        rules: {
            max_failed_login: {
                required: true
            },
            max_failed_otp_attempt: {
                required: true
            },
            password_expiry_duration: {
                required: true
            },
            otp_duration: {
                required: true
            },
            reset_password_token_duration: {
                required: true
            },
            session_inactivity_limit: {
                required: true
            },
            password_recovery_link: {
                required: true
            }
        },
        messages: {
            max_failed_login: {
                required: 'Please enter the max failed login attempt'
            },
            max_failed_otp_attempt: {
                required: 'Please enter the max failed OTP validation attempt'
            },
            password_expiry_duration: {
                required: 'Please enter the password validity period'
            },
            otp_duration: {
                required: 'Please enter the one-time password validity period'
            },
            reset_password_token_duration: {
                required: 'Please enter the password reset token validity period'
            },
            session_inactivity_limit: {
                required: 'Please enter the session inactivity limit'
            },
            password_recovery_link: {
                required: 'Please enter the password recovery link'
            }
        },
        errorPlacement: function (error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 1500);
        },
        highlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection__rendered').addClass('is-invalid');
            }
            else {
                inputElement.addClass('is-invalid');
            }
        },
        unhighlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection__rendered').removeClass('is-invalid');
            }
            else {
                inputElement.removeClass('is-invalid');
            }
        },
        submitHandler: function(form) {
            const transaction = 'update security settings';
            const page_link = document.getElementById('page-link').getAttribute('href');
          
            $.ajax({
                type: 'POST',
                url: 'components/general-settings/controller/security-setting-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                    }
                    else {
                        if (response.isInactive || response.notExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function() {
                    enableFormSubmitButton('submit-data');
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get security setting details':
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/general-settings/controller/security-setting-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    transaction : transaction
                },
                success: function(response) {
                    if (response.success) {
                        $('#max_failed_login').val(response.maxFailedLogin);
                        $('#max_failed_otp_attempt').val(response.maxFailedOTPAttempt);
                        $('#password_expiry_duration').val(response.passwordExpiryDuration);
                        $('#otp_duration').val(response.otpDuration);
                        $('#reset_password_token_duration').val(response.resetPasswordTokenDuration);
                        $('#session_inactivity_limit').val(response.sessionInactivityLimit);
                        $('#password_recovery_link').val(response.passwordRecoveryLink);
                    } 
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = page_link;
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                }
            });
            break;
    }
}