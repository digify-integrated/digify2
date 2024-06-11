$(document).ready(function () {  
    $('#signin-form').validate({
        rules: {
            email: {
                required: true,
            },
            password: {
                required: true
            }
        },
        messages: {
            email: {
                required: 'Please enter your email',
            },
            password: {
                required: 'Please enter your password'
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
            const transaction = 'authenticate';
    
            $.ajax({
                type: 'POST',
                url: 'components/authentication/controller/authentication-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('signin');
                },
                success: function(response) {
                    if (response.success) {
                        window.location.href = response.redirectLink;
                    } 
                    else {
                        if(response.passwordExpired){
                            setNotification(response.title, response.message, response.messageType);
                            window.location.href = response.redirectLink;
                        }
                        else{
                            showNotification(response.title, response.message, response.messageType);
                            enableFormSubmitButton('signin');
                        }
                    }
                },
                error: function(xhr, status, error) {
                    handleSystemError(xhr, status, error);
                    enableFormSubmitButton('signin');
                }
            });
    
            return false;
        }
    });
});