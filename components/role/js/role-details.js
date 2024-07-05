(function($) {
    'use strict';

    $(function() {
        displayDetails('get role details');

        if($('#role-form').length){
            roleForm();
        }

        if($('#role-permission-assignment-form').length){
            rolePermissionAssignmentForm();
        }

        if($('#user-account-assignment-form').length){
            userAccountAssignmentForm();
        }

        if($('#role-system-action-permission-assignment-form').length){
            roleSystemActionPermissionAssignmentForm();
        }

        if($('#assigned-user-account-table').length){
            assignedUserAccountTable('#assigned-user-account-table');
        }

        if($('#assigned-role-permission-table').length){
            assignedRolePermissionTable('#assigned-role-permission-table');
        }

        if($('#assigned-role-system-action-permission-table').length){
            assignedRoleSystemActionPermissionTable('#assigned-role-system-action-permission-table');
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get role details');
        });

        $(document).on('click','#assign-role-permission',function() {
            generateDropdownOptions('role menu item dual listbox options');
        });

        $(document).on('click','#assign-user-account',function() {
            generateDropdownOptions('role user account dual listbox options');
        });

        $(document).on('click','#assign-role-system-action-permission',function() {
            generateDropdownOptions('role system action dual listbox options');
        });

        $(document).on('click','.update-role-permission',function() {
            const role_permission_id = $(this).data('role-permission-id');
            const access_type = $(this).data('access-type');
            const transaction = 'update role permission';
            var access;

            if ($(this).is(':checked')){  
                access = '1';
            }
            else{
                access = '0';
            }
            
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                dataType: 'json',
                data: {
                    role_permission_id : role_permission_id, 
                    access_type : access_type,
                    access : access,
                    transaction : transaction
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        reloadDatatable('#assigned-role-permission-table');
                    }
                    else {
                        if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else if (response.notExist) {
                            setNotification(response.title, response.message, response.messageType);
                            reloadDatatable('#assigned-role-permission-table');
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

        $(document).on('click','#delete-role',function() {
            const role_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete role';
    
            Swal.fire({
                title: 'Confirm Role Deletion',
                text: 'Are you sure you want to delete this role?',
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
                            role_id : role_id, 
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

        $(document).on('click','.delete-role-permission',function() {
            const role_permission_id = $(this).data('role-permission-id');
            const transaction = 'delete role permission';
    
            Swal.fire({
                title: 'Confirm Role Permission Deletion',
                text: 'Are you sure you want to delete this role permission?',
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
                            role_permission_id : role_permission_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#assigned-role-permission-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#assigned-role-permission-table');
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

        $(document).on('click','.delete-role-user-account',function() {
            const role_user_account_id = $(this).data('role-user-account-id');
            const transaction = 'delete role user account';
    
            Swal.fire({
                title: 'Confirm User Account Deletion',
                text: 'Are you sure you want to delete this user account?',
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
                            role_user_account_id : role_user_account_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#assigned-user-account-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#assigned-user-account-table');
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
            $(document).on('click','.view-role-permission-log-notes',function() {
                const role_permission_id = $(this).data('role-permission-id');

                logNotes('role_permission', role_permission_id);
            });

            $(document).on('click','.view-role-system-action-permission-log-notes',function() {
                const role_system_action_permission_id = $(this).data('role-system-action-permission-id');

                logNotes('role_system_action_permission', role_system_action_permission_id);
            });

            $(document).on('click','.view-role-user-account-log-notes',function() {
                const role_user_account_id = $(this).data('role-user-account-id');

                logNotes('role_user_account', role_user_account_id);
            });
        }

        if($('#log-notes-main').length){
            const role_id = $('#details-id').text();

            logNotesMain('role', role_id);
        }

        if($('#internal-notes').length){
            const role_id = $('#details-id').text();

            internalNotes('role', role_id);
        }

        if($('#internal-notes-form').length){
            const role_id = $('#details-id').text();

            internalNotesForm('role', role_id);
        }
    });
})(jQuery);

function roleForm(){
    $('#role-form').validate({
        rules: {
            role_name: {
                required: true
            },
            role_description: {
                required: true
            }
        },
        messages: {
            role_name: {
                required: 'Please enter the display name'
            },
            role_description: {
                required: 'Please enter the description'
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
            showNotification('Attention Required: Error Found', errorMessage, 'error', 1500);
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
            const role_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'update role';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&role_id=' + role_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get role details');
                        $('#role-modal').modal('hide');
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
                    logNotesMain('role', role_id);
                }
            });
        
            return false;
        }
    });
}

function userAccountAssignmentForm(){
    $('#user-account-assignment-form').validate({
        errorPlacement: function(error, element) {
            var errorMessage = '';
            $.each(this.errorMap, function(key, value) {
                errorMessage += value;
                if (key!== Object.keys(this.errorMap)[Object.keys(this.errorMap).length - 1]) {
                    errorMessage += '<br>';
                }
            }.bind(this));
            showNotification('Attention Required: Error Found', errorMessage, 'error', 1500);
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
            const role_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'assign role user account';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&role_id=' + role_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-user-account-assignment');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        reloadDatatable('#assigned-user-account-table');
                        $('#user-account-assignment-modal').modal('hide');
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
                    enableFormSubmitButton('submit-user-account-assignment');
                }
            });
        
            return false;
        }
    });
}

function rolePermissionAssignmentForm(){
    $('#role-permission-assignment-form').validate({
        errorPlacement: function(error, element) {
            var errorMessage = '';
            $.each(this.errorMap, function(key, value) {
                errorMessage += value;
                if (key!== Object.keys(this.errorMap)[Object.keys(this.errorMap).length - 1]) {
                    errorMessage += '<br>';
                }
            }.bind(this));
            showNotification('Attention Required: Error Found', errorMessage, 'error', 1500);
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
            const role_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'assign role permission';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&role_id=' + role_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-assignment');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        reloadDatatable('#assigned-role-permission-table');
                        $('#role-permission-assignment-modal').modal('hide');
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
                    enableFormSubmitButton('submit-assignment');
                }
            });
        
            return false;
        }
    });
}

function roleSystemActionPermissionAssignmentForm(){
    $('#role-system-action-permission-assignment-form').validate({
        errorPlacement: function(error, element) {
            var errorMessage = '';
            $.each(this.errorMap, function(key, value) {
                errorMessage += value;
                if (key!== Object.keys(this.errorMap)[Object.keys(this.errorMap).length - 1]) {
                    errorMessage += '<br>';
                }
            }.bind(this));
            showNotification('Attention Required: Error Found', errorMessage, 'error', 1500);
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
            const role_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'assign role system action permission';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&role_id=' + role_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-system-action-assignme');
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
                    enableFormSubmitButton('submit-system-action-assignment');
                }
            });
        
            return false;
        }
    });
}

function assignedUserAccountTable(datatable_name, buttons = false, show_all = false){
    const role_id = $('#details-id').text();
    const type = 'assigned role user account table';
    var settings;

    const column = [ 
        { 'data' : 'USER_ACCOUNT' },
        { 'data' : 'LAST_CONNECTION_DATE' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': 'auto', 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 },
        { 'width': '15%', 'bSortable': false, 'aTargets': 2 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/role/view/_role_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {'type' : type, 'role_id' : role_id},
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

function assignedRolePermissionTable(datatable_name, buttons = false, show_all = false){
    const role_id = $('#details-id').text();
    const type = 'assigned menu item permission table';
    var settings;

    const column = [ 
        { 'data' : 'MENU_ITEM' },
        { 'data' : 'READ_ACCESS' },
        { 'data' : 'CREATE_ACCESS' },
        { 'data' : 'WRITE_ACCESS' },
        { 'data' : 'DELETE_ACCESS' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': 'auto', 'aTargets': 0 },
        { 'width': 'auto', 'bSortable': false, 'aTargets': 1 },
        { 'width': 'auto', 'bSortable': false, 'aTargets': 2 },
        { 'width': 'auto', 'bSortable': false, 'aTargets': 3 },
        { 'width': 'auto', 'bSortable': false, 'aTargets': 4 },
        { 'width': '15%', 'bSortable': false, 'aTargets': 5 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/role/view/_role_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {'type' : type, 'role_id' : role_id},
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

function assignedRoleSystemActionPermissionTable(datatable_name, buttons = false, show_all = false){
    const role_id = $('#details-id').text();
    const type = 'assigned system action permission table';
    var settings;

    const column = [ 
        { 'data' : 'SYSTEM_ACTION' },
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
            'data': {'type' : type, 'role_id' : role_id},
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

function displayDetails(transaction){
    switch (transaction) {
        case 'get role details':
            var role_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/role/controller/role-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    role_id : role_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('role-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#role_name').val(response.roleName);
                        $('#role_description').val(response.roleDescription);
                        
                        $('#role_name_summary').text(response.roleName);
                        $('#role_description_summary').text(response.roleDescription);
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
        case 'role menu item dual listbox options':
            var role_id = $('#details-id').text();

            $.ajax({
                url: 'components/menu-item/view/_menu_item_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    role_id : role_id
                },
                success: function(response) {
                    var select = document.getElementById('menu_item_id');

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
                    if($('#menu_item_id').length){
                        $('#menu_item_id').bootstrapDualListbox({
                            nonSelectedListLabel: 'Non-selected',
                            selectedListLabel: 'Selected',
                            preserveSelectionOnMove: 'moved',
                            moveOnSelect: false,
                            helperSelectNamePostfix: false
                        });

                        $('#menu_item_id').bootstrapDualListbox('refresh', true);

                        initializeDualListBoxIcon();
                    }
                }
            });
            break;
        case 'role system action dual listbox options':
            var role_id = $('#details-id').text();

            $.ajax({
                url: 'components/system-action/view/_system_action_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    role_id : role_id
                },
                success: function(response) {
                    var select = document.getElementById('system_action_id');

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
                    if($('#system_action_id').length){
                        $('#system_action_id').bootstrapDualListbox({
                            nonSelectedListLabel: 'Non-selected',
                            selectedListLabel: 'Selected',
                            preserveSelectionOnMove: 'moved',
                            moveOnSelect: false,
                            helperSelectNamePostfix: false
                        });

                        $('#system_action_id').bootstrapDualListbox('refresh', true);

                        initializeDualListBoxIcon();
                    }
                }
            });
            break;
        case 'role user account dual listbox options':
            var role_id = $('#details-id').text();

            $.ajax({
                url: 'components/user-account/view/_user_account_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    role_id : role_id
                },
                success: function(response) {
                    var select = document.getElementById('user_account_id');

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
                    if($('#user_account_id').length){
                        $('#user_account_id').bootstrapDualListbox({
                            nonSelectedListLabel: 'Non-selected',
                            selectedListLabel: 'Selected',
                            preserveSelectionOnMove: 'moved',
                            moveOnSelect: false,
                            helperSelectNamePostfix: false
                        });

                        $('#user_account_id').bootstrapDualListbox('refresh', true);

                        initializeDualListBoxIcon();
                    }
                }
            });
            break;
    }
}