(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('city options');
        generateDropdownOptions('currency options');
        displayDetails('get company details');

        if($('#company-form').length){
            companyForm();
        }

        if($('#company-logo-form').length){
            updateCompanyLogoForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get company details');
        });

        $(document).on('click','#delete-company',function() {
            const company_id = $('#company-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete company';
    
            Swal.fire({
                title: 'Confirm Company Deletion',
                text: 'Are you sure you want to delete this company?',
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
                        url: 'components/company/controller/company-controller.php',
                        dataType: 'json',
                        data: {
                            company_id : company_id, 
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
                const company_id = $('#company-id').text();

                logNotes('company', company_id);
            });
        }

        if($('#internal-notes').length){
            const company_id = $('#company-id').text();

            internalNotes('company', company_id);
        }

        if($('#internal-notes-form').length){
            const company_id = $('#company-id').text();

            internalNotesForm('company', company_id);
        }
    });
})(jQuery);

function companyForm(){
    $('#company-form').validate({
        rules: {
            company_name: {
                required: true
            },
            legal_name: {
                required: true
            },
            address: {
                required: true
            },
            city_id: {
                required: true
            },
            currency_id: {
                required: true
            }
        },
        messages: {
            company_name: {
                required: 'Please enter the display name'
            },
            legal_name: {
                required: 'Please enter the legal name'
            },
            address: {
                required: 'Please enter the address'
            },
            city_id: {
                required: 'Please choose the city'
            },
            currency_id: {
                required: 'Please choose the currency'
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
            const company_id = $('#company-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update company';
          
            $.ajax({
                type: 'POST',
                url: 'components/company/controller/company-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&company_id=' + company_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get company details');
                        $('#company-modal').modal('hide');
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

function updateCompanyLogoForm(){
    $('#company-logo-form').validate({
        rules: {
            company_logo: {
                required: true
            }
        },
        messages: {
            company_logo: {
                required: 'Please choose the company logo'
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
            const company_id = $('#company-id').text();
            const transaction = 'update company logo';
            var formData = new FormData(form);
            formData.append('company_id', company_id);
            formData.append('transaction', transaction);
        
            $.ajax({
                type: 'POST',
                url: 'components/company/controller/company-controller.php',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-company-logo');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get company details');
                        $('#company-logo-modal').modal('hide');
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
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('submit-company-logo');
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get company details':
            var company_id = $('#company-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/company/controller/company-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    company_id : company_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('company-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#company_name').val(response.companyName);
                        $('#legal_name').val(response.legalName);
                        $('#address').val(response.address);
                        $('#tax_id').val(response.taxID);
                        $('#phone').val(response.phone);
                        $('#mobile').val(response.mobile);
                        $('#email').val(response.email);
                        $('#website').val(response.website);
                        
                        $('#city_id').val(response.cityID).trigger('change');
                        $('#currency_id').val(response.currencyID).trigger('change');

                        document.getElementById('company_logo').src = response.companyLogo;
                        
                        $('#company_name_summary').text(response.companyName);
                        $('#legal_name_summary').text(response.legalName);
                        $('#address_summary').text(response.address);
                        $('#city_name_summary').text(response.cityName);
                        $('#currency_name_summary').text(response.currencyName + ' (' + response.currencySymbol + ')');
                        $('#tax_id_summary').text(response.taxID);
                        $('#phone_summary').text(response.phone);
                        $('#mobile_summary').text(response.mobile);
                        $('#email_summary').text(response.email);
                        $('#website_summary').text(response.website);
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
                        dropdownParent: $('#company-modal'),
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
        case 'currency options':
            
            $.ajax({
                url: 'components/currency/view/_currency_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#currency_id').select2({
                        dropdownParent: $('#company-modal'),
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