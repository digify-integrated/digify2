(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('block style options');

        if($('#voucher-form').length){
            voucherForm();
        }
    });
})(jQuery);

function voucherForm(){
    $('#voucher-form').validate({
        rules: {
            voucher_name: {
                required: true
            },
            voucher_code: {
                required: true
            },
            voucher_usage_start_date: {
                required: true
            },
            voucher_usage_end_date: {
                required: true
            },
            discount_type: {
                required: true
            },
            discount_amount: {
                required: true
            },
            minimum_booking_amount: {
                required: true
            },
            voucher_quantity: {
                required: true
            }
        },
        messages: {
            voucher_name: {
                required: 'Enter the display name'
            },
            voucher_code: {
                required: 'Enter the voucher code'
            },
            voucher_usage_start_date: {
                required: 'Choose the voucher usage start date'
            },
            voucher_usage_end_date: {
                required: 'Choose the voucher usage end date'
            },
            discount_type: {
                required: 'Choose the discount type'
            },
            discount_amount: {
                required: 'Enter the discount amount'
            },
            minimum_booking_amount: {
                required: 'Enter the minimum booking amount'
            },
            voucher_quantity: {
                required: 'Enter the voucher quantity'
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
            const transaction = 'add voucher';
            const page_link = document.getElementById('page-link').getAttribute('href');
          
            $.ajax({
                type: 'POST',
                url: 'components/voucher/controller/voucher-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        window.location = page_link + '&id=' + response.voucherID;
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

function generateDropdownOptions(type){
    switch (type) {
        case 'block style options':
            var block_type_id = '7';
            
            $.ajax({
                url: 'components/block-style/view/_block_style_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    block_type_id : block_type_id
                },
                success: function(response) {
                    $('#block_style_id').select2({
                        data: response
                    }).on('change', function (e) {
                        $(this).valid()
                    });
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