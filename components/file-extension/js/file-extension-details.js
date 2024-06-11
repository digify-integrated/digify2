(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('file type options');
        displayDetails('get file extension details');

        if($('#file-extension-form').length){
            fileExtensionForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get file extension details');
        });

        $(document).on('click','#delete-file-extension',function() {
            const file_extension_id = $('#file-extension-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete file extension';
    
            Swal.fire({
                title: 'Confirm File Extension Deletion',
                text: 'Are you sure you want to delete this file extension?',
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
                        url: 'components/file-extension/controller/file-extension-controller.php',
                        dataType: 'json',
                        data: {
                            file_extension_id : file_extension_id, 
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
                const file_extension_id = $('#file-extension-id').text();

                logNotes('file_extension', file_extension_id);
            });
        }

        if($('#internal-notes').length){
            const file_extension_id = $('#file-extension-id').text();

            internalNotes('file_extension', file_extension_id);
        }

        if($('#internal-notes-form').length){
            const file_extension_id = $('#file-extension-id').text();

            internalNotesForm('file_extension', file_extension_id);
        }
    });
})(jQuery);

function fileExtensionForm(){
    $('#file-extension-form').validate({
        rules: {
            file_extension_name: {
                required: true
            },
            file_extension: {
                required: true
            },
            file_type: {
                required: true
            }
        },
        messages: {
            file_extension_name: {
                required: 'Please enter the display name'
            },
            file_extension: {
                required: 'Please enter the file extension'
            },
            file_type: {
                required: 'Please choose the file type'
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
            const file_extension_id = $('#file-extension-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update file extension';
          
            $.ajax({
                type: 'POST',
                url: 'components/file-extension/controller/file-extension-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&file_extension_id=' + file_extension_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get file extension details');
                        $('#file-extension-modal').modal('hide');
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
        case 'get file extension details':
            var file_extension_id = $('#file-extension-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/file-extension/controller/file-extension-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    file_extension_id : file_extension_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('file-extension-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#file_extension_name').val(response.fileExtensionName);
                        $('#file_extension').val(response.fileExtension);
                        
                        $('#file_type').val(response.fileTypeID).trigger('change');
                        
                        $('#file_extension_name_summary').text(response.fileExtensionName);
                        $('#file_extension_summary').text(response.fileExtension);
                        $('#file_type_summary').text(response.fileTypeName);
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
        case 'file type options':
            
            $.ajax({
                url: 'components/file-type/view/_file_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#file_type').select2({
                        dropdownParent: $('#file-extension-modal'),
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