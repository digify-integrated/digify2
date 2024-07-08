(function($) {
    'use strict';

    $(function() {
        displayDetails('get contact information type details');

        if($('#contact-information-type-form').length){
            contactInformationTypeForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get contact information type details');
        });

        $(document).on('click','#delete-contact-information-type',function() {
            const contact_information_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete contact information type';
    
            Swal.fire({
                title: 'Confirm Contact Information Type Deletion',
                text: 'Are you sure you want to delete this contact information type?',
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
                        url: 'components/contact-information-type/controller/contact-information-type-controller.php',
                        dataType: 'json',
                        data: {
                            contact_information_type_id : contact_information_type_id, 
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
            const contact_information_type_id = $('#details-id').text();

            logNotesMain('contact_information_type', contact_information_type_id);
        }

        if($('#internal-notes').length){
            const contact_information_type_id = $('#details-id').text();

            internalNotes('contact_information_type', contact_information_type_id);
        }

        if($('#internal-notes-form').length){
            const contact_information_type_id = $('#details-id').text();

            internalNotesForm('contact_information_type', contact_information_type_id);
        }
    });
})(jQuery);

function contactInformationTypeForm(){
    $('#contact-information-type-form').validate({
        rules: {
            contact_information_type_name: {
                required: true
            }
        },
        messages: {
            contact_information_type_name: {
                required: 'Display Name'
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
            const contact_information_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update contact information type';
          
            $.ajax({
                type: 'POST',
                url: 'components/contact-information-type/controller/contact-information-type-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&contact_information_type_id=' + contact_information_type_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get contact information type details');
                        $('#contact-information-type-modal').modal('hide');
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
                    logNotesMain('contact_information_type', contact_information_type_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get contact information type details':
            var contact_information_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/contact-information-type/controller/contact-information-type-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    contact_information_type_id : contact_information_type_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('contact-information-type-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#contact_information_type_name').val(response.contactInformationTypeName);
                        
                        $('#contact_information_type_name_summary').text(response.contactInformationTypeName);
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