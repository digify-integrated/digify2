(function($) {
    'use strict';

    $(function() {
        displayDetails('get employment location type details');

        if($('#employment-location-type-form').length){
            employmentLocationTypeForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get employment location type details');
        });

        $(document).on('click','#delete-employment-location-type',function() {
            const employment_location_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete employment location type';
    
            Swal.fire({
                title: 'Confirm Employment Location Type Deletion',
                text: 'Are you sure you want to delete this employment location type?',
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
                        url: 'components/employment-location-type/controller/employment-location-type-controller.php',
                        dataType: 'json',
                        data: {
                            employment_location_type_id : employment_location_type_id, 
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
            const employment_location_type_id = $('#details-id').text();

            logNotesMain('employment_location_type', employment_location_type_id);
        }

        if($('#internal-notes').length){
            const employment_location_type_id = $('#details-id').text();

            internalNotes('employment_location_type', employment_location_type_id);
        }

        if($('#internal-notes-form').length){
            const employment_location_type_id = $('#details-id').text();

            internalNotesForm('employment_location_type', employment_location_type_id);
        }
    });
})(jQuery);

function employmentLocationTypeForm(){
    $('#employment-location-type-form').validate({
        rules: {
            employment_location_type_name: {
                required: true
            }
        },
        messages: {
            employment_location_type_name: {
                required: 'Enter the display name'
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
            const employment_location_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update employment location type';
          
            $.ajax({
                type: 'POST',
                url: 'components/employment-location-type/controller/employment-location-type-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&employment_location_type_id=' + employment_location_type_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get employment location type details');
                        $('#employment-location-type-modal').modal('hide');
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
                    logNotesMain('employment_location_type', employment_location_type_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get employment location type details':
            var employment_location_type_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/employment-location-type/controller/employment-location-type-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    employment_location_type_id : employment_location_type_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('employment-location-type-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#employment_location_type_name').val(response.employmentLocationTypeName);
                        
                        $('#employment_location_type_name_summary').text(response.employmentLocationTypeName);
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