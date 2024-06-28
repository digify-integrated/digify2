(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('city options');
        generateDropdownOptions('currency options');
        displayDetails('get work locations details');

        if($('#work-locations-form').length){
            workLocationsForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get work locations details');
        });

        $(document).on('click','#delete-work-locations',function() {
            const work_locations_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete work locations';
    
            Swal.fire({
                title: 'Confirm Work Locations Deletion',
                text: 'Are you sure you want to delete this work location?',
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
                        url: 'components/work-locations/controller/work-locations-controller.php',
                        dataType: 'json',
                        data: {
                            work_locations_id : work_locations_id, 
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
            const work_locations_id = $('#details-id').text();

            logNotesMain('work locations', work_locations_id);
        }

        if($('#internal-notes').length){
            const work_locations_id = $('#details-id').text();

            internalNotes('work locations', work_locations_id);
        }

        if($('#internal-notes-form').length){
            const work_locations_id = $('#details-id').text();

            internalNotesForm('work locations', work_locations_id);
        }
    });
})(jQuery);

function workLocationsForm(){
    $('#work-locations-form').validate({
        rules: {
            work_locations_name: {
                required: true
            },
            address: {
                required: true
            },
            city_id: {
                required: true
            }
        },
        messages: {
            work_locations_name: {
                required: 'Please enter the display name'
            },
            address: {
                required: 'Please enter the address'
            },
            city_id: {
                required: 'Please choose the city'
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
            const work_locations_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update work locations';
          
            $.ajax({
                type: 'POST',
                url: 'components/work-locations/controller/work-locations-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&work_locations_id=' + work_locations_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get work locations details');
                        $('#work-locations-modal').modal('hide');
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
                    logNotesMain('work locations', work_locations_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get work locations details':
            var work_locations_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/work-locations/controller/work-locations-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    work_locations_id : work_locations_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('work-locations-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#work_locations_name').val(response.workLocationsName);
                        $('#address').val(response.address);
                        $('#phone').val(response.phone);
                        $('#mobile').val(response.mobile);
                        $('#email').val(response.email);
                        
                        $('#city_id').val(response.cityID).trigger('change');
                        
                        $('#work_locations_name_summary').text(response.workLocationsName);
                        $('#address_summary').text(response.address);
                        $('#city_name_summary').text(response.cityName);
                        $('#phone_summary').text(response.phone);
                        $('#mobile_summary').text(response.mobile);
                        $('#email_summary').text(response.email);
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
        case 'city options':
            
            $.ajax({
                url: 'components/city/view/_city_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#city_id').select2({
                        dropdownParent: $('#work-locations-modal'),
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