$(document).ready(function () {  
    $('#signup-form').validate({
        rules: {
            first_name: {
                required: true,
            },
            last_name: {
                required: true,
            },
            username: {
                required: true,
            },
            email: {
                required: true,
            },
            password: {
                required: true,
                password_strength: true
            },
            confirm_password: {
                required: true,
                equalTo: '#password'
            }
        },
        messages: {
            first_name: {
                required: 'Enter the first name',
            },
            last_name: {
                required: 'Enter the last name',
            },
            username: {
                required: 'Enter the username',
            },
            email: {
                required: 'Enter the email',
            },
            password: {
                required: 'Enter the password'
            },
            confirm_password: {
                required: 'Enter the confirm password',
                equalTo: 'The passwords you entered do not match'
            }
        },
        errorPlacement: function(error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 2000);
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
            const transaction = 'user account sign up';
    
            $.ajax({
                type: 'POST',
                url: 'components/authentication/controller/authentication-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('sign-up');
                },
                success: function(response) {
                    if (response.success) {                        
                        window.location.href = 'registration-success.php';
                    } 
                    else {
                        showNotification(response.title, response.message, response.messageType);
                    }
                },
                error: function(xhr, status, error) {
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('sign-up');
                }
            });
    
            return false;
        }
    });
});