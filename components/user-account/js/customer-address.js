(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('address type options');
        generateDropdownOptions('city options');

        if($('#address-form').length){
            addressForm();
        }

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
            var customer_id = $('#linked_id').val();
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
            var customer_id = $('#linked_id').val();
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

        if($('#address-container').length){
            addressList();
        }
    });
})(jQuery);

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
            var customer_id = $('#linked_id').val();
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

function addressList(){
    const page_id = $('#page-id').val();
    const type = 'customer address list';

    $.ajax({
        type: 'POST',
        url: 'components/user-account/view/_user_account_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id },
        beforeSend: function(){
            document.getElementById('address-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('address-container').innerHTML = result[0].ADDRESS_LIST;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get customer address details':
            var customer_id = $('#linked_id').val();
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
    }
}

function generateDropdownOptions(type){
    switch (type) {
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
    }
}