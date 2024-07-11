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
        
        if($('#employee-form').length){
            employeeForm();
        }
    });
})(jQuery);

function employeeForm(){
    $('#employee-form').validate({
        rules: {
            first_name: {
                required: true
            },
            last_name: {
                required: true
            },
            company_id: {
                required: true
            },
            department_id: {
                required: true
            },
            job_position_id: {
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
            },
            onboard_date: {
                required: true
            }
        },
        messages: {
            first_name: {
                required: 'First Name'
            },
            last_name: {
                required: 'Last Name'
            },
            company_id: {
                required: 'Company'
            },
            department_id: {
                required: 'Department'
            },
            job_position_id: {
                required: 'Job Position'
            },
            gender_id: {
                required: 'Gender'
            },
            civil_status_id: {
                required: 'Civil Status'
            },
            birthday: {
                required: 'Date of Birth'
            },
            birth_place: {
                required: 'Birth Place'
            },
            onboard_date: {
                required: 'On-board Date'
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
            const transaction = 'add employee';
            const page_link = document.getElementById('page-link').getAttribute('href');
          
            $.ajax({
                type: 'POST',
                url: 'components/employee/controller/employee-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        window.location = page_link + '&id=' + response.employeeID;
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