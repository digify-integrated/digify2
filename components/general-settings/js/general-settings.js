(function($) {
    'use strict';

    $(function() {
        if($('#security-settings-form').length){
            securitySettingsForm();
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
            const transaction = 'add menu group';
            const page_link = document.getElementById('page-link').getAttribute('href');
          
            $.ajax({
                type: 'POST',
                url: 'components/security-settings/controller/security-settings-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        window.location = page_link + '&id=' + response.securitySettingsID;
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