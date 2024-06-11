(function($) {
    'use strict';

    $(function() {
        displayDetails('get system setting details');

        if($('#system-setting-form').length){
            systemSettingForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get system setting details');
        });

        $(document).on('click','#delete-system-setting',function() {
            const system_setting_id = $('#system-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete system setting';
    
            Swal.fire({
                title: 'Confirm System Setting Deletion',
                text: 'Are you sure you want to delete this system setting?',
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
                        url: 'components/system-setting/controller/system-setting-controller.php',
                        dataType: 'json',
                        data: {
                            system_setting_id : system_setting_id, 
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
                const system_setting_id = $('#system-setting-id').text();

                logNotes('system_setting', system_setting_id);
            });
        }

        if($('#internal-notes').length){
            const system_setting_id = $('#system-setting-id').text();

            internalNotes('system_setting', system_setting_id);
        }

        if($('#internal-notes-form').length){
            const system_setting_id = $('#system-setting-id').text();

            internalNotesForm('system_setting', system_setting_id);
        }
    });
})(jQuery);

function systemSettingForm(){
    $('#system-setting-form').validate({
        rules: {
            system_setting_name: {
                required: true
            },
            value: {
                required: true
            },
            system_setting_description: {
                required: true
            }
        },
        messages: {
            system_setting_name: {
                required: 'Please enter the display name'
            },
            value: {
                required: 'Please enter the value'
            },
            system_setting_description: {
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
            const system_setting_id = $('#system-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update system setting';
          
            $.ajax({
                type: 'POST',
                url: 'components/system-setting/controller/system-setting-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&system_setting_id=' + system_setting_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get system setting details');
                        $('#system-setting-modal').modal('hide');
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
        case 'get system setting details':
            var system_setting_id = $('#system-setting-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/system-setting/controller/system-setting-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    system_setting_id : system_setting_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('system-setting-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#system_setting_name').val(response.systemSettingName);
                        $('#system_setting_description').val(response.systemSettingDescription);
                        $('#value').val(response.value);
                        
                        $('#system_setting_name_summary').text(response.systemSettingName);
                        $('#system_setting_description_summary').text(response.systemSettingDescription);
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