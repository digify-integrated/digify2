(function($) {
    'use strict';

    $(function() {
        displayDetails('get language proficiency details');

        if($('#language-proficiency-form').length){
            languageProficiencyForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get language proficiency details');
        });

        $(document).on('click','#delete-language-proficiency',function() {
            const language_proficiency_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'delete language proficiency';
    
            Swal.fire({
                title: 'Confirm Language Proficiency Deletion',
                text: 'Are you sure you want to delete this language proficiency?',
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
                        url: 'components/language-proficiency/controller/language-proficiency-controller.php',
                        dataType: 'json',
                        data: {
                            language_proficiency_id : language_proficiency_id, 
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
            const language_proficiency_id = $('#details-id').text();

            logNotesMain('language_proficiency', language_proficiency_id);
        }

        if($('#internal-notes').length){
            const language_proficiency_id = $('#details-id').text();

            internalNotes('language_proficiency', language_proficiency_id);
        }

        if($('#internal-notes-form').length){
            const language_proficiency_id = $('#details-id').text();

            internalNotesForm('language_proficiency', language_proficiency_id);
        }
    });
})(jQuery);

function languageProficiencyForm(){
    $('#language-proficiency-form').validate({
        rules: {
            language_proficiency_name: {
                required: true
            },
            language_proficiency_description: {
                required: true
            }
        },
        messages: {
            language_proficiency_name: {
                required: 'Display Name'
            },
            language_proficiency_description: {
                required: 'Description'
            }
        },
        errorPlacement: function(error, element) {
            var errorList = [];
            $.each(this.errorMap, function(key, value) {
                errorList.push('<li style="list-style: disc; margin-left: 30px;">' + value + '</li>');
            }.bind(this));
            showNotification('Invalid fields:', '<ul style="margin-bottom: 0px;">' + errorList.join('') + '</ul>', 'error', 1500);
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
            const language_proficiency_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            const transaction = 'update language proficiency';
          
            $.ajax({
                type: 'POST',
                url: 'components/language-proficiency/controller/language-proficiency-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&language_proficiency_id=' + language_proficiency_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get language proficiency details');
                        $('#language-proficiency-modal').modal('hide');
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
                    logNotesMain('language_proficiency', language_proficiency_id);
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get language proficiency details':
            var language_proficiency_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href'); 
            
            $.ajax({
                url: 'components/language-proficiency/controller/language-proficiency-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    language_proficiency_id : language_proficiency_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('language-proficiency-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#language_proficiency_name').val(response.languageProficiencyName);
                        $('#language_proficiency_description').val(response.languageProficiencyDescription);
                        
                        $('#language_proficiency_name_summary').text(response.languageProficiencyName);
                        $('#language_proficiency_description_summary').text(response.languageProficiencyDescription);
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