(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('block style options');

        displayDetails('get contact form details');

        if($('#contact-form').length){
            contactForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get contact form details');
        });

        $(document).on('click','#delete-contact-form',function() {
            const contact_form_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete contact form';
    
            Swal.fire({
                title: 'Confirm Contact Form Deletion',
                text: 'Are you sure you want to delete this contact form?',
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
                        url: 'components/contact-form/controller/contact-form-controller.php',
                        dataType: 'json',
                        data: {
                            contact_form_id : contact_form_id, 
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

        $(document).on('click','#unpublish-contact-form',function() {
            const contact_form_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'unpublish contact form';
    
            Swal.fire({
                title: 'Confirm Contact Form Unpublish',
                text: 'Are you sure you want to unpublish this contact form?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Unpublish',
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
                        url: 'components/contact-form/controller/contact-form-controller.php',
                        dataType: 'json',
                        data: {
                            contact_form_id : contact_form_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location.reload();
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

        $(document).on('click','#publish-contact-form',function() {
            const contact_form_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'publish contact form';
    
            Swal.fire({
                title: 'Confirm Contact Form Publish',
                text: 'Are you sure you want to unpublish this contact form?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Publish',
                cancelButtonText: 'Cancel',
                customClass: {
                    confirmButton: 'btn btn-success mt-2',
                    cancelButton: 'btn btn-secondary ms-2 mt-2'
                },
                buttonsStyling: !1
            }).then(function(result) {
                if (result.value) {
                    $.ajax({
                        type: 'POST',
                        url: 'components/contact-form/controller/contact-form-controller.php',
                        dataType: 'json',
                        data: {
                            contact_form_id : contact_form_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location.reload();
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
            const contact_form_id = $('#details-id').text();

            logNotesMain('contact_form', contact_form_id);
        }

        if($('#internal-notes').length){
            const contact_form_id = $('#details-id').text();

            internalNotes('contact_form', contact_form_id);
        }

        if($('#internal-notes-form').length){
            const contact_form_id = $('#details-id').text();

            internalNotesForm('contact_form', contact_form_id);
        }
    });
})(jQuery);

function contactForm(){
    $('#contact-form').validate({
        rules: {
            contact_form_name: {
                required: true
            },
            block_style_id: {
                required: true
            },
            description: {
                required: true
            }
        },
        messages: {
            contact_form_name: {
                required: 'Enter the display name'
            },
            block_style_id: {
                required: 'Choose the block style'
            },
            description: {
                required: 'Enter the description'
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
            const contact_form_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update contact form';
          
            $.ajax({
                type: 'POST',
                url: 'components/contact-form/controller/contact-form-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&contact_form_id=' + contact_form_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get contact form details');
                        $('#contact-form-modal').modal('hide');
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
                    logNotesMain('contact_form', contact_form_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get contact form details':
            var contact_form_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/contact-form/controller/contact-form-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    contact_form_id : contact_form_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('contact-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#contact_form_name').val(response.contactFormName);
                        $('#description').val(response.description);
                        
                        $('#block_style_id').val(response.blockStyleID).trigger('change');
                        
                        $('#contact_form_name_summary').text(response.contactFormName);
                        $('#block_style_name_summary').text(response.blockStyleName);
                        $('#description_summary').text(response.description);
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
        case 'block style options':
            var block_type_id = '5';

            $.ajax({
                url: 'components/block-style/view/_block_style_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    block_type_id : block_type_id
                },
                success: function(response) {
                    $('#block_style_id').select2({
                        dropdownParent: $('#contact-form-modal'),
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