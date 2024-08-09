(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('department options');
        generateDropdownOptions('job position options');
        generateDropdownOptions('company options');
        generateDropdownOptions('work location options');
        generateDropdownOptions('work schedule options');
        generateDropdownOptions('gender options');
        generateDropdownOptions('civil status options');
        generateDropdownOptions('blood type options');
        generateDropdownOptions('religion options');
        generateDropdownOptions('employment type options');
        generateDropdownOptions('employment location type options');
        generateDropdownOptions('active user account options');
        generateDropdownOptions('address type options');
        generateDropdownOptions('city options');
        generateDropdownOptions('bank options');
        generateDropdownOptions('bank account type options');
        generateDropdownOptions('contact information type options');
        
        displayDetails('get about details');
        displayDetails('get private information details');
        displayDetails('get work information details');
        displayDetails('get hr settings details');
        displayDetails('get work permit details');

        if($('#about-form').length){
            aboutForm();
        }

        if($('#private-information-form').length){
            privateInformationForm();
        }

        if($('#work-information-form').length){
            workInformationForm();
        }

        if($('#hr-settings-form').length){
            hrSettingsForm();
        }

        if($('#work-permit-form').length){
            workPermitForm();
        }

        if($('#experience-form').length){
            experienceForm();
        }

        if($('#education-form').length){
            educationForm();
        }

        if($('#address-form').length){
            addressForm();
        }

        if($('#bank-account-form').length){
            bankAccountForm();
        }

        if($('#contact-information-form').length){
            contactInformationForm();
        }

        $(document).on('click','#edit-about-details',function() {
            displayDetails('get about details');
        });

        $(document).on('click','#edit-private-information-details',function() {
            displayDetails('get private information details');
        });

        $(document).on('click','#edit-work-information-details',function() {
            displayDetails('get work information details');
        });

        $(document).on('click','#edit-hr-settings-details',function() {
            displayDetails('get hr settings details');
        });

        $(document).on('click','#edit-work-permit-details',function() {
            displayDetails('get work permit details');
        });

        $(document).on('click','#add-experience-details',function() {
            $('#experience-title').text('Add Experience');
            resetModalForm('experience-form');
        });

        $(document).on('click','.edit-experience-details',function() {
            const employee_experience_id = $(this).data('employee-experience-id');
            sessionStorage.setItem('employee_experience_id', employee_experience_id);

            $('#experience-title').text('Edit Experience');

            displayDetails('get employee experience details');
        });

        $(document).on('click','.delete-experience-details',function() {
            const employee_id = $('#details-id').text();
            const employee_experience_id = $(this).data('employee-experience-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete employee experience';
    
            Swal.fire({
                title: 'Confirm Experience Deletion',
                text: 'Are you sure you want to delete this experience?',
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
                        url: 'components/employee/controller/employee-controller.php',
                        dataType: 'json',
                        data: {
                            employee_id : employee_id, 
                            employee_experience_id : employee_experience_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                experienceList();
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

        $(document).on('click','#add-education-details',function() {
            $('#education-title').text('Add Education');
            resetModalForm('education-form');
        });

        $(document).on('click','.edit-education-details',function() {
            const employee_education_id = $(this).data('employee-education-id');
            sessionStorage.setItem('employee_education_id', employee_education_id);

            $('#education-title').text('Edit Education');

            displayDetails('get employee education details');
        });

        $(document).on('click','.delete-education-details',function() {
            const employee_id = $('#details-id').text();
            const employee_education_id = $(this).data('employee-education-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete employee education';
    
            Swal.fire({
                title: 'Confirm Education Deletion',
                text: 'Are you sure you want to delete this education?',
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
                        url: 'components/employee/controller/employee-controller.php',
                        dataType: 'json',
                        data: {
                            employee_id : employee_id, 
                            employee_education_id : employee_education_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                educationList();
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

        $(document).on('click','#add-address-details',function() {
            $('#address-title').text('Add Address');
            resetModalForm('address-form');
        });

        $(document).on('click','.edit-address-details',function() {
            const employee_address_id = $(this).data('employee-address-id');
            sessionStorage.setItem('employee_address_id', employee_address_id);

            $('#address-title').text('Edit Address');

            displayDetails('get employee address details');
        });

        $(document).on('click','.delete-address-details',function() {
            const employee_id = $('#details-id').text();
            const employee_address_id = $(this).data('employee-address-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete employee address';
    
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
                        url: 'components/employee/controller/employee-controller.php',
                        dataType: 'json',
                        data: {
                            employee_id : employee_id, 
                            employee_address_id : employee_address_id, 
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

        $(document).on('click','#add-bank-account-details',function() {
            $('#bank-account-title').text('Add Bank Account');
            resetModalForm('bank-account-form');
        });

        $(document).on('click','.edit-bank-account-details',function() {
            const employee_bank_account_id = $(this).data('employee-bank-account-id');
            sessionStorage.setItem('employee_bank_account_id', employee_bank_account_id);

            $('#bank-account-title').text('Edit Bank Account');

            displayDetails('get employee bank account details');
        });

        $(document).on('click','.delete-bank-account-details',function() {
            const employee_id = $('#details-id').text();
            const employee_bank_account_id = $(this).data('employee-bank-account-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete employee bank account';
    
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
                        url: 'components/employee/controller/employee-controller.php',
                        dataType: 'json',
                        data: {
                            employee_id : employee_id, 
                            employee_bank_account_id : employee_bank_account_id, 
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

        $(document).on('click','#add-contact-information-details',function() {
            $('#contact-information-title').text('Add Contact Information');
            resetModalForm('contact-information-form');
        });

        $(document).on('click','.edit-contact-information-details',function() {
            const employee_contact_information_id = $(this).data('employee-contact-information-id');
            sessionStorage.setItem('employee_contact_information_id', employee_contact_information_id);

            $('#contact-information-title').text('Edit Contact Information');

            displayDetails('get employee contact information details');
        });

        $(document).on('click','.delete-contact-information-details',function() {
            const employee_id = $('#details-id').text();
            const employee_contact_information_id = $(this).data('employee-contact-information-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete employee contact information';
    
            Swal.fire({
                title: 'Confirm Contact Information Deletion',
                text: 'Are you sure you want to delete this contact information?',
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
                        url: 'components/employee/controller/employee-controller.php',
                        dataType: 'json',
                        data: {
                            employee_id : employee_id, 
                            employee_contact_information_id : employee_contact_information_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                contactInformationList();
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

        $(document).on('click','#add-id-records-details',function() {
            $('#id-records-title').text('Add ID Records');
        });

        $(document).on('click','#add-licenses-details',function() {
            $('#licenses-title').text('Add Licenses');
        });

        $(document).on('click','#add-emergency-contact-details',function() {
            $('#emergency-contact-title').text('Add Emergency Contact');
        });

        $(document).on('click','#add-language-details',function() {
            $('#language-title').text('Add Language');
        });

        $(document).on('click','#delete-employee',function() {
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete employee';
    
            Swal.fire({
                title: 'Confirm Employee Deletion',
                text: 'Are you sure you want to delete this employee?',
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
                        url: 'components/employee/controller/employee-controller.php',
                        dataType: 'json',
                        data: {
                            employee_id : employee_id, 
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

        if($('#experience-container').length){
            experienceList();
        }

        if($('#education-container').length){
            educationList();
        }

        if($('#address-container').length){
            addressList();
        }

        if($('#bank-account-container').length){
            bankAccountList();
        }

        if($('#contact-information-container').length){
            contactInformationList();
        }

        if($('#log-notes-offcanvas').length){
            $(document).on('click','.view-employee-experience-log-notes',function() {
                const employee_experience_id = $(this).data('employee-experience-id');

                logNotes('employee_experience', employee_experience_id);
            });

            $(document).on('click','.view-employee-education-log-notes',function() {
                const employee_education_id = $(this).data('employee-education-id');

                logNotes('employee_education', employee_education_id);
            });

            $(document).on('click','.view-employee-address-log-notes',function() {
                const employee_address_id = $(this).data('employee-address-id');

                logNotes('employee_address', employee_address_id);
            });

            $(document).on('click','.view-employee-bank-account-log-notes',function() {
                const employee_bank_account_id = $(this).data('employee-bank-account-id');

                logNotes('employee_bank_account', employee_bank_account_id);
            });

            $(document).on('click','.view-employee-contact-information-log-notes',function() {
                const employee_contact_information_id = $(this).data('employee-contact-information-id');

                logNotes('employee_contact_information', employee_contact_information_id);
            });
        }

        if($('#log-notes-main').length){
            const employee_id = $('#details-id').text();

            logNotesMain('employee', employee_id);
        }

        if($('#internal-notes').length){
            const employee_id = $('#details-id').text();

            internalNotes('employee', employee_id);
        }

        if($('#internal-notes-form').length){
            const employee_id = $('#details-id').text();

            internalNotesForm('employee', employee_id);
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update employee about';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
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
                    logNotesMain('employee', employee_id);
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update employee private information';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
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
                    logNotesMain('employee', employee_id);
                }
            });
        
            return false;
        }
    });
}

function workInformationForm(){
    $('#work-information-form').validate({
        rules: {
            department_id: {
                required: true
            },
            company_id: {
                required: true
            },
            job_position_id: {
                required: true
            }
        },
        messages: {
            department_id: {
                required: 'Choose the department'
            },
            company_id: {
                required: 'Choose the company'
            },
            job_position_id: {
                required: 'Choose the job position'
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update employee work information';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-work-information-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get work information details');
                        $('#work-information-modal').modal('hide');
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
                    enableFormSubmitButton('submit-work-information-data');
                    logNotesMain('employee', employee_id);
                }
            });
        
            return false;
        }
    });
}

function hrSettingsForm(){
    $('#hr-settings-form').validate({
        rules: {
            onboard_date: {
                required: true
            }
        },
        messages: {
            onboard_date: {
                required: 'Enter the on-board date'
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update employee hr settings';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-hr-settings-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get work information details');
                        $('#hr-settings-modal').modal('hide');
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
                    enableFormSubmitButton('submit-hr-settings-data');
                    logNotesMain('employee', employee_id);
                }
            });
        
            return false;
        }
    });
}

function workPermitForm(){
    $('#work-permit-form').validate({
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update employee work permit';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-work-permit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get work permit details');
                        $('#work-permit-modal').modal('hide');
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
                    enableFormSubmitButton('submit-work-permit-data');
                    logNotesMain('employee', employee_id);
                }
            });
        
            return false;
        }
    });
}

function experienceForm(){
    $('#experience-form').validate({
        rules: {
            job_title: {
                required: true
            },
            company_name: {
                required: true
            },
            start_experience_date_month: {
                required: true
            },
            start_experience_date_year: {
                required: true
            },
            job_description: {
                required: true
            }
        },
        messages: {
            job_title: {
                required: 'Enter the job title'
            },
            company_name: {
                required: 'Enter the company name'
            },
            start_experience_date_month: {
                required: 'Choose the start month'
            },
            start_experience_date_year: {
                required: 'Choose the start year'
            },
            job_description: {
                required: 'Enter the job description'
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save employee experience';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-experience-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#experience-modal').modal('hide');
                        experienceList();
                        resetModalForm('experience-form');
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
                    enableFormSubmitButton('submit-experience-data');
                }
            });
        
            return false;
        }
    });
}

function educationForm(){
    $('#education-form').validate({
        rules: {
            school: {
                required: true
            },
            start_education_date_month: {
                required: true
            },
            start_education_date_year: {
                required: true
            }
        },
        messages: {
            school: {
                required: 'Enter the school'
            },
            start_education_date_month: {
                required: 'Choose the start month'
            },
            start_education_date_year: {
                required: 'Choose the start year'
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save employee education';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-education-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#education-modal').modal('hide');
                        educationList();
                        resetModalForm('education-form');
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
                    enableFormSubmitButton('submit-education-data');
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save employee address';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save employee bank account';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
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

function contactInformationForm(){
    $('#contact-information-form').validate({
        rules: {
            contact_information_type_id: {
                required: true
            },
            contact_information_telephone: {
                required: function(element) {
                    return !($("#contact_information_mobile").val() && $("#contact_information_email").val());
                }
              },
              contact_information_mobile: {
                required: function(element) {
                    return !($("#contact_information_telephone").val() && $("#contact_information_email").val());
                }
              },
              contact_information_email: {
                required: function(element) {
                    return !($("#contact_information_telephone").val() && $("#contact_information_mobile").val());
                }
            }
        },
        messages: {
            contact_information_type_id: {
                required: 'Choose the contact information type'
            },
            contact_information_telephone: {
                required: "Enter at least one of the following: telephone, mobile, or email"
            },
            contact_information_mobile: {
                required: "Enter at least one of the following: telephone, mobile, or email"
            },
            contact_information_email: {
                required: "Enter at least one of the following: telephone, mobile, or email"
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
            const employee_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save employee contact information';
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employee_id=' + employee_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-contact-information-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#contact-information-modal').modal('hide');
                        contactInformationList();
                        resetModalForm('contact-information-form');
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
                    enableFormSubmitButton('submit-contact-information-data');
                }
            });
        
            return false;
        }
    });
}

function experienceList(){
    const employee_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'experience list';

    $.ajax({
        type: 'POST',
        url: 'components/employee/view/_employee_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'employee_id': employee_id },
        beforeSend: function(){
            document.getElementById('experience-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('experience-container').innerHTML = result[0].EXPERIENCE_LIST;
        }
    });
}

function educationList(){
    const employee_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'education list';

    $.ajax({
        type: 'POST',
        url: 'components/employee/view/_employee_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'employee_id': employee_id },
        beforeSend: function(){
            document.getElementById('education-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('education-container').innerHTML = result[0].EDUCATION_LIST;
        }
    });
}

function addressList(){
    const employee_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'address list';

    $.ajax({
        type: 'POST',
        url: 'components/employee/view/_employee_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'employee_id': employee_id },
        beforeSend: function(){
            document.getElementById('address-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('address-container').innerHTML = result[0].ADDRESS_LIST;
        }
    });
}

function bankAccountList(){
    const employee_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'bank account list';

    $.ajax({
        type: 'POST',
        url: 'components/employee/view/_employee_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'employee_id': employee_id },
        beforeSend: function(){
            document.getElementById('bank-account-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('bank-account-container').innerHTML = result[0].BANK_ACCOUNT_LIST;
        }
    });
}

function contactInformationList(){
    const employee_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'contact information list';

    $.ajax({
        type: 'POST',
        url: 'components/employee/view/_employee_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'employee_id': employee_id },
        beforeSend: function(){
            document.getElementById('contact-information-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('contact-information-container').innerHTML = result[0].CONTACT_INFORMATION_LIST;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get about details':
            var employee_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
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
        case 'get private information details':
            var employee_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
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
                        $('#height').val(response.height);
                        $('#weight').val(response.weight);

                        $('#gender_id').val(response.genderID).trigger('change');
                        $('#civil_status_id').val(response.civilStatusID).trigger('change');
                        $('#blood_type_id').val(response.bloodTypeID).trigger('change');
                        $('#religion_id').val(response.religionID).trigger('change');

                        $('#employee_full_name_summary').text(response.fullName);
                        $('#nickname_summary').text(response.nickname);
                        $('#civil_status_summary').text(response.civilStatusName);
                        $('#place_of_birth_summary').text(response.birthPlace);
                        $('#date_of_birth_summary').text(response.birthday);
                        $('#blood_type_summary').text(response.bloodTypeName);
                        $('#height_summary').text(response.height + ' cm');
                        $('#weight_summary').text(response.weight + ' kg');
                        $('#gender_summary').text(response.genderName);
                        $('#religion_summary').text(response.religionName);
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
        case 'get work information details':
            var employee_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('work-information-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#home_work_distance').val(response.homeWorkDistance);

                        $('#department_id').val(response.departmentID).trigger('change');
                        $('#manager_id').val(response.managerID).trigger('change');
                        $('#company_id').val(response.companyID).trigger('change');
                        $('#work_location_id').val(response.workLocationID).trigger('change');
                        $('#work_schedule_id').val(response.workScheduleID).trigger('change');
                        $('#job_position_id').val(response.jobPositionID).trigger('change');
                        $('#time_off_approver_id').val(response.timeOffApproverID).trigger('change');

                        $('#department_summary').text(response.departmentName);
                        $('#job_position_summary').text(response.jobPositionName);
                        $('#employee_job_position_summary').text(response.jobPositionName);
                        $('#manager_summary').text(response.managerName);
                        $('#company_summary').text(response.companyName);
                        $('#work_location_summary').text(response.workLocationName);
                        $('#home_work_distance_summary').text(response.homeWorkDistance + ' km');
                        $('#work_schedule_summary').text(response.workScheduleName);
                        $('#time_off_approver_summary').text(response.timeOffApproverName);
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
        case 'get hr settings details':
            var employee_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('hr-settings-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#pin_code').val(response.pinCode);
                        $('#badge_id').val(response.badgeID);
                        $('#onboard_date').val(response.onboardDate);

                        $('#employment_type_id').val(response.employmentTypeID).trigger('change');

                        $('#pin_code_summary').text(response.pinCode);
                        $('#badge_id_summary').text(response.badgeID);
                        $('#employment_type_summary').text(response.employmentTypeName);
                        $('#onboard_date_summary').text(response.onboardDate);
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
        case 'get work permit details':
            var employee_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('work-permit-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#visa_number').val(response.visaNumber);
                        $('#visa_expiration_date').val(response.visaExpirationDate);
                        $('#work_permit_number').val(response.workPermitNumber);
                        $('#work_permit_expiration_date').val(response.workPermitExpirationDate);

                        $('#visa_number_summary').text(response.visaNumber);
                        $('#work_permit_number_summary').text(response.workPermitNumber);
                        $('#visa_expiration_date_summary').text(response.visaExpirationDate);
                        $('#work_permit_expiration_date_summary').text(response.workPermitExpirationDate);
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
        case 'get employee experience details':
            var employee_id = $('#details-id').text();
            var employee_experience_id = sessionStorage.getItem('employee_experience_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    employee_experience_id : employee_experience_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('experience-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#employee_experience_id').val(employee_experience_id);
                        $('#job_title').val(response.jobTitle);
                        $('#company_name').val(response.companyName);
                        $('#location').val(response.location);
                        $('#job_description').val(response.jobDescription);

                        $('#experience_employment_type_id').val(response.employmentTypeID).trigger('change');
                        $('#employment_location_type_id').val(response.employmentLocationTypeID).trigger('change');
                        $('#start_experience_date_month').val(response.startMonth).trigger('change');
                        $('#start_experience_date_year').val(response.startYear).trigger('change');
                        $('#end_experience_date_month').val(response.endMonth).trigger('change');
                        $('#end_experience_date_year').val(response.endYear).trigger('change');
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
        case 'get employee education details':
            var employee_id = $('#details-id').text();
            var employee_education_id = sessionStorage.getItem('employee_education_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    employee_education_id : employee_education_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('education-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#employee_education_id').val(employee_education_id);
                        $('#school').val(response.school);
                        $('#degree').val(response.degree);
                        $('#field_of_study').val(response.fieldOfStudy);
                        $('#activities_societies').val(response.activitiesSocieties);
                        $('#education_description').val(response.educationDescription);

                        $('#start_education_date_month').val(response.startMonth).trigger('change');
                        $('#start_education_date_year').val(response.startYear).trigger('change');
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
        case 'get employee address details':
            var employee_id = $('#details-id').text();
            var employee_address_id = sessionStorage.getItem('employee_address_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    employee_address_id : employee_address_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('address-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#employee_address_id').val(employee_address_id);
                        $('#address').val(response.address);

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
        case 'get employee bank account details':
            var employee_id = $('#details-id').text();
            var employee_bank_account_id = sessionStorage.getItem('employee_bank_account_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    employee_bank_account_id : employee_bank_account_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('bank-account-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#employee_bank_account_id').val(employee_bank_account_id);
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
        case 'get employee contact information details':
            var employee_id = $('#details-id').text();
            var employee_contact_information_id = sessionStorage.getItem('employee_contact_information_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/employee/controller/employee-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employee_id : employee_id, 
                    employee_contact_information_id : employee_contact_information_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('bank-account-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#employee_contact_information_id').val(employee_contact_information_id);
                        $('#contact_information_telephone').val(response.telephone);
                        $('#contact_information_mobile').val(response.mobile);
                        $('#contact_information_email').val(response.email);

                        $('#contact_information_type_id').val(response.contactInformationTypeID).trigger('change');
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
        case 'department options':
            
            $.ajax({
                url: 'components/department/view/_department_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#department_id').select2({
                        dropdownParent: $('#work-information-modal'),
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
        case 'job position options':
            
            $.ajax({
                url: 'components/job-position/view/_job_position_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#job_position_id').select2({
                        dropdownParent: $('#work-information-modal'),
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
        case 'company options':
            
            $.ajax({
                url: 'components/company/view/_company_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#company_id').select2({
                        dropdownParent: $('#work-information-modal'),
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
        case 'work location options':
            
            $.ajax({
                url: 'components/work-location/view/_work_location_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#work_location_id').select2({
                        dropdownParent: $('#work-information-modal'),
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
        case 'work schedule options':
            
            $.ajax({
                url: 'components/work-schedule/view/_work_schedule_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#work_schedule_id').select2({
                        dropdownParent: $('#work-information-modal'),
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
        case 'blood type options':
            
            $.ajax({
                url: 'components/blood-type/view/_blood_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#blood_type_id').select2({
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
        case 'religion options':
            
            $.ajax({
                url: 'components/religion/view/_religion_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#religion_id').select2({
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
        case 'employment type options':
            
            $.ajax({
                url: 'components/employment-type/view/_employment_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#employment_type_id').select2({
                        dropdownParent: $('#hr-settings-modal'),
                        data: response
                    }).on('change', function (e) {
                        $(this).valid();
                    });

                    $('#experience_employment_type_id').select2({
                        dropdownParent: $('#experience-modal'),
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
        case 'employment location type options':
            
            $.ajax({
                url: 'components/employment-location-type/view/_employment_location_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#employment_location_type_id').select2({
                        dropdownParent: $('#experience-modal'),
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
        case 'active user account options':
            
            $.ajax({
                url: 'components/user-account/view/_user_account_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#time_off_approver_id').select2({
                        dropdownParent: $('#work-information-modal'),
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
        case 'contact information type options':
            
            $.ajax({
                url: 'components/contact-information-type/view/_contact_information_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#contact_information_type_id').select2({
                        dropdownParent: $('#contact-information-modal'),
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