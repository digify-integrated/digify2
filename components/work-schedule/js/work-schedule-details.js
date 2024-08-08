(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('schedule type options');
        displayDetails('get work schedule details');

        if($('#work-schedule-form').length){
            workScheduleForm();
        }

        if($('#work-hours-form').length){
            workHoursForm();
        }

        if($('#work-hours-table').length){
            workHoursTable('#work-hours-table');
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

        $(document).on('click','#add-work-hours',function() {
            resetModalForm('work-hours-form');
        });

        $(document).on('click','.update-work-hours',function() {
            const work_hours_id = $(this).data('work-hours-id');
    
            sessionStorage.setItem('work_hours_id', work_hours_id);
            
            displayDetails('get work hours details');
        });

        $(document).on('click','.delete-work-hours',function() {
            const work_hours_id = $(this).data('work-hours-id');
            const transaction = 'delete work hours';
    
            Swal.fire({
                title: 'Confirm Work Hour Deletion',
                text: 'Are you sure you want to delete this work hour?',
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
                            work_hours_id : work_hours_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#work-hours-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    showNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#work-hours-table');
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

        if($('#log-notes-offcanvas').length){
            $(document).on('click','.view-work-hours-log-notes',function() {
                const work_hours_id = $(this).data('work-hours-id');

                logNotes('work_hours', work_hours_id);
            });
        }

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

function workHoursTable(datatable_name, buttons = false, show_all = false){
    const work_schedule_id = $('#details-id').text();
    const type = 'work hours table';
    var settings;

    const column = [ 
        { 'data' : 'DAY_OF_WEEK' },
        { 'data' : 'DAY_PERIOD' },
        { 'data' : 'START_TIME' },
        { 'data' : 'END_TIME' },
        { 'data' : 'NOTES' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': 'auto', 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 },
        { 'width': 'auto', 'aTargets': 2 },
        { 'width': 'auto', 'aTargets': 3 },
        { 'width': 'auto', 'aTargets': 4 },
        { 'width': '15%', 'bSortable': false, 'aTargets': 5 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/work-schedule/view/_work_schedule_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {'type' : type, 'work_schedule_id' : work_schedule_id},
            'dataSrc' : '',
            'error': function(xhr, status, error) {
                var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                if (xhr.responseText) {
                    fullErrorMessage += `, Response: ${xhr.responseText}`;
                }
                showErrorDialog(fullErrorMessage);
            }
        },
        'order': [[ 0, 'asc' ]],
        'columns' : column,
        'fnDrawCallback': function( oSettings ) {
            readjustDatatableColumn();
        },
        'columnDefs': column_definition,
        'lengthMenu': length_menu,
        'language': {
            'emptyTable': 'No data found',
            'searchPlaceholder': 'Search...',
            'search': '',
            'loadingRecords': 'Just a moment while we fetch your data...'
        },
    };

    if (buttons) {
        settings.dom = 'Bfrtip';
        settings.buttons = ['csv', 'excel', 'pdf'];
    }

    destroyDatatable(datatable_name);

    $(datatable_name).dataTable(settings);
}

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
                required: 'Enter the display name'
            },
            schedule_type_id: {
                required: 'Choose the schedule type'
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
                    logNotesMain('work_schedule', work_schedule_id);
                }
            });
        
            return false;
        }
    });
}

function workHoursForm(){
    $('#work-hours-form').validate({
        rules: {
            day_of_week: {
                required: true
            },
            day_period: {
                required: true
            },
            work_from: {
                required: true
            },
            work_to: {
                required: true
            }
        },
        messages: {
            day_of_week: {
                required: 'Please choose the day of week'
            },
            day_period: {
                required: 'Please choose the day period'
            },
            work_from: {
                required: 'Please choose the work from'
            },
            work_to: {
                required: 'Please choose the work to'
            }
        },
        errorPlacement: function(error, element) {
            var errorMessage = '';
            $.each(this.errorMap, function(key, value) {
                errorMessage += value;
                if (key!== Object.keys(this.errorMap)[Object.keys(this.errorMap).length - 1]) {
                    errorMessage += '<br>';
                }
            }.bind(this));
            showNotification('Invalid fields:', errorMessage, 'error', 1500);
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
            const transaction = 'save work hours';
          
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
                        $('#work-hours-modal').modal('hide');
                        reloadDatatable('#work-hours-table');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            showNotification(response.title, response.message, response.messageType);
                            ('#work-hours-modal').modal('hide');
                            reloadDatatable('#work-hours-table');
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
            var page_link = document.getElementById('page-link').getAttribute('href');
            
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
                        
                        $('#schedule_type_id').val(response.scheduleTypeID).trigger('change');

                        if(response.scheduleTypeID == 1){
                            $('#work-hours-header').text('Day of Week');
                        }
                        else{
                            $('#work-hours-header').text('Work Date');
                        }
                        
                        $('#work_schedule_name_summary').text(response.workScheduleName);
                        $('#schedule_type_name_summary').text(response.scheduleTypeName);
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
        case 'get work hours details':
            var work_hours_id = sessionStorage.getItem('work_hours_id');
            var page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/work-schedule/controller/work-schedule-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    work_hours_id : work_hours_id, 
                    transaction : transaction
                },
                success: function(response) {
                    if (response.success) {
                        $('#work_hours_id').val(response.workHoursID);
                        $('#work_from').val(response.startTime);
                        $('#work_to').val(response.endTime);
                        $('#notes').val(response.notes);
                        
                        $('#day_of_week').val(response.dayOfWeek).trigger('change');
                        $('#day_period').val(response.dayPeriod).trigger('change');
                    } 
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            showNotification(response.title, response.message, response.messageType);
                            reloadDatatable('#work-hours-table');
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
        case 'schedule type options':
            
            $.ajax({
                url: 'components/schedule-type/view/_schedule_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#schedule_type_id').select2({
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