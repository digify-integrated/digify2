(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('block style options');

        displayDetails('get customer inquiry details');

        if($('#customer-inquiry-item-table').length){
            servicesBoxItemTable('#customer-inquiry-item-table');
        }

        if($('#customer-inquiry-form').length){
            servicesBoxForm();
        }

        if($('#customer-inquiry-item-form').length){
            servicesBoxItemForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get customer inquiry details');
        });

        $(document).on('click','#delete-customer-inquiry',function() {
            const customer_inquiry_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete customer inquiry';
    
            Swal.fire({
                title: 'Confirm Customer Inquiry Deletion',
                text: 'Are you sure you want to delete this customer inquiry?',
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
                        url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                        dataType: 'json',
                        data: {
                            customer_inquiry_id : customer_inquiry_id, 
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

        $(document).on('click','#add-customer-inquiry-item',function() {
            $('#customer-inquiry-item-title').text('Add Customer Inquiry Item');
            resetModalForm('customer-inquiry-item-form');
        });

        $(document).on('click','.edit-customer-inquiry-item',function() {
            const customer_inquiry_item_id = $(this).data('customer-inquiry-item-id');
            sessionStorage.setItem('customer_inquiry_item_id', customer_inquiry_item_id);

            $('#customer-inquiry-item-title').text('Edit Customer Inquiry Item');

            displayDetails('get customer inquiry item details');
        });

        $(document).on('click','.delete-customer-inquiry-item',function() {
            const customer_inquiry_id = $('#details-id').text();
            const customer_inquiry_item_id = $(this).data('customer-inquiry-item-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete customer inquiry item';
    
            Swal.fire({
                title: 'Confirm Customer Inquiry Item Deletion',
                text: 'Are you sure you want to delete this carousel item?',
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
                        url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                        dataType: 'json',
                        data: {
                            customer_inquiry_id : customer_inquiry_id, 
                            customer_inquiry_item_id : customer_inquiry_item_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#customer-inquiry-item-table');
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

        $(document).on('click','#unpublish-customer-inquiry',function() {
            const customer_inquiry_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'unpublish customer inquiry';
    
            Swal.fire({
                title: 'Confirm Customer Inquiry Unpublish',
                text: 'Are you sure you want to unpublish this customer inquiry?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Unpublish',
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
                        url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                        dataType: 'json',
                        data: {
                            customer_inquiry_id : customer_inquiry_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location.reload();
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

        $(document).on('click','#publish-customer-inquiry',function() {
            const customer_inquiry_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'publish customer inquiry';
    
            Swal.fire({
                title: 'Confirm Customer Inquiry Publish',
                text: 'Are you sure you want to unpublish this customer inquiry?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Publish',
                cancelButtonText: 'Cancel',
                customClass: {
                    confirmButton: 'btn btn-success mt-2',
                    cancelButton: 'btn btn-secondary ms-2 mt-2'
                },
                buttonsStyling: !1
            }).then(function(result) {
                if (result.value) {
                    $.ajax({
                        type: 'POST',
                        url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                        dataType: 'json',
                        data: {
                            customer_inquiry_id : customer_inquiry_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                setNotification(response.title, response.message, response.messageType);
                                window.location.reload();
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

        if($('#log-notes-offcanvas').length){
            $(document).on('click','.view-customer-inquiry-item-log-notes',function() {
                const customer_inquiry_item_id = $(this).data('customer-inquiry-item-id');

                logNotes('customer_inquiry_item', customer_inquiry_item_id);
            });
        }

        if($('#log-notes-main').length){
            const customer_inquiry_id = $('#details-id').text();

            logNotesMain('customer_inquiry', customer_inquiry_id);
        }

        if($('#internal-notes').length){
            const customer_inquiry_id = $('#details-id').text();

            internalNotes('customer_inquiry', customer_inquiry_id);
        }

        if($('#internal-notes-form').length){
            const customer_inquiry_id = $('#details-id').text();

            internalNotesForm('customer_inquiry', customer_inquiry_id);
        }
    });
})(jQuery);

function servicesBoxForm(){
    $('#customer-inquiry-form').validate({
        rules: {
            customer_inquiry_name: {
                required: true
            },
            block_style_id: {
                required: true
            },
            description: {
                required: true
            }
        },
        messages: {
            customer_inquiry_name: {
                required: 'Enter the display name'
            },
            block_style_id: {
                required: 'Choose the block style'
            },
            description: {
                required: 'Enter the description'
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
            const customer_inquiry_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update customer inquiry';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&customer_inquiry_id=' + customer_inquiry_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get customer inquiry details');
                        $('#customer-inquiry-modal').modal('hide');
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
                    logNotesMain('customer_inquiry', customer_inquiry_id);
                }
            });
        
            return false;
        }
    });
}

function servicesBoxItemForm(){
    $('#customer-inquiry-item-form').validate({
        rules: {
            customer_inquiry_title: {
                required: true
            },
            customer_inquiry_heading: {
                required: true
            },
            customer_inquiry_paragraph: {
                required: true
            },
            customer_inquiry_image: {
                required: function(element) {
                    return $('#customer_inquiry_item_id').val() === '';
                }
            },
            order_sequence: {
                required: true
            }
        },
        messages: {
            customer_inquiry_title: {
                required: 'Enter the title'
            },
            customer_inquiry_heading: {
                required: 'Enter the heading'
            },
            customer_inquiry_paragraph: {
                required: 'Enter the paragraph'
            },
            customer_inquiry_image: {
                required: 'Enter the customer inquiry image'
            },
            order_sequence: {
                required: 'Enter the order sequence'
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
            const customer_inquiry_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save customer inquiry item';
            var formData = new FormData(form);
            formData.append('customer_inquiry_id', customer_inquiry_id);
            formData.append('transaction', transaction);
          
            $.ajax({
                type: 'POST',
                url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-customer-inquiry-item-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#customer-inquiry-item-modal').modal('hide');
                        reloadDatatable('#customer-inquiry-item-table');
                        resetModalForm('customer-inquiry-item-form');
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
                    enableFormSubmitButton('submit-customer-inquiry-item-data');
                }
            });
        
            return false;
        }
    });
}

function servicesBoxItemTable(datatable_name, buttons = false, show_all = false){
    toggleHideActionDropdown();

    const type = 'customer inquiry item table';
    const customer_inquiry_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const page_link = document.getElementById('page-link').getAttribute('href');

    var settings;

    const column = [ 
        { 'data' : 'customer_inquiry' },
        { 'data' : 'CALL_TO_ACTION' },
        { 'data' : 'customer_inquiry_IMAGE' },
        { 'data' : 'ORDER_SEQUENCE' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': 'auto', 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 },
        { 'width': 'auto', 'aTargets': 2 },
        { 'width': '10%', 'aTargets': 3 },
        { 'width': '10%','bSortable': false, 'aTargets': 4 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/customer-inquiry/view/_customer_inquiry_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {
                'type' : type,
                'page_id' : page_id,
                'page_link' : page_link,
                'customer_inquiry_id' : customer_inquiry_id
            },
            'dataSrc' : '',
            'error': function(xhr, status, error) {
                var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                if (xhr.responseText) {
                    fullErrorMessage += `, Response: ${xhr.responseText}`;
                }
                showErrorDialog(fullErrorMessage);
            }
        },
        'dom': 'Brtip',
        'lengthChange': false,
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
        settings.dom = 'Bfrtip';
        settings.buttons = ['csv', 'excel', 'pdf'];
    }

    destroyDatatable(datatable_name);

    $(datatable_name).dataTable(settings);
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get customer inquiry details':
            var customer_inquiry_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_inquiry_id : customer_inquiry_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('customer-inquiry-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#customer_inquiry_name').val(response.servicesBoxName);
                        $('#description').val(response.description);
                        
                        $('#block_style_id').val(response.blockStyleID).trigger('change');
                        
                        $('#customer_inquiry_name_summary').text(response.servicesBoxName);
                        $('#block_style_name_summary').text(response.blockStyleName);
                        $('#description_summary').text(response.description);
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
        case 'get customer inquiry item details':
            var customer_inquiry_id = $('#details-id').text();
            var customer_inquiry_item_id = sessionStorage.getItem('customer_inquiry_item_id');
            
            $.ajax({
                url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    customer_inquiry_id : customer_inquiry_id, 
                    customer_inquiry_item_id : customer_inquiry_item_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('customer-inquiry-item-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#customer_inquiry_item_id').val(customer_inquiry_item_id);

                        $('#customer_inquiry_title').val(response.servicesBoxTitle);
                        $('#customer_inquiry_heading').val(response.servicesBoxHeading);
                        $('#customer_inquiry_paragraph').val(response.servicesBoxParagraph);
                        $('#call_to_action_button_text').val(response.callToActionButtonText);
                        $('#call_to_action_button_link').val(response.callToActionButtonLink);
                        $('#order_sequence').val(response.orderSequence);
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
                        else if (response.detailsNotExist) {
                            showNotification(response.title, response.message, response.messageType);
                            $('#customer-inquiry-item-modal').modal('hide');
                            reloadDatatable('#customer-inquiry-item-table');
                            resetModalForm('customer-inquiry-item-form');
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
        case 'block style options':
            var block_type_id = '13';

            $.ajax({
                url: 'components/block-style/view/_block_style_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    block_type_id : block_type_id
                },
                success: function(response) {
                    $('#block_style_id').select2({
                        dropdownParent: $('#customer-inquiry-modal'),
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