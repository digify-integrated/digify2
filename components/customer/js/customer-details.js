(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('gender options');
        generateDropdownOptions('civil status options');
        generateDropdownOptions('address type options');
        generateDropdownOptions('city options');
        generateDropdownOptions('id type options');
        
        displayDetails('get about details');
        displayDetails('get customer image details');
        displayDetails('get private information details');

        if($('#about-form').length){
            aboutForm();
        }

        if($('#private-information-form').length){
            privateInformationForm();
        }

        if($('#address-form').length){
            addressForm();
        }

        if($('#id-record-form').length){
            idRecordForm();
        }

        $(document).on('click','#archive-customer',function() {
            const customer_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'archive customer';
    
            Swal.fire({
                title: 'Confirm Customer Archive',
                text: 'Are you sure you want to archive this customer?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Archive',
                cancelButtonText: 'Cancel',
                customClass: {
                    confirmButton: 'btn btn-warning mt-2',
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
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location.reload();
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

        $(document).on('click','#unarchive-customer',function() {
            const customer_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'unarchive customer';
    
            Swal.fire({
                title: 'Confirm Customer Unarchive',
                text: 'Are you sure you want to unarchive this customer?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Unarchive',
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
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location.reload();
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

        $(document).on('click','#edit-about-details',function() {
            displayDetails('get about details');
        });

        $(document).on('click','#edit-private-information-details',function() {
            displayDetails('get private information details');
        });

        $(document).on('click','#add-address-details',function() {
            $('#address-title').text('Add Address');
            resetModalForm('address-form');
        });

        $(document).on('click','.edit-address-details',function() {
            const customer_address_id = $(this).data('customer-address-id');
            sessionStorage.setItem('customer_address_id', customer_address_id);

            $('#address-title').text('Edit Address');

            displayDetails('get customer address details');
        });

        $(document).on('click','.set-address-as-default',function() {
            const customer_id = $('#details-id').text();
            const customer_address_id = $(this).data('customer-address-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'set customer address as default';
    
            Swal.fire({
                title: 'Confirm Address Tagging As Default',
                text: 'Are you sure you want to tag this address as default?',
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
                            customer_address_id : customer_address_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                addressList();
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

        $(document).on('click','.delete-address-details',function() {
            const customer_id = $('#details-id').text();
            const customer_address_id = $(this).data('customer-address-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete customer address';
    
            Swal.fire({
                title: 'Confirm Address Deletion',
                text: 'Are you sure you want to delete this address?',
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
                            customer_address_id : customer_address_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                addressList();
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

        $(document).on('click','#add-id-record-details',function() {
            $('#id-record-title').text('Add ID Record');
            resetModalForm('id-record-form');
        });

        $(document).on('click','.edit-id-record-details',function() {
            const customer_id_record_id = $(this).data('customer-id-record-id');
            sessionStorage.setItem('customer_id_record_id', customer_id_record_id);

            $('#id-record-title').text('Edit ID Record');

            displayDetails('get customer id record details');
        });

        $(document).on('click','.edit-id-record-image-details',function() {
            const customer_id_record_id = $(this).data('customer-id-record-id');
            sessionStorage.setItem('customer_id_record_id', customer_id_record_id);
        });

        $(document).on('change','#id_image',function() {
            const transaction = 'update customer id record image';
            const customer_id = $('#details-id').text();
            var customer_id_record_id = sessionStorage.getItem('customer_id_record_id');
            var formData = new FormData();
            formData.append('id_image', $(this)[0].files[0]);
            formData.append('transaction', transaction);
            formData.append('customer_id', customer_id);
            formData.append('customer_id_record_id', customer_id_record_id);

            $.ajax({
                type: 'POST',
                url: 'components/customer/controller/customer-controller.php',
                dataType: 'json',
                data: formData,
                contentType: false,
                processData: false,
                success: function(response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        idRecordList();
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
        });

        $(document).on('click','.delete-id-record-details',function() {
            const customer_id = $('#details-id').text();
            const customer_id_record_id = $(this).data('customer-id-record-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete customer id record';
    
            Swal.fire({
                title: 'Confirm ID Record Deletion',
                text: 'Are you sure you want to delete this ID record?',
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
                            customer_id_record_id : customer_id_record_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                idRecordList();
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

        $(document).on('click','#delete-customer',function() {
            const customer_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete customer';
    
            Swal.fire({
                title: 'Confirm Customer Deletion',
                text: 'Are you sure you want to delete this customer?',
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

        $(document).on('change','#customer_image',function() {
            if ($(this).val() !== '' && $(this)[0].files.length > 0) {
                const transaction = 'update customer image';
                const customer_id = $('#details-id').text();
                var formData = new FormData();
                formData.append('customer_image', $(this)[0].files[0]);
                formData.append('transaction', transaction);
                formData.append('customer_id', customer_id);
        
                $.ajax({
                    type: 'POST',
                    url: 'components/customer/controller/customer-controller.php',
                    dataType: 'json',
                    data: formData,
                    contentType: false,
                    processData: false,
                    success: function(response) {
                        if (response.success) {
                            showNotification(response.title, response.message, response.messageType);
                            displayDetails('get customer image details');
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
            }
        });

        if($('#address-container').length){
            addressList();
        }

        if($('#bank-account-container').length){
            bankAccountList();
        }

        if($('#bank-card-container').length){
            bankCardList();
        }

        if($('#id-record-container').length){
            idRecordList();
        }

        if($('#log-notes-offcanvas').length){
            $(document).on('click','.view-customer-address-log-notes',function() {
                const customer_address_id = $(this).data('customer-address-id');

                logNotes('customer_address', customer_address_id);
            });

            $(document).on('click','.view-customer-bank-account-log-notes',function() {
                const customer_bank_account_id = $(this).data('customer-bank-account-id');

                logNotes('customer_bank_account', customer_bank_account_id);
            });

            $(document).on('click','.view-customer-bank-card-log-notes',function() {
                const customer_bank_card_id = $(this).data('customer-bank-card-id');

                logNotes('customer_bank_card', customer_bank_card_id);
            });

            $(document).on('click','.view-customer-id-record-log-notes',function() {
                const customer_id_record_id = $(this).data('customer-id-record-id');

                logNotes('customer_id_record', customer_id_record_id);
            });
        }

        if($('#log-notes-main').length){
            const customer_id = $('#details-id').text();

            logNotesMain('customer', customer_id);
        }

        if($('#internal-notes').length){
            const customer_id = $('#details-id').text();

            internalNotes('customer', customer_id);
        }

        if($('#internal-notes-form').length){
            const customer_id = $('#details-id').text();

            internalNotesForm('customer', customer_id);
        }
    });
})(jQuery);

function aboutForm(){
    $('#about-form').validate({
        rules: {
            about: {
                required: true
            }
        },
        messages: {
            about: {
                required: 'Enter the about'
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
            const customer_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update customer about';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer/controller/customer-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&customer_id=' + customer_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-about-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get about details');
                        $('#about-modal').modal('hide');
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
                    enableFormSubmitButton('submit-about-data');
                    logNotesMain('customer', customer_id);
                }
            });
        
            return false;
        }
    });
}

function privateInformationForm(){
    $('#private-information-form').validate({
        rules: {
            first_name: {
                required: true
            },
            last_name: {
                required: true
            },
            gender_id: {
                required: true
            },
            civil_status_id: {
                required: true
            },
            birthday: {
                required: true
            },
            birth_place: {
                required: true
            }
        },
        messages: {
            first_name: {
                required: 'Enter the first name'
            },
            last_name: {
                required: 'Enter the last name'
            },
            gender_id: {
                required: 'Choose the gender'
            },
            civil_status_id: {
                required: 'Choose the civil status'
            },
            birthday: {
                required: 'Enter the birthday'
            },
            birth_place: {
                required: 'Enter the birth place'
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
            const customer_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update customer private information';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer/controller/customer-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&customer_id=' + customer_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-private-information-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get private information details');
                        $('#private-information-modal').modal('hide');
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
                    enableFormSubmitButton('submit-private-information-data');
                    logNotesMain('customer', customer_id);
                }
            });
        
            return false;
        }
    });
}

function addressForm(){
    $('#address-form').validate({
        rules: {
            address_type_id: {
                required: true
            },
            city_id: {
                required: true
            },
            address: {
                required: true
            },
            customer_address_mobile: {
                required: true
            }
        },
        messages: {
            address_type_id: {
                required: 'Choose the address type'
            },
            city_id: {
                required: 'Choose the city'
            },
            address: {
                required: 'Enter the address'
            },
            customer_address_mobile: {
                required: 'Enter the mobile'
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
            const customer_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save customer address';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer/controller/customer-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&customer_id=' + customer_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-address-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#address-modal').modal('hide');
                        addressList();
                        resetModalForm('address-form');
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
                    enableFormSubmitButton('submit-address-data');
                }
            });
        
            return false;
        }
    });
}

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
            const customer_id = $('#details-id').text();
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
            const customer_id = $('#details-id').text();
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

function idRecordForm(){
    $('#id-record-form').validate({
        rules: {
            id_type_id: {
                required: true
            },
            id_number: {
                required: true
            },
            id_issue_date: {
                required: true
            }
        },
        messages: {
            id_type_id: {
                required: 'Choose the ID type'
            },
            id_number: {
                required: 'Enter the ID number'
            },
            id_issue_date: {
                required: 'Enter the issue date'
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
            const customer_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save customer id record';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer/controller/customer-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&customer_id=' + customer_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-id-record-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#id-record-modal').modal('hide');
                        idRecordList();
                        resetModalForm('id-record-form');
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
                    enableFormSubmitButton('submit-id-record-data');
                }
            });
        
            return false;
        }
    });
}

function addressList(){
    const customer_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'address list';

    $.ajax({
        type: 'POST',
        url: 'components/customer/view/_customer_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'customer_id': customer_id },
        beforeSend: function(){
            document.getElementById('address-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('address-container').innerHTML = result[0].ADDRESS_LIST;
        }
    });
}

function bankAccountList(){
    const customer_id = $('#details-id').text();
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
    const customer_id = $('#details-id').text();
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

function idRecordList(){
    const customer_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'id record list';

    $.ajax({
        type: 'POST',
        url: 'components/customer/view/_customer_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'customer_id': customer_id },
        beforeSend: function(){
            document.getElementById('id-record-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('id-record-container').innerHTML = result[0].ID_RECORD_LIST;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get about details':
            var customer_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer/controller/customer-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_id : customer_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('about-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#about').val(response.about);

                        $('#about_summary').text(response.about);
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
        case 'get customer image details':
            var customer_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer/controller/customer-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_id : customer_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('about-form');
                },
                success: function(response) {
                    if (response.success) {
                        document.getElementById('customer-image').src = response.customerImage;
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
        case 'get private information details':
            var customer_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer/controller/customer-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_id : customer_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('private-information-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#first_name').val(response.firstName);
                        $('#middle_name').val(response.middleName);
                        $('#nickname').val(response.nickname);
                        $('#birthday').val(response.birthday);
                        $('#birth_place').val(response.birthPlace);
                        $('#last_name').val(response.lastName);
                        $('#suffix').val(response.suffix);

                        $('#gender_id').val(response.genderID).trigger('change');
                        $('#civil_status_id').val(response.civilStatusID).trigger('change');

                        $('#customer_full_name_summary').text(response.fullName);
                        $('#nickname_summary').text(response.nickname);
                        $('#civil_status_summary').text(response.civilStatusName);
                        $('#place_of_birth_summary').text(response.birthPlace);
                        $('#date_of_birth_summary').text(response.birthdaySummary);
                        $('#gender_summary').text(response.genderName);
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
        case 'get customer address details':
            var customer_id = $('#details-id').text();
            var customer_address_id = sessionStorage.getItem('customer_address_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer/controller/customer-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_id : customer_id, 
                    customer_address_id : customer_address_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('address-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#customer_address_id').val(customer_address_id);
                        $('#address').val(response.address);
                        $('#customer_address_mobile').val(response.mobile);
                        $('#customer_address_telephone').val(response.telephone);
                        $('#contact_information_email').val(response.email);

                        $('#address_type_id').val(response.addressTypeID).trigger('change');
                        $('#city_id').val(response.cityID).trigger('change');
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
                            $('#address-modal').modal('hide');
                            addressList();
                            resetModalForm('address-form');
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
        case 'get customer bank account details':
            var customer_id = $('#details-id').text();
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
        case 'get customer bank card details':
            var customer_id = $('#details-id').text();
            var customer_bank_card_id = sessionStorage.getItem('customer_bank_card_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer/controller/customer-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_id : customer_id, 
                    customer_bank_card_id : customer_bank_card_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('bank-card-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#customer_bank_card_id').val(customer_bank_card_id);
                        $('#account_number').val(response.accountNumber);

                        $('#bank_id').val(response.bankID).trigger('change');
                        $('#bank_card_type_id').val(response.bankCardTypeID).trigger('change');
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
                            $('#bank-card-modal').modal('hide');
                            bankCardList();
                            resetModalForm('bank-card-form');
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
        case 'get customer id record details':
            var customer_id = $('#details-id').text();
            var customer_id_record_id = sessionStorage.getItem('customer_id_record_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer/controller/customer-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_id : customer_id, 
                    customer_id_record_id : customer_id_record_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('id-record-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#customer_id_record_id').val(customer_id_record_id);
                        $('#id_number').val(response.idNumber);
                        $('#id_issue_date').val(response.issueDate);
                        $('#id_expiration_date').val(response.expirationDate);
                        $('#issuing_authority').val(response.issuingAuthority);

                        $('#id_type_id').val(response.idTypeID).trigger('change');
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
                            $('#id-record-modal').modal('hide');
                            idRecordList();
                            resetModalForm('id-record-form');
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
        case 'gender options':
            
            $.ajax({
                url: 'components/gender/view/_gender_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#gender_id').select2({
                        dropdownParent: $('#private-information-modal'),
                        data: response
                    }).on('change', function (e) {
                        $(this).valid();
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
        case 'civil status options':
            
            $.ajax({
                url: 'components/civil-status/view/_civil_status_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#civil_status_id').select2({
                        dropdownParent: $('#private-information-modal'),
                        data: response
                    }).on('change', function (e) {
                        $(this).valid();
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
        case 'address type options':
            
            $.ajax({
                url: 'components/address-type/view/_address_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#address_type_id').select2({
                        dropdownParent: $('#address-modal'),
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
        case 'city options':
            
            $.ajax({
                url: 'components/city/view/_city_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#city_id').select2({
                        dropdownParent: $('#address-modal'),
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
        
        case 'id type options':
            
            $.ajax({
                url: 'components/id-type/view/_id_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#id_type_id').select2({
                        dropdownParent: $('#id-record-modal'),
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