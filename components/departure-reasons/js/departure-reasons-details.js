(function($) {
    'use strict';

    $(function() {
        displayDetails('get departure reasons details');

        if($('#departure-reasons-form').length){
            departureReasonsForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get departure reasons details');
        });

        $(document).on('click','#delete-departure-reasons',function() {
            const departure_reasons_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete departure reasons';
    
            Swal.fire({
                title: 'Confirm Departure Reason Deletion',
                text: 'Are you sure you want to delete this departure reasons?',
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
                        url: 'components/departure-reasons/controller/departure-reasons-controller.php',
                        dataType: 'json',
                        data: {
                            departure_reasons_id : departure_reasons_id, 
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
            const departure_reasons_id = $('#details-id').text();

            logNotesMain('departure_reasons', departure_reasons_id);
        }

        if($('#internal-notes').length){
            const departure_reasons_id = $('#details-id').text();

            internalNotes('departure_reasons', departure_reasons_id);
        }

        if($('#internal-notes-form').length){
            const departure_reasons_id = $('#details-id').text();

            internalNotesForm('departure_reasons', departure_reasons_id);
        }
    });
})(jQuery);

function departureReasonsForm(){
    $('#departure-reasons-form').validate({
        rules: {
            departure_reasons_name: {
                required: true
            }
        },
        messages: {
            departure_reasons_name: {
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
            const departure_reasons_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update departure reasons';
          
            $.ajax({
                type: 'POST',
                url: 'components/departure-reasons/controller/departure-reasons-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&departure_reasons_id=' + departure_reasons_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get departure reasons details');
                        $('#departure-reasons-modal').modal('hide');
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
                    logNotesMain('departure_reasons', departure_reasons_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get departure reasons details':
            var departure_reasons_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/departure-reasons/controller/departure-reasons-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    departure_reasons_id : departure_reasons_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('departure-reasons-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#departure_reasons_name').val(response.departureReasonsName);
                        
                        $('#departure_reasons_name_summary').text(response.departureReasonsName);
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