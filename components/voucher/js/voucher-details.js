(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('block style options');

        displayDetails('get voucher details');

        if($('#voucher-form').length){
            voucherForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get voucher details');
        });

        $(document).on('click','#delete-voucher',function() {
            const voucher_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete voucher';
    
            Swal.fire({
                title: 'Confirm Voucher Deletion',
                text: 'Are you sure you want to delete this voucher?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Delete',
                cancelButtonText: 'Cancel',
                customClass: {
                    confirmButton: 'btn btn-danger mt-2',
                    cancelButton: 'btn btn-secondary ms-2 mt-2'
                },
                buttonsStyling: !1
            }).then(function(result) {
                if (result.value) {
                    $.ajax({
                        type: 'POST',
                        url: 'components/voucher/controller/voucher-controller.php',
                        dataType: 'json',
                        data: {
                            voucher_id : voucher_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location = page_link;
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
                    return false;
                }
            });
        });

        if($('#log-notes-main').length){
            const voucher_id = $('#details-id').text();

            logNotesMain('voucher', voucher_id);
        }

        if($('#internal-notes').length){
            const voucher_id = $('#details-id').text();

            internalNotes('voucher', voucher_id);
        }

        if($('#internal-notes-form').length){
            const voucher_id = $('#details-id').text();

            internalNotesForm('voucher', voucher_id);
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
            },
            available_voucher: {
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
            },
            available_voucher: {
                required: 'Enter the available voucher'
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
            const voucher_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update voucher';
          
            $.ajax({
                type: 'POST',
                url: 'components/voucher/controller/voucher-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&voucher_id=' + voucher_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get voucher details');
                        $('#voucher-modal').modal('hide');
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
                },
                complete: function() {
                    enableFormSubmitButton('submit-data');
                    logNotesMain('voucher', voucher_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get voucher details':
            var voucher_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/voucher/controller/voucher-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    voucher_id : voucher_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('voucher-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#voucher_name').val(response.voucherName);
                        $('#voucher_code').val(response.voucherCode);
                        $('#voucher_usage_start_date').val(response.voucherUsageStartDate);
                        $('#voucher_usage_end_date').val(response.voucherUsageEndDate);
                        $('#discount_type').val(response.discountType);
                        $('#discount_amount').val(response.discountAmount);
                        $('#minimum_booking_amount').val(response.minimumBookingAmount);
                        $('#voucher_quantity').val(response.voucherQuantity);
                        $('#available_voucher').val(response.availableVoucher);
                        
                        $('#voucher_name_summary').text(response.voucherName);
                        $('#voucher_code_summary').text(response.voucherCode);
                        $('#voucher_usage_start_date_summary').text(response.voucherUsageStartDateSummary);
                        $('#voucher_usage_end_date_summary').text(response.voucherUsageEndDateSummary);
                        $('#discount_type_summary').text(response.discountType);
                        $('#discount_amount_summary').text(response.discountAmountSummary);
                        $('#minimum_booking_amount_summary').text(response.minimumBookingAmountSummary);
                        $('#voucher_quantity_summary').text(response.voucherQuantitySummary);
                        $('#available_voucher_summary').text(response.availableVoucherSummary);
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
                        dropdownParent: $('#voucher-modal'),
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