(function($) {
    'use strict';

    $(function() {
        displayDetails('get bank account type details');

        if($('#bank-account-type-form').length){
            bankAccountTypeForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get bank account type details');
        });

        $(document).on('click','#delete-bank-account-type',function() {
            const bank_account_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete bank account type';
    
            Swal.fire({
                title: 'Confirm Bank Account Type Deletion',
                text: 'Are you sure you want to delete this bank account type?',
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
                        url: 'components/bank-account-type/controller/bank-account-type-controller.php',
                        dataType: 'json',
                        data: {
                            bank_account_type_id : bank_account_type_id, 
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
            const bank_account_type_id = $('#details-id').text();

            logNotesMain('bank_account_type', bank_account_type_id);
        }

        if($('#internal-notes').length){
            const bank_account_type_id = $('#details-id').text();

            internalNotes('bank_account_type', bank_account_type_id);
        }

        if($('#internal-notes-form').length){
            const bank_account_type_id = $('#details-id').text();

            internalNotesForm('bank_account_type', bank_account_type_id);
        }
    });
})(jQuery);

function bankAccountTypeForm(){
    $('#bank-account-type-form').validate({
        rules: {
            bank_account_type_name: {
                required: true
            }
        },
        messages: {
            bank_account_type_name: {
                required: 'Please enter the display name'
            },
        },
        errorPlacement: function (error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 1500);
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
            const bank_account_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update bank account type';
          
            $.ajax({
                type: 'POST',
                url: 'components/bank-account-type/controller/bank-account-type-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&bank_account_type_id=' + bank_account_type_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get bank account type details');
                        $('#bank-account-type-modal').modal('hide');
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
                    logNotesMain('bank_account_type', bank_account_type_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get bank account type details':
            var bank_account_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/bank-account-type/controller/bank-account-type-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    bank_account_type_id : bank_account_type_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('bank-account-type-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#bank_account_type_name').val(response.bankAccountTypeName);
                        
                        $('#bank_account_type_name_summary').text(response.bankAccountTypeName);
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