(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('block type options');

        displayDetails('get block style details');
        displayDetails('get block container details');
        displayDetails('get block item details');

        if($('#block-style-form').length){
            blockStyleForm();
        }

        if($('#block-container-form').length){
            blockContainerForm();
        }

        if($('#block-item-form').length){
            blockItemForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get block style details');
        });

        $(document).on('click','#edit-block-container-details',function() {
            displayDetails('get block container details');
        });

        $(document).on('click','#edit-block-item-details',function() {
            displayDetails('get block item details');
        });

        $(document).on('click','#delete-block-style',function() {
            const block_style_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete block style';
    
            Swal.fire({
                title: 'Confirm Block Style Deletion',
                text: 'Are you sure you want to delete this block style?',
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
                        url: 'components/block-style/controller/block-style-controller.php',
                        dataType: 'json',
                        data: {
                            block_style_id : block_style_id, 
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
            const block_style_id = $('#details-id').text();

            logNotesMain('block_style', block_style_id);
        }

        if($('#internal-notes').length){
            const block_style_id = $('#details-id').text();

            internalNotes('block_style', block_style_id);
        }

        if($('#internal-notes-form').length){
            const block_style_id = $('#details-id').text();

            internalNotesForm('block_style', block_style_id);
        }

        if($('#block_container').length){
            var editor = CodeMirror.fromTextArea(document.getElementById("block_container"), {
                mode: "htmlmixed",
                theme: "default",
                lineNumbers: true,
                lineWrapping: false,
                viewportMargin: 10,
                height: "300px"
            });
        }

        if($('#block_item').length){
            var editor = CodeMirror.fromTextArea(document.getElementById("block_item"), {
                mode: "htmlmixed",
                theme: "default",
                lineNumbers: true,
                lineWrapping: false,
                viewportMargin: 10,
                height: "300px"
            });
        }
    });
})(jQuery);

function blockStyleForm(){
    $('#block-style-form').validate({
        rules: {
            block_style_name: {
                required: true
            },
            block_type_id: {
                required: true
            }
        },
        messages: {
            block_style_name: {
                required: 'Enter the display name'
            },
            block_type_id: {
                required: 'Choose the block type'
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
            const block_style_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update block style';
          
            $.ajax({
                type: 'POST',
                url: 'components/block-style/controller/block-style-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&block_style_id=' + block_style_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get block style details');
                        $('#block-style-modal').modal('hide');
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
                    logNotesMain('block_style', block_style_id);
                }
            });
        
            return false;
        }
    });
}

function blockContainerForm(){
    $('#block-container-form').validate({
        rules: {
            block_container: {
                required: true
            }
        },
        messages: {
            block_container: {
                required: 'Enter the block container'
            },
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
            const block_style_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update block container';

            // Get the values of the CodeMirror editors
            const blockContainerValue = $('#block_container').val();

            // Include the values in the serialized form data
            const formData = $(form).serialize() + 
                '&block_container=' + encodeURIComponent(blockContainerValue) + 
                '&transaction=' + transaction + 
                '&block_style_id=' + block_style_id;
          
            $.ajax({
                type: 'POST',
                url: 'components/block-style/controller/block-style-controller.php',
                data: formData,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-block-container-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get block container details');
                        $('#block-container-modal').modal('hide');
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
                    enableFormSubmitButton('submit-block-container-data');
                }
            });
        
            return false;
        }
    });
}

function blockItemForm(){
    $('#block-item-form').validate({
        rules: {
            block_item: {
                required: true
            }
        },
        messages: {
            block_item: {
                required: 'Enter the block item'
            },
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
            const block_style_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update block item';
          
            $.ajax({
                type: 'POST',
                url: 'components/block-style/controller/block-style-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&block_style_id=' + block_style_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-block-item-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get block item details');
                        $('#block-item-modal').modal('hide');
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
                    enableFormSubmitButton('submit-block-item-data');
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get block style details':
            var block_style_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/block-style/controller/block-style-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    block_style_id : block_style_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('block-style-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#block_style_name').val(response.blockStyleName);
                        $('#description').val(response.description);

                        $('#block_type_id').val(response.blockTypeID).trigger('change');
                        
                        $('#block_style_name_summary').text(response.blockStyleName);
                        $('#description_summary').text(response.description);
                        $('#block_type_name_summary').text(response.blockTypeName);
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
        case 'get block container details':
            var block_style_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/block-style/controller/block-style-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    block_style_id : block_style_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('block-container-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#block_container').val(response.blockContainer);
                        
                        $('#block_container_summary').text(response.blockContainer);
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
        case 'get block item details':
            var block_style_id = $('#details-id').text();
            var page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/block-style/controller/block-style-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    block_style_id : block_style_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('block-item-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#block_item').val(response.blockItem);
                        
                        $('#block_item_summary').text(response.blockItem);
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
        case 'block type options':
            var department_id = $('#details-id').text();

            $.ajax({
                url: 'components/block-type/view/_block_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    department_id : department_id
                },
                success: function(response) {
                    $('#block_type_id').select2({
                        dropdownParent: $('#block-style-modal'),
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