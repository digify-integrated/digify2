(function($) {
    'use strict';

    $(function() {
        displayDetails('get departure reason details');

        if($('#departure-reason-form').length){
            departureReasonForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get departure reason details');
        });

        $(document).on('click','#delete-departure-reason',function() {
            const departure_reason_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete departure reason';
    
            Swal.fire({
                title: 'Confirm Departure Reason Deletion',
                text: 'Are you sure you want to delete this departure reason?',
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
                        url: 'components/departure-reason/controller/departure-reason-controller.php',
                        dataType: 'json',
                        data: {
                            departure_reason_id : departure_reason_id, 
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
            const departure_reason_id = $('#details-id').text();

            logNotesMain('departure_reason', departure_reason_id);
        }

        if($('#internal-notes').length){
            const departure_reason_id = $('#details-id').text();

            internalNotes('departure_reason', departure_reason_id);
        }

        if($('#internal-notes-form').length){
            const departure_reason_id = $('#details-id').text();

            internalNotesForm('departure_reason', departure_reason_id);
        }
    });
})(jQuery);

function departureReasonForm(){
    $('#departure-reason-form').validate({
        rules: {
            departure_reason_name: {
                required: true
            }
        },
        messages: {
            departure_reason_name: {
                required: 'Please enter the reason'
            },
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
            const departure_reason_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update departure reason';
          
            $.ajax({
                type: 'POST',
                url: 'components/departure-reason/controller/departure-reason-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&departure_reason_id=' + departure_reason_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get departure reason details');
                        $('#departure-reason-modal').modal('hide');
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
                    logNotesMain('departure_reason', departure_reason_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get departure reason details':
            var departure_reason_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/departure-reason/controller/departure-reason-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    departure_reason_id : departure_reason_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('departure-reason-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#departure_reason_name').val(response.departureReasonName);
                        
                        $('#departure_reason_name_summary').text(response.departureReasonName);
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