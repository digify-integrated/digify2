(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('bank options');
        generateDropdownOptions('bank account type options');

        if($('#bank-account-form').length){
            bankAccountForm();
        }

        if($('#bank-card-form').length){
            bankCardForm();
        }

        $(document).on('click','#add-bank-account-details',function() {
            $('#bank-account-title').text('Add Bank Account');
            resetModalForm('bank-account-form');
        });

        $(document).on('click','.edit-bank-account-details',function() {
            const customer_bank_account_id = $(this).data('customer-bank-account-id');
            sessionStorage.setItem('customer_bank_account_id', customer_bank_account_id);

            $('#bank-account-title').text('Edit Bank Account');

            displayDetails('get customer bank account details');
        });

        $(document).on('click','.delete-bank-account-details',function() {
            var customer_id = $('#linked_id').val();
            const customer_bank_account_id = $(this).data('customer-bank-account-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete customer bank account';
    
            Swal.fire({
                title: 'Confirm Bank Account Deletion',
                text: 'Are you sure you want to delete this bank account?',
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
                        url: 'components/customer/controller/customer-controller.php',
                        dataType: 'json',
                        data: {
                            customer_id : customer_id, 
                            customer_bank_account_id : customer_bank_account_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                bankAccountList();
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

        $(document).on('click','#add-bank-card-details',function() {
            $('#bank-card-title').text('Add Bank Account');
            resetModalForm('bank-card-form');
        });

        $(document).on('click','.edit-bank-card-details',function() {
            const customer_bank_card_id = $(this).data('customer-bank-card-id');
            sessionStorage.setItem('customer_bank_card_id', customer_bank_card_id);

            $('#bank-card-title').text('Edit Bank Account');

            displayDetails('get customer bank card details');
        });

        $(document).on('click','.delete-bank-card-details',function() {
            var customer_id = $('#linked_id').val();
            const customer_bank_card_id = $(this).data('customer-bank-card-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete customer bank card';
    
            Swal.fire({
                title: 'Confirm Bank Account Deletion',
                text: 'Are you sure you want to delete this bank card?',
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
                        url: 'components/customer/controller/customer-controller.php',
                        dataType: 'json',
                        data: {
                            customer_id : customer_id, 
                            customer_bank_card_id : customer_bank_card_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                bankCardList();
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

        $(document).on('click','.set-bank-card-as-default',function() {
            var customer_id = $('#linked_id').val();
            const customer_bank_card_id = $(this).data('customer-bank-card-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'set customer bank card as default';
    
            Swal.fire({
                title: 'Confirm Bank Card Tagging As Default',
                text: 'Are you sure you want to tag this bank card as default?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Set To Draft',
                cancelButtonText: 'Cancel',
                customClass: {
                    confirmButton: 'btn btn-success mt-2',
                    cancelButton: 'btn btn-secondary ms-2 mt-2'
                },
                buttonsStyling: !1
            }).then(function(result) {
                if (result.value) {
                    $.ajax({
                        type: 'POST',
                        url: 'components/customer/controller/customer-controller.php',
                        dataType: 'json',
                        data: {
                            customer_id : customer_id, 
                            customer_bank_card_id : customer_bank_card_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                bankCardList();
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

        if($('#bank-account-container').length){
            bankAccountList();
        }

        if($('#bank-card-container').length){
            bankCardList();
        }
    });
})(jQuery);

function bankAccountForm(){
    $('#bank-account-form').validate({
        rules: {
            account_number: {
                required: true
            },
            bank_id: {
                required: true
            },
            bank_account_type_id: {
                required: true
            }
        },
        messages: {
            bank_id: {
                required: 'Choose the bank'
            },
            bank_account_type_id: {
                required: 'Choose the bank account type'
            },
            account_number: {
                required: 'Enter the account number'
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
            var customer_id = $('#linked_id').val();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save customer bank account';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer/controller/customer-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&customer_id=' + customer_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-bank-account-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#bank-account-modal').modal('hide');
                        bankAccountList();
                        resetModalForm('bank-account-form');
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
                    enableFormSubmitButton('submit-bank-account-data');
                }
            });
        
            return false;
        }
    });
}

function bankCardForm(){
    $('#bank-card-form').validate({
        rules: {
            name_on_card: {
                required: true
            },
            card_number: {
                required: true
            },
            expiry_date: {
                required: true
            },
            cvv: {
                required: true
            }
        },
        messages: {
            name_on_card: {
                required: 'Enter the name on the card'
            },
            card_number: {
                required: 'Enter the card number'
            },
            expiry_date: {
                required: 'Enter the card expiry date'
            },
            cvv: {
                required: 'Enter the CVV'
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
            var customer_id = $('#linked_id').val();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save customer bank card';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer/controller/customer-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&customer_id=' + customer_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-bank-card-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#bank-card-modal').modal('hide');
                        bankCardList();
                        resetModalForm('bank-card-form');
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
                    enableFormSubmitButton('submit-bank-card-data');
                }
            });
        
            return false;
        }
    });
}

function bankAccountList(){
    var customer_id = $('#linked_id').val();
    const page_id = $('#page-id').val();
    const type = 'bank account list';

    $.ajax({
        type: 'POST',
        url: 'components/customer/view/_customer_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'customer_id': customer_id },
        beforeSend: function(){
            document.getElementById('bank-account-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('bank-account-container').innerHTML = result[0].BANK_ACCOUNT_LIST;
        }
    });
}

function bankCardList(){
    var customer_id = $('#linked_id').val();
    const page_id = $('#page-id').val();
    const type = 'bank card list';

    $.ajax({
        type: 'POST',
        url: 'components/customer/view/_customer_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'customer_id': customer_id },
        beforeSend: function(){
            document.getElementById('bank-card-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('bank-card-container').innerHTML = result[0].BANK_CARD_LIST;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get customer bank account details':
            var customer_id = $('#linked_id').val()
            var customer_bank_account_id = sessionStorage.getItem('customer_bank_account_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer/controller/customer-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_id : customer_id, 
                    customer_bank_account_id : customer_bank_account_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('bank-account-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#customer_bank_account_id').val(customer_bank_account_id);
                        $('#account_number').val(response.accountNumber);

                        $('#bank_id').val(response.bankID).trigger('change');
                        $('#bank_account_type_id').val(response.bankAccountTypeID).trigger('change');
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
                        else if (response.detailsNotExist) {
                            showNotification(response.title, response.message, response.messageType);
                            $('#bank-account-modal').modal('hide');
                            bankAccountList();
                            resetModalForm('bank-account-form');
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
        case 'bank options':
            
            $.ajax({
                url: 'components/bank/view/_bank_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#bank_id').select2({
                        dropdownParent: $('#bank-account-modal'),
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
        case 'bank account type options':
            
            $.ajax({
                url: 'components/bank-account-type/view/_bank_account_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#bank_account_type_id').select2({
                        dropdownParent: $('#bank-account-modal'),
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