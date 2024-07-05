$(document).ready(function () {
    otpForm();
    
    $('.otp-input').on('input', function() {
        var maxLength = parseInt($(this).attr('maxlength'));
        var currentLength = $(this).val().length;

        if (currentLength === maxLength) {
            $(this).next('.otp-input').focus();
        }
    });

    $('.otp-input').on('paste', function(e) {
        e.preventDefault();
        
        var pastedData = (e.originalEvent || e).clipboardData.getData('text/plain');
        
        var filteredData = pastedData.replace(/[^a-zA-Z0-9]/g, '');

        for (var i = 0; i < filteredData.length; i++) {
            if (i < 6) {
                $('#otp_code_' + (i + 1)).val(filteredData.charAt(i));
            }
        }
    });

    $('.otp-input').on('keydown', function(e) {
        if (e.which === 8 && $(this).val().length === 0) {
            $(this).prev('.otp-input').focus();
        }
    });

    $('#resend-link').on('click', function(e) {
        resetCountdown(60);
    });
});

function otpForm(){
    $('#otp-form').validate({
        rules: {
            otp_code_1: {
                required: true,
            },
            otp_code_2: {
                required: true
            },
            otp_code_3: {
                required: true
            },
            otp_code_4: {
                required: true
            },
            otp_code_5: {
                required: true
            },
            otp_code_6: {
                required: true
            }
        },
        messages: {
            otp_code_1: {
                required: 'Please enter your security code',
            },
            otp_code_2: {
                required: 'Please enter your security code'
            },
            otp_code_3: {
                required: 'Please enter your security code'
            },
            otp_code_4: {
                required: 'Please enter your security code'
            },
            otp_code_5: {
                required: 'Please enter your security code'
            },
            otp_code_6: {
                required: 'Please enter your security code'
            }
        },
        errorPlacement: function(error, element) {
            var errorMessage = '';
            $.each(this.errorMap, function(key, value) {
                errorMessage += value;
                if (key!== Object.keys(this.errorMap)[Object.keys(this.errorMap).length - 1]) {
                    errorMessage += '<br>';
                }
            }.bind(this));
            showNotification('Attention Required: Error Found', errorMessage, 'error', 1500);
        },
        highlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection').addClass('is-invalid');
            }
            else {
                inputElement.addClass('is-invalid');
            }
        },
        unhighlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection').removeClass('is-invalid');
            }
            else {
                inputElement.removeClass('is-invalid');
            }
        },
        submitHandler: function(form) {
            const transaction = 'otp verification';
    
            $.ajax({
                type: 'POST',
                url: 'components/authentication/controller/authentication-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('verify');
                },
                success: function(response) {
                    if (response.success) {
                        window.location.href = response.redirectLink;
                    } 
                    else {
                        if(response.otpMaxFailedAttempt || response.incorrectOTPCode || response.expiredOTP){
                            showNotification(response.title, response.message, response.messageType);
                        }
                        else{
                            setNotification(response.title, response.message, response.messageType);
                            window.location.href = 'index.php';
                        }
                    }
                },
                error: function(xhr, status, error) {
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('verify');
                }
            });
    
            return false;
        }
    });
}

function startCountdown(countdownValue) {
    $('#countdown').removeClass('d-none');
    $('#resend-link').addClass('d-none');

    countdownTimer = setInterval(function () {
        document.getElementById('timer').innerHTML = countdownValue;
        countdownValue--;

        if (countdownValue < 0) {
            clearInterval(countdownTimer);
            $('#countdown').addClass('d-none');
            $('#resend-link').removeClass('d-none');
        }
    }, 1000);
}

function resetCountdown(countdownValue) {
    const user_id = $('#user_id').val();
    const transaction = 'resend otp';

    $.ajax({
        type: 'POST',
        url: 'components/authentication/controller/authentication-controller.php',
        dataType: 'json',
        data: {
            user_id : user_id, 
            transaction : transaction
        },
        beforeSend: function() {
            $('#countdown').removeClass('d-none');
            $('#resend-link').addClass('d-none');

            document.getElementById('timer').innerHTML = countdownValue;

            startCountdown(countdownValue);
        },
        success: function (response) {
            if (!response.success) {
                window.location.href = 'index.php';
                setNotification(response.title, response.message, response.messageType);
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
}