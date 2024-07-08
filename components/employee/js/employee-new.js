(function($) {
    'use strict';

    $(function() {
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
            },
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
            },
        },
        errorPlacement: function(error, element) {
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul>' + errorList.join('') + '</ul>', 'error', 1500);
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