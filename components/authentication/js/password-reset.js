$(document).ready(function () {  
    $('#password-reset-form').validate({
        rules: {
            new_password: {
                required: true,
                password_strength: true
            },
            confirm_password: {
                required: true,
                equalTo: '#new_password'
            }
          },
        messages: {
            new_password: {
                required: 'Password'
            },
            confirm_password: {
                required: 'Confirm Password',
                equalTo: 'The passwords you entered do not match'
            }
        },
        errorPlacement: function(error, element) {
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul style="margin-bottom: 0px;">' + errorList.join('') + '</ul>', 'error', 1500);
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
            const transaction = 'password reset';
    
            $.ajax({
                type: 'POST',
                url: 'components/authentication/controller/authentication-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('reset');
                },
                success: function(response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        
                        window.location.href = 'index.php';
                    } 
                    else {
                        if (response.passwordExist) {
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
                    enableFormSubmitButton('reset');
                }
            });
    
            return false;
        }
    });
});