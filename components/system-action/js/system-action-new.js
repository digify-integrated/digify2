(function($) {
    'use strict';

    $(function() {
        if($('#system-action-form').length){
            systemActionForm();
        }
    });
})(jQuery);

function systemActionForm(){
    $('#system-action-form').validate({
        rules: {
            system_action_name: {
                required: true
            },
            system_action_description: {
                required: true
            }
        },
        messages: {
            system_action_name: {
                required: 'Display Name'
            },
            system_action_description: {
                required: 'Description'
            }
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
            const transaction = 'add system action';
            const page_link = document.getElementById('page-link').getAttribute('href');
          
            $.ajax({
                type: 'POST',
                url: 'components/system-action/controller/system-action-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        window.location = page_link + '&id=' + response.systemActionID;
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