(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('block style options');

        displayDetails('get content carousel details');

        if($('#content-carousel-item-table').length){
            contentCarouselItemTable('#content-carousel-item-table');
        }

        if($('#content-carousel-form').length){
            contentContentCarouselForm();
        }

        if($('#content-carousel-item-form').length){
            contentCarouselItemForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get content carousel details');
        });

        $(document).on('click','#delete-content-carousel',function() {
            const content_carousel_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete content carousel';
    
            Swal.fire({
                title: 'Confirm Content Carousel Deletion',
                text: 'Are you sure you want to delete this content carousel?',
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
                        url: 'components/content-carousel/controller/content-carousel-controller.php',
                        dataType: 'json',
                        data: {
                            content_carousel_id : content_carousel_id, 
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

        $(document).on('click','#add-content-carousel-item',function() {
            $('#content-carousel-item-title').text('Add Content Carousel Item');
            resetModalForm('content-carousel-item-form');
        });

        $(document).on('click','.edit-content-carousel-item',function() {
            const content_carousel_item_id = $(this).data('content-carousel-item-id');
            sessionStorage.setItem('content_carousel_item_id', content_carousel_item_id);

            $('#content-carousel-item-title').text('Edit Content Carousel Item');

            displayDetails('get content carousel item details');
        });

        $(document).on('click','.delete-content-carousel-item',function() {
            const content_carousel_id = $('#details-id').text();
            const content_carousel_item_id = $(this).data('content-carousel-item-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete content carousel item';
    
            Swal.fire({
                title: 'Confirm Content Carousel Item Deletion',
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
                        url: 'components/content-carousel/controller/content-carousel-controller.php',
                        dataType: 'json',
                        data: {
                            content_carousel_id : content_carousel_id, 
                            content_carousel_item_id : content_carousel_item_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#content-carousel-item-table');
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

        $(document).on('click','#unpublish-content-carousel',function() {
            const content_carousel_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'unpublish content carousel';
    
            Swal.fire({
                title: 'Confirm Content Carousel Unpublish',
                text: 'Are you sure you want to unpublish this content carousel?',
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
                        url: 'components/content-carousel/controller/content-carousel-controller.php',
                        dataType: 'json',
                        data: {
                            content_carousel_id : content_carousel_id, 
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

        $(document).on('click','#publish-content-carousel',function() {
            const content_carousel_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'publish content carousel';
    
            Swal.fire({
                title: 'Confirm Content Carousel Publish',
                text: 'Are you sure you want to unpublish this content carousel?',
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
                        url: 'components/content-carousel/controller/content-carousel-controller.php',
                        dataType: 'json',
                        data: {
                            content_carousel_id : content_carousel_id, 
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
            $(document).on('click','.view-content-carousel-item-log-notes',function() {
                const content_carousel_item_id = $(this).data('content-carousel-item-id');

                logNotes('content_carousel_item', content_carousel_item_id);
            });
        }

        if($('#log-notes-main').length){
            const content_carousel_id = $('#details-id').text();

            logNotesMain('content_carousel', content_carousel_id);
        }

        if($('#internal-notes').length){
            const content_carousel_id = $('#details-id').text();

            internalNotes('content_carousel', content_carousel_id);
        }

        if($('#internal-notes-form').length){
            const content_carousel_id = $('#details-id').text();

            internalNotesForm('content_carousel', content_carousel_id);
        }
    });
})(jQuery);

function contentContentCarouselForm(){
    $('#content-carousel-form').validate({
        rules: {
            content_carousel_name: {
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
            content_carousel_name: {
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
            const content_carousel_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update content carousel';
          
            $.ajax({
                type: 'POST',
                url: 'components/content-carousel/controller/content-carousel-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&content_carousel_id=' + content_carousel_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get content carousel details');
                        $('#content-carousel-modal').modal('hide');
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
                    logNotesMain('content_carousel', content_carousel_id);
                }
            });
        
            return false;
        }
    });
}

function contentCarouselItemForm(){
    $('#content-carousel-item-form').validate({
        rules: {
            content_carousel_title: {
                required: true
            },
            content_carousel_heading: {
                required: true
            },
            content_carousel_paragraph: {
                required: true
            },
            content_carousel_image: {
                required: function(element) {
                    return $('#content_carousel_item_id').val() === '';
                }
            },
            order_sequence: {
                required: true
            }
        },
        messages: {
            content_carousel_title: {
                required: 'Enter the title'
            },
            content_carousel_heading: {
                required: 'Enter the heading'
            },
            content_carousel_paragraph: {
                required: 'Enter the paragraph'
            },
            content_carousel_image: {
                required: 'Enter the content carousel image'
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
            const content_carousel_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'save content carousel item';
            var formData = new FormData(form);
            formData.append('content_carousel_id', content_carousel_id);
            formData.append('transaction', transaction);
          
            $.ajax({
                type: 'POST',
                url: 'components/content-carousel/controller/content-carousel-controller.php',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-content-carousel-item-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#content-carousel-item-modal').modal('hide');
                        reloadDatatable('#content-carousel-item-table');
                        resetModalForm('content-carousel-item-form');
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
                    enableFormSubmitButton('submit-content-carousel-item-data');
                }
            });
        
            return false;
        }
    });
}

function contentCarouselItemTable(datatable_name, buttons = false, show_all = false){
    toggleHideActionDropdown();

    const type = 'content carousel item table';
    const content_carousel_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const page_link = document.getElementById('page-link').getAttribute('href');

    var settings;

    const column = [ 
        { 'data' : 'CAROUSEL_ITEM' },
        { 'data' : 'CALL_TO_ACTION_1' },
        { 'data' : 'CALL_TO_ACTION_2' },
        { 'data' : 'CAROUSEL_IMAGE' },
        { 'data' : 'ORDER_SEQUENCE' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': 'auto', 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 },
        { 'width': 'auto', 'aTargets': 2 },
        { 'width': 'auto', 'aTargets': 3 },
        { 'width': '10%', 'aTargets': 4 },
        { 'width': '10%','bSortable': false, 'aTargets': 5 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/content-carousel/view/_content_carousel_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {
                'type' : type,
                'page_id' : page_id,
                'page_link' : page_link,
                'content_carousel_id' : content_carousel_id
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
        case 'get content carousel details':
            var content_carousel_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/content-carousel/controller/content-carousel-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    content_carousel_id : content_carousel_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('content-carousel-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#content_carousel_name').val(response.contentCarouselName);
                        $('#description').val(response.description);
                        
                        $('#block_style_id').val(response.blockStyleID).trigger('change');
                        
                        $('#content_carousel_name_summary').text(response.contentCarouselName);
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
        case 'get content carousel item details':
            var content_carousel_id = $('#details-id').text();
            var content_carousel_item_id = sessionStorage.getItem('content_carousel_item_id');
            
            $.ajax({
                url: 'components/content-carousel/controller/content-carousel-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    content_carousel_id : content_carousel_id, 
                    content_carousel_item_id : content_carousel_item_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('content-carousel-item-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#content_carousel_item_id').val(content_carousel_item_id);

                        $('#content_carousel_title').val(response.contentCarouselTitle);
                        $('#content_carousel_heading').val(response.contentCarouselHeading);
                        $('#content_carousel_paragraph').val(response.contentCarouselParagraph);
                        $('#call_to_action_button_1_text').val(response.callToActionButton1Text);
                        $('#call_to_action_button_1_link').val(response.callToActionButton1Link);
                        $('#call_to_action_button_2_text').val(response.callToActionButton2Text);
                        $('#call_to_action_button_2_link').val(response.callToActionButton2Link);
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
                            $('#content-carousel-item-modal').modal('hide');
                            reloadDatatable('#content-carousel-item-table');
                            resetModalForm('content-carousel-item-form');
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
            var block_type_id = '6';

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
                        dropdownParent: $('#content-carousel-modal'),
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