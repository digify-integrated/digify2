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
        generateDropdownOptions('active user account options');
        generateDropdownOptions('months options');
        generateDropdownOptions('year options');
        
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

        $(document).on('click','#edit-about-details',function() {
            displayDetails('get about details');
        });

        $(document).on('click','#add-experience-details',function() {
            $('#experience-title').text('Add Experience');
        });

        $(document).on('click','#add-education-details',function() {
            $('#education-title').text('Add Education');
        });

        $(document).on('click','#add-address-details',function() {
            $('#address-title').text('Add Address');
        });

        $(document).on('click','#add-contact-information-details',function() {
            $('#contact-information-title').text('Add Contact Information');
        });

        $(document).on('click','#add-id-records-details',function() {
            $('#id-records-title').text('Add ID Records');
        });

        $(document).on('click','#add-bank-account-details',function() {
            $('#bank-account-title').text('Add Bank Account');
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
                title: 'Confirm employee Deletion',
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
                required: 'Please enter the about'
            }
        },
        errorPlacement: function(error, element) {
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul style="margin-bottom: 0px;">' + errorList.join('') + '</ul>', 'error', 1500);
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
                required: 'Please enter the first name'
            },
            last_name: {
                required: 'Please enter the last name'
            },
            gender_id: {
                required: 'Please choose the gender'
            },
            civil_status_id: {
                required: 'Please choose the civil status'
            },
            birthday: {
                required: 'Please enter the birthday'
            },
            birth_place: {
                required: 'Please enter the birth place'
            }
        },
        errorPlacement: function(error, element) {
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul style="margin-bottom: 0px;">' + errorList.join('') + '</ul>', 'error', 1500);
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
                required: 'Please choose the department'
            },
            company_id: {
                required: 'Please choose the company'
            },
            job_position_id: {
                required: 'Please choose the job position'
            }
        },
        errorPlacement: function(error, element) {
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul style="margin-bottom: 0px;">' + errorList.join('') + '</ul>', 'error', 1500);
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
                required: 'Please enter the on-board date'
            }
        },
        errorPlacement: function(error, element) {
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul style="margin-bottom: 0px;">' + errorList.join('') + '</ul>', 'error', 1500);
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
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul style="margin-bottom: 0px;">' + errorList.join('') + '</ul>', 'error', 1500);
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
    }
}