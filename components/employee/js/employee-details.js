(function($) {
    'use strict';

    $(function() {
        //generateDropdownOptions('department options');
        displayDetails('get employee details');
        displayDetails('get work information details');

        /*if($('#department-form').length){
            departmentForm();
        }*/

        $(document).on('click','#edit-details',function() {
            displayDetails('get department details');
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

        $(document).on('click','#delete-department',function() {
            const department_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete department';
    
            Swal.fire({
                title: 'Confirm Department Deletion',
                text: 'Are you sure you want to delete this department?',
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
                        url: 'components/department/controller/department-controller.php',
                        dataType: 'json',
                        data: {
                            department_id : department_id, 
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
            const department_id = $('#details-id').text();

            logNotesMain('department', department_id);
        }

        if($('#internal-notes').length){
            const department_id = $('#details-id').text();

            internalNotes('department', department_id);
        }

        if($('#internal-notes-form').length){
            const employee_id = $('#details-id').text();

            internalNotesForm('employee', employee_id);
        }
    });
})(jQuery);

function departmentForm(){
    $('#department-form').validate({
        rules: {
            department_name: {
                required: true
            }
        },
        messages: {
            department_name: {
                required: 'Please enter the display name'
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
            const department_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update department';
          
            $.ajax({
                type: 'POST',
                url: 'components/department/controller/department-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&department_id=' + department_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get department details');
                        $('#department-modal').modal('hide');
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
                    logNotesMain('department', department_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get department details':
            var department_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/department/controller/department-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    department_id : department_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('department-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#department_name').val(response.departmentName);
                        
                        $('#parent_department_id').val(response.parentDepartmentID).trigger('change');
                        $('#manager_id').val(response.managerID).trigger('change');
                        
                        $('#department_name_summary').text(response.departmentName);
                        $('#parent_department_name_summary').text(response.parentDepartmentName);
                        $('#manager_name_summary').text(response.managerName);
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
            var department_id = $('#details-id').text();

            $.ajax({
                url: 'components/department/view/_department_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    department_id : department_id
                },
                success: function(response) {
                    $('#parent_department_id').select2({
                        dropdownParent: $('#department-modal'),
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