(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('app module options');
        generateDropdownOptions('menu item options');
        displayDetails('get menu item details');

        if($('#menu-item-form').length){
            menuItemForm();
        }

        if($('#role-permission-assignment-form').length){
            rolePermissionAssignmentForm();
        }

        if($('#assigned-role-permission-table').length){
            assignedRolePermissionTable('#assigned-role-permission-table');
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get menu item details');
        });

        if($('#submenu-item-table').length){
            submenuItemTable('#submenu-item-table');
        }

        $(document).on('click','#delete-menu-item',function() {
            const menu_item_id = $('#menu-item-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete menu item';
    
            Swal.fire({
                title: 'Confirm Menu Item Deletion',
                text: 'Are you sure you want to delete this menu item?',
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
                        url: 'components/menu-item/controller/menu-item-controller.php',
                        dataType: 'json',
                        data: {
                            menu_item_id : menu_item_id, 
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

        $(document).on('click','#assign-role-permission',function() {
            generateDropdownOptions('menu item role dual listbox options');
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

        if($('#log-notes-offcanvas').length && $('#view-log-notes').length){
            $(document).on('click','#view-log-notes',function() {
                const menu_item_id = $('#menu-item-id').text();

                logNotes('menu_item', menu_item_id);
            });

            $(document).on('click','.view-role-permission-log-notes',function() {
                const role_permission_id = $(this).data('role-permission-id');

                logNotes('role_permission', role_permission_id);
            });
        }

        if($('#internal-notes').length){
            const menu_item_id = $('#menu-item-id').text();

            internalNotes('menu_item', menu_item_id);
        }

        if($('#internal-notes-form').length){
            const menu_item_id = $('#menu-item-id').text();

            internalNotesForm('menu_item', menu_item_id);
        }
    });
})(jQuery);

function menuItemForm(){
    $('#menu-item-form').validate({
        rules: {
            menu_item_name: {
                required: true
            },
            app_module: {
                required: true
            },
            order_sequence: {
                required: true
            }
        },
        messages: {
            menu_item_name: {
                required: 'Please enter the display name'
            },
            app_module: {
                required: 'Please choose the app module'
            },
            order_sequence: {
                required: 'Please enter the order sequence'
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
            const menu_item_id = $('#menu-item-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update menu item';
          
            $.ajax({
                type: 'POST',
                url: 'components/menu-item/controller/menu-item-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&menu_item_id=' + menu_item_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get menu item details');
                        $('#menu-item-modal').modal('hide');
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
                }
            });
        
            return false;
        }
    });
}

function rolePermissionAssignmentForm(){
    $('#role-permission-assignment-form').validate({
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
            const menu_item_id = $('#menu-item-id').text();
            const transaction = 'assign menu item role permission';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&menu_item_id=' + menu_item_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
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
                    enableFormSubmitButton('submit-data');
                }
            });
        
            return false;
        }
    });
}

function submenuItemTable(datatable_name, buttons = false, show_all = false){
    toggleHideActionDropdown();

    const type = 'submenu item table';
    const menu_item_id = $('#menu-item-id').text();
    var settings;

    const column = [ 
        { 'data' : 'MENU_ITEM_NAME' },
        { 'data' : 'ORDER_SEQUENCE' },
    ];

    const column_definition = [
        { 'width': 'auto', 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/menu-item/view/_menu_item_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {'type' : type, 'menu_item_id' : menu_item_id},
            'dataSrc' : '',
            'error': function(xhr, status, error) {
                var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                if (xhr.responseText) {
                    fullErrorMessage += `, Response: ${xhr.responseText}`;
                }
                showErrorDialog(fullErrorMessage);
            }
        },
        'order': [[ 1, 'asc' ]],
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
        settings.dom = "<'row'<'col-sm-6'f><'col-sm-6 text-right'B>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>";
        settings.buttons = ['csv', 'excel', 'pdf'];
    }

    destroyDatatable(datatable_name);

    $(datatable_name).dataTable(settings);
}

function assignedRolePermissionTable(datatable_name, buttons = false, show_all = false){
    const menu_item_id = $('#menu-item-id').text();
    const type = 'assigned role permission table';
    var settings;

    const column = [ 
        { 'data' : 'ROLE' },
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
            'data': {'type' : type, 'menu_item_id' : menu_item_id},
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
        settings.dom = "<'row'<'col-sm-6'f><'col-sm-6 text-right'B>>" + "<'row'<'col-sm-12'tr>>" + "<'row'<'col-sm-5'i><'col-sm-7'p>>";
        settings.buttons = ['csv', 'excel', 'pdf'];
    }

    destroyDatatable(datatable_name);

    $(datatable_name).dataTable(settings);
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get menu item details':
            var menu_item_id = $('#menu-item-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/menu-item/controller/menu-item-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    menu_item_id : menu_item_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('menu-item-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#menu_item_name').val(response.menuItemName);
                        $('#menu_item_url').val(response.menuItemURL);
                        $('#order_sequence').val(response.orderSequence);
                        
                        $('#app_module').val(response.appModuleID).trigger('change');
                        $('#parent_id').val(response.parentID).trigger('change');
                        
                        $('#menu_item_name_summary').text(response.menuItemName);
                        $('#app_module_summary').text(response.appModuleName);
                        $('#parent_menu_item_summary').text(response.parentName);
                        $('#menu_item_url_summary').text(response.menuItemURL);
                        $('#order_sequence_summary').text(response.orderSequence);
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
        case 'app module options':
            
            $.ajax({
                url: 'components/app-module/view/_app_module_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#app_module').select2({
                        dropdownParent: $('#menu-item-modal'),
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
        case 'menu item options':
            
            $.ajax({
                url: 'components/menu-item/view/_menu_item_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#parent_id').select2({
                        dropdownParent: $('#menu-item-modal'),
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
        case 'menu item role dual listbox options':
            const menu_item_id = $('#menu-item-id').text();
    
            $.ajax({
                url: 'components/role/view/_role_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    menu_item_id : menu_item_id
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