(function($) {
    'use strict';

    $(function() {
        displayDetails('get user account details');

        if($('#user-account-form').length){
            userAccountForm();
        }

        if($('#change-password-form').length){
            changePasswordForm();
        }

        if($('#user-account-profile-picture-form').length){
            updateUserAccountProfilPictureForm();
        }

        $(document).on('click','#edit-details',function() {
            displayDetails('get user account details');
        });

        $(document).on('click','#change-password',function() {
            resetModalForm('change-password-form');
        });

        $(document).on('click','#update-user-account-profile-picture',function() {
            resetModalForm('user-account-profile-picture-form');
        });

        $(document).on('change','#two-factor-authentication',function() {
            const user_account_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            var checkbox = document.getElementById('two-factor-authentication');
            var transaction = (checkbox).checked ? 'enable two factor authentication' : 'disable two factor authentication';

            $.ajax({
                type: 'POST',
                url: 'components/user-account/controller/user-account-controller.php',
                data: {
                    user_account_id : user_account_id,
                    transaction : transaction
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
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
                complete: function(){
                    logNotesMain('user_account', user_account_id);
                }
            });
        });

        if($('#log-notes-main').length){
            const user_account_id = $('#details-id').text();

            logNotesMain('user_account', user_account_id);
        }

        if($('#internal-notes').length){
            const user_account_id = $('#details-id').text();

            internalNotes('user_account', user_account_id);
        }

        if($('#internal-notes-form').length){
            const user_account_id = $('#details-id').text();

            internalNotesForm('user_account', user_account_id);
        }
    });
})(jQuery);

function userAccountForm(){
    $('#user-account-form').validate({
        rules: {
            file_as: {
                required: true
            },
            username: {
                required: true
            },
            email: {
                required: true
            },
            password: {
                required: true,
                password_strength: true
            }
        },
        messages: {
            file_as: {
                required: 'Please enter the display name'
            },
            username: {
                required: 'Please enter the username'
            },
            email: {
                required: 'Please enter the email'
            },
            password: {
                required: 'Please enter the password'
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
            const user_account_id = $('#details-id').text();
            const transaction = 'update user account';
          
            $.ajax({
                type: 'POST',
                url: 'components/user-account/controller/user-account-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction +'&user_account_id=' + user_account_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get user account details');
                        $('#user-account-modal').modal('hide');
                    }
                    else {
                        if (response.isInactive || response.notExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
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
                    logNotesMain('user_account', user_account_id);
                }
            });
        
            return false;
        }
    });
}

function changePasswordForm(){
    $('#change-password-form').validate({
        rules: {
            new_password: {
                required: true,
                password_strength: true
            },
            confirm_password: {
                required: true,
                equalTo: '#new_password'
            }
          },
        messages: {
            new_password: {
                required: 'Please enter password'
            },
            confirm_password: {
                required: 'Please re-enter your password for confirmation',
                equalTo: 'The passwords you entered do not match'
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
            const user_account_id = $('#details-id').text();
            const transaction = 'change password';
    
            $.ajax({
                type: 'POST',
                url: 'components/user-account/controller/user-account-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction +'&user_account_id=' + user_account_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-change-password');
                },
                success: function(response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        $('#change-password-modal').modal('hide');
                        
                    }
                    else {
                        if (response.isInactive || response.notExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('submit-change-password');
                }
            });
    
            return false;
        }
    });
}

function updateUserAccountProfilPictureForm(){
    $('#user-account-profile-picture-form').validate({
        rules: {
            profile_picture: {
                required: true
            }
        },
        messages: {
            profile_picture: {
                required: 'Please choose the profile picture'
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
            const user_account_id = $('#details-id').text();
            const transaction = 'update user account profile picture';
            var formData = new FormData(form);
            formData.append('user_account_id', user_account_id);
            formData.append('transaction', transaction);
        
            $.ajax({
                type: 'POST',
                url: 'components/user-account/controller/user-account-controller.php',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-profile-picture');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        $('#user-account-profile-picture-modal').modal('hide');
                        window.location.reload();
                    }
                    else {
                        if (response.isInactive || response.notExist || response.userInactive || response.userLocked || response.sessionExpired) {
                            setNotification(response.title, response.message, response.messageType);
                            window.location = 'logout.php?logout';
                        }
                        else {
                            showNotification(response.title, response.message, response.messageType);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    handleSystemError(xhr, status, error);
                },
                complete: function() {
                    enableFormSubmitButton('submit-profile-picture');
                }
            });
        
            return false;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get user account details':
            var user_account_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/user-account/controller/user-account-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    user_account_id : user_account_id, 
                    transaction : transaction
                },
                success: function(response) {
                    if (response.success) {
                        $('#file_as').val(response.fileAs);
                        $('#email').val(response.email);
                        $('#username').val(response.username);

                        document.getElementById('active_summary').innerHTML = response.activeBadge;
                        document.getElementById('locked_summary').innerHTML = response.lockedBadge;
                        
                        $('#file_as_summary').text(response.fileAs);
                        $('#email_summary').text(response.email);
                        $('#username_summary').text(response.username);
                        $('#password_expiry_summary').text(response.passwordExpiryDate);
                        $('#last_connection_date_summary').text(response.lastConnectionDate);
                        $('#last_password_reset_summary').text(response.lastPasswordReset);
                        $('#account_lock_duration_summary').text(response.accountLockDuration);

                        document.getElementById('user_account_profile_picture').src = response.profilePicture;

                        document.getElementById('two-factor-authentication').checked = response.twoFactorAuthentication === 'Yes';
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