(function ($) {
    'use strict';
  
    $(function () {
        if($('#contact-us-form').length){
            contactUsForm();
        }
    });
})(jQuery);

function contactUsForm(){
    $('#contact-us-form').validate({
        rules: {
            customer_name: {
                required: true
            },
            email: {
                required: true
            },
            phone: {
                required: true
            },
            subject: {
                required: true
            },
            message: {
                required: true
            }
        },
        messages: {
            customer_name: {
                required: 'Enter your name'
            },
            email: {
                required: 'Enter your email'
            },
            phone: {
                required: 'Enter your phone'
            },
            subject: {
                required: 'Enter your subject'
            },
            message: {
                required: 'Enter your message'
            }
        },
        submitHandler: function(form) {
            const transaction = 'add customer inquiry form';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer-inquiry/controller/customer-inquiry-form-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-customer-inquiry');
                },
                success: function (response) {
                    if (response.success) {
                        Swal.fire({
                            title: response.title,
                            text: response.message,
                            icon: 'success'
                        });

                        resetModalForm('contact-us-form');
                    }
                    else {
                        Swal.fire({
                            title: response.title,
                            text: response.message,
                            icon: 'error'
                        });
                    }
                },
                complete: function() {
                    enableFormSubmitButton('submit-customer-inquiry');
                }
            });
        
            return false;
        }
    });
}