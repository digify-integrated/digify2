(function($) {
    'use strict';

    $(function() {
        displayDetails('get currency details');

        if($('#currency-form').length){
            currencyForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get currency details');
        });

        $(document).on('click','#delete-currency',function() {
            const currency_id = $('#currency-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete currency';
    
            Swal.fire({
                title: 'Confirm Currency Deletion',
                text: 'Are you sure you want to delete this currency?',
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
                        url: 'components/currency/controller/currency-controller.php',
                        dataType: 'json',
                        data: {
                            currency_id : currency_id, 
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

        if($('#log-notes-offcanvas').length && $('#view-log-notes').length){
            $(document).on('click','#view-log-notes',function() {
                const currency_id = $('#currency-id').text();

                logNotes('currency', currency_id);
            });
        }

        if($('#internal-notes').length){
            const currency_id = $('#currency-id').text();

            internalNotes('currency', currency_id);
        }

        if($('#internal-notes-form').length){
            const currency_id = $('#currency-id').text();

            internalNotesForm('currency', currency_id);
        }
    });
})(jQuery);

function currencyForm(){
    $('#currency-form').validate({
        rules: {
            currency_name: {
                required: true
            },
            currency_symbol: {
                required: true
            }
        },
        messages: {
            currency_name: {
                required: 'Please enter the display name'
            },
            currency_symbol: {
                required: 'Please enter the symbol'
            }
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
            const currency_id = $('#currency-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update currency';
          
            $.ajax({
                type: 'POST',
                url: 'components/currency/controller/currency-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&currency_id=' + currency_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get currency details');
                        $('#currency-modal').modal('hide');
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
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get currency details':
            var currency_id = $('#currency-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/currency/controller/currency-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    currency_id : currency_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('currency-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#currency_name').val(response.currencyName);
                        $('#currency_symbol').val(response.currencySymbol);
                        
                        $('#currency_name_summary').text(response.currencyName);
                        $('#currency_symbol_summary').text(response.currencySymbol);
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