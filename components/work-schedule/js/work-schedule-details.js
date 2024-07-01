(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('schedule type options');
        displayDetails('get work schedule details');

        if($('#work-schedule-form').length){
            workScheduleForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get work schedule details');
        });

        $(document).on('click','#delete-work-schedule',function() {
            const work_schedule_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete work schedule';
    
            Swal.fire({
                title: 'Confirm Work Schedule Deletion',
                text: 'Are you sure you want to delete this work schedule?',
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
                        url: 'components/work-schedule/controller/work-schedule-controller.php',
                        dataType: 'json',
                        data: {
                            work_schedule_id : work_schedule_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.schedule = page_link;
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.schedule = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.schedule = page_link;
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
            const work_schedule_id = $('#details-id').text();

            logNotesMain('work_schedule', work_schedule_id);
        }

        if($('#internal-notes').length){
            const work_schedule_id = $('#details-id').text();

            internalNotes('work_schedule', work_schedule_id);
        }

        if($('#internal-notes-form').length){
            const work_schedule_id = $('#details-id').text();

            internalNotesForm('work_schedule', work_schedule_id);
        }
    });
})(jQuery);

function workScheduleForm(){
    $('#work-schedule-form').validate({
        rules: {
            work_schedule_name: {
                required: true
            },
            schedule_type_id: {
                required: true
            }
        },
        messages: {
            work_schedule_name: {
                required: 'Please enter the display name'
            },
            schedule_type_id: {
                required: 'Please choose the schedule type'
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
            const work_schedule_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update work schedule';
          
            $.ajax({
                type: 'POST',
                url: 'components/work-schedule/controller/work-schedule-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&work_schedule_id=' + work_schedule_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get work schedule details');
                        $('#work-schedule-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.schedule = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.schedule = page_link;
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
                    logNotesMain('work_schedule', work_schedule_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get work schedule details':
            var work_schedule_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/work-schedule/controller/work-schedule-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    work_schedule_id : work_schedule_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('work-schedule-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#work_schedule_name').val(response.workScheduleName);
                        $('#address').val(response.address);
                        $('#phone').val(response.phone);
                        $('#mobile').val(response.mobile);
                        $('#email').val(response.email);
                        
                        $('#city_id').val(response.cityID).trigger('change');
                        
                        $('#work_schedule_name_summary').text(response.workScheduleName);
                        $('#address_summary').text(response.address);
                        $('#city_name_summary').text(response.cityName);
                        $('#phone_summary').text(response.phone);
                        $('#mobile_summary').text(response.mobile);
                        $('#email_summary').text(response.email);
                    } 
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.schedule = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.schedule = page_link;
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
                        dropdownParent: $('#work-schedule-modal'),
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