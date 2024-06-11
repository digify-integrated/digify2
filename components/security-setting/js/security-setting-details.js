(function($) {
    'use strict';

    $(function() {
        displayDetails('get security setting details');

        if($('#security-setting-form').length){
            securitySettingForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get security setting details');
        });

        $(document).on('click','#delete-security-setting',function() {
            const security_setting_id = $('#security-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete security setting';
    
            Swal.fire({
                title: 'Confirm Security Setting Deletion',
                text: 'Are you sure you want to delete this security setting?',
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
                        url: 'components/security-setting/controller/security-setting-controller.php',
                        dataType: 'json',
                        data: {
                            security_setting_id : security_setting_id, 
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
                const security_setting_id = $('#security-setting-id').text();

                logNotes('security_setting', security_setting_id);
            });
        }

        if($('#internal-notes').length){
            const security_setting_id = $('#security-setting-id').text();

            internalNotes('security_setting', security_setting_id);
        }

        if($('#internal-notes-form').length){
            const security_setting_id = $('#security-setting-id').text();

            internalNotesForm('security_setting', security_setting_id);
        }
    });
})(jQuery);

function securitySettingForm(){
    $('#security-setting-form').validate({
        rules: {
            security_setting_name: {
                required: true
            },
            value: {
                required: true
            },
            security_setting_description: {
                required: true
            }
        },
        messages: {
            security_setting_name: {
                required: 'Please enter the display name'
            },
            value: {
                required: 'Please enter the value'
            },
            security_setting_description: {
                required: 'Please enter the description'
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
            const security_setting_id = $('#security-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update security setting';
          
            $.ajax({
                type: 'POST',
                url: 'components/security-setting/controller/security-setting-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&security_setting_id=' + security_setting_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get security setting details');
                        $('#security-setting-modal').modal('hide');
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
        case 'get security setting details':
            var security_setting_id = $('#security-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/security-setting/controller/security-setting-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    security_setting_id : security_setting_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('security-setting-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#security_setting_name').val(response.securitySettingName);
                        $('#security_setting_description').val(response.securitySettingDescription);
                        $('#value').val(response.value);
                        
                        $('#security_setting_name_summary').text(response.securitySettingName);
                        $('#security_setting_description_summary').text(response.securitySettingDescription);
                        $('#value_summary').text(response.value);
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