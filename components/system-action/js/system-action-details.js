(function($) {
    'use strict';

    $(function() {
        displayDetails('get system action details');

        if($('#system-action-form').length){
            systemActionForm();
        }

        if($('#role-system-action-permission-assignment-form').length){
            roleSystemActionPermissionAssignmentForm();
        }

        if($('#assigned-role-system-action-permission-table').length){
            assignedRoleSystemActionPermissionTable('#assigned-role-system-action-permission-table');
        }

        $(document).on('click','#assign-role-system-action-permission',function() {
            generateDropdownOptions('system action role dual listbox options');
        });

        $(document).on('click','#edit-details',function() {
            displayDetails('get system action details');
        });

        $(document).on('click','.update-role-system-action-permission',function() {
            const role_system_action_permission_id = $(this).data('role-system-action-permission-id');
            const transaction = 'update role system action permission';
            var system_action_access;

            if ($(this).is(':checked')){  
                system_action_access = '1';
            }
            else{
                system_action_access = '0';
            }
            
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                dataType: 'json',
                data: {
                    role_system_action_permission_id : role_system_action_permission_id, 
                    system_action_access : system_action_access,
                    transaction : transaction
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        reloadDatatable('#assigned-role-system-action-permission-table');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            reloadDatatable('#assigned-role-system-action-permission-table');
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
        });

        $(document).on('click','#delete-system-action',function() {
            const system_action_id = $('#system-action-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete system action';
    
            Swal.fire({
                title: 'Confirm Menu Item Deletion',
                text: 'Are you sure you want to delete this system action?',
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
                        url: 'components/system-action/controller/system-action-controller.php',
                        dataType: 'json',
                        data: {
                            system_action_id : system_action_id, 
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

        $(document).on('click','.delete-role-system-action-permission',function() {
            const role_system_action_permission_id = $(this).data('role-system-action-permission-id');
            const transaction = 'delete role system action permission';
    
            Swal.fire({
                title: 'Confirm System Action Permission Deletion',
                text: 'Are you sure you want to delete this system action permission?',
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
                        url: 'components/role/controller/role-controller.php',
                        dataType: 'json',
                        data: {
                            role_system_action_permission_id : role_system_action_permission_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#assigned-role-system-action-permission-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#assigned-role-system-action-permission-table');
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
                const system_action_id = $('#system-action-id').text();

                logNotes('system_action', system_action_id);
            });

            $(document).on('click','.view-role-system-action-permission-log-notes',function() {
                const role_system_action_permission_id = $(this).data('role-system-action-permission-id');

                logNotes('role_system_action_permission', role_system_action_permission_id);
            });
        }

        if($('#internal-notes').length){
            const system_action_id = $('#system-action-id').text();

            internalNotes('system_action', system_action_id);
        }

        if($('#internal-notes-form').length){
            const system_action_id = $('#system-action-id').text();

            internalNotesForm('system_action', system_action_id);
        }
    });
})(jQuery);

function systemActionForm(){
    $('#system-action-form').validate({
        rules: {
            system_action_name: {
                required: true
            },
            system_action_description: {
                required: true
            }
        },
        messages: {
            system_action_name: {
                required: 'Please enter the display name'
            },
            system_action_description: {
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
            const system_action_id = $('#system-action-id').text();
            const transaction = 'update system action';
          
            $.ajax({
                type: 'POST',
                url: 'components/system-action/controller/system-action-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&system_action_id=' + system_action_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get system action details');
                        $('#system-action-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'menu-group.php';
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

function roleSystemActionPermissionAssignmentForm(){
    $('#role-system-action-permission-assignment-form').validate({
        errorPlacement: function (error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 1500);
        },
        highlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection__rendered').addClass('is-invalid');
            }
            else {
                inputElement.addClass('is-invalid');
            }
        },
        unhighlight: function(element) {
            var inputElement = $(element);
            if (inputElement.hasClass('select2-hidden-accessible')) {
                inputElement.next().find('.select2-selection__rendered').removeClass('is-invalid');
            }
            else {
                inputElement.removeClass('is-invalid');
            }
        },
        submitHandler: function(form) {
            const system_action_id = $('#system-action-id').text();
            const transaction = 'assign system action role permission';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&system_action_id=' + system_action_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-assignment');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        reloadDatatable('#assigned-role-system-action-permission-table');
                        $('#role-system-action-permission-assignment-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'role.php';
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
                    enableFormSubmitButton('submit-assignment');
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get system action details':
            var system_action_id = $('#system-action-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/system-action/controller/system-action-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    system_action_id : system_action_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('system-action-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#system_action_name').val(response.systemActionName);
                        $('#system_action_description').val(response.systemActionDescription);
                        
                        $('#system_action_name_summary').text(response.systemActionName);
                        $('#system_action_description_summary').text(response.systemActionDescription);
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

function assignedRoleSystemActionPermissionTable(datatable_name, buttons = false, show_all = false){
    const system_action_id = $('#system-action-id').text();
    const type = 'assigned role system action permission table';
    var settings;

    const column = [ 
        { 'data' : 'ROLE' },
        { 'data' : 'SYSTEM_ACTION_ACCESS' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': 'auto', 'aTargets': 0 },
        { 'width': 'auto', 'bSortable': false, 'aTargets': 1 },
        { 'width': '15%', 'bSortable': false, 'aTargets': 2 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/role/view/_role_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {'type' : type, 'system_action_id' : system_action_id},
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

function generateDropdownOptions(type){
    switch (type) {
        case 'system action role dual listbox options':
            var system_action_id = $('#system-action-id').text();

            $.ajax({
                url: 'components/role/view/_role_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    system_action_id : system_action_id
                },
                success: function(response) {
                    var select = document.getElementById('role_id');

                    select.options.length = 0;

                    response.forEach(function(opt) {
                        var option = new Option(opt.text, opt.id);
                        select.appendChild(option);
                    });
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function(){
                    if($('#role_id').length){
                        $('#role_id').bootstrapDualListbox({
                            nonSelectedListLabel: 'Non-selected',
                            selectedListLabel: 'Selected',
                            preserveSelectionOnMove: 'moved',
                            moveOnSelect: false,
                            helperSelectNamePostfix: false
                        });

                        $('#role_id').bootstrapDualListbox('refresh', true);

                        initializeDualListBoxIcon();
                    }
                }
            });
            break;
    }
}