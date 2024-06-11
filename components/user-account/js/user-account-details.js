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

        if($('#user-account-assignment-form').length){
            userAccountAssignmentForm();
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

        $(document).on('click','#delete-user-account',function() {
            const user_account_id = $('#user-account-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete user account';
    
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
                        url: 'components/user-account/controller/user-account-controller.php',
                        dataType: 'json',
                        data: {
                            user_account_id : user_account_id, 
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

        $(document).on('click','.delete-role-user-account',function() {
            const role_user_account_id = $(this).data('role-user-account-id');
            const transaction = 'delete user account role';
    
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
                            role_user_account_id : role_user_account_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                roleList();
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    roleList();
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

        $(document).on('click','#activate-user-account',function() {
            const user_account_id = $('#user-account-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'activate user account';
    
            Swal.fire({
                title: 'Confirm User Account Activation',
                text: 'Are you sure you want to activate this user account?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Activate',
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
                        url: 'components/user-account/controller/user-account-controller.php',
                        dataType: 'json',
                        data: {
                            user_account_id : user_account_id, 
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

        $(document).on('click','#deactivate-user-account',function() {
            const user_account_id = $('#user-account-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'deactivate user account';
    
            Swal.fire({
                title: 'Confirm User Account Deactivation',
                text: 'Are you sure you want to deactivate this user account?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Deactivate',
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
                        url: 'components/user-account/controller/user-account-controller.php',
                        dataType: 'json',
                        data: {
                            user_account_id : user_account_id, 
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

        $(document).on('click','#lock-user-account',function() {
            const user_account_id = $('#user-account-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'lock user account';
    
            Swal.fire({
                title: 'Confirm User Account Lock',
                text: 'Are you sure you want to lock this user account?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Lock',
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
                        url: 'components/user-account/controller/user-account-controller.php',
                        dataType: 'json',
                        data: {
                            user_account_id : user_account_id, 
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

        $(document).on('click','#unlock-user-account',function() {
            const user_account_id = $('#user-account-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'unlock user account';
    
            Swal.fire({
                title: 'Confirm User Account Unlock',
                text: 'Are you sure you want to unlock this user account?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Unlock',
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
                        url: 'components/user-account/controller/user-account-controller.php',
                        dataType: 'json',
                        data: {
                            user_account_id : user_account_id, 
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

        $(document).on('change','#two-factor-authentication',function() {
            const user_account_id = $('#user-account-id').text();
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
                }
            });
        });

        $(document).on('change','#multiple-login-sessions',function() {
            const user_account_id = $('#user-account-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            var checkbox = document.getElementById('multiple-login-sessions');
            var transaction = (checkbox).checked ? 'enable multiple login sessions' : 'disable multiple login sessions';

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
                }
            });
        });

        $(document).on('click','#assign-user-account',function() {
            generateDropdownOptions('user account role dual listbox options');
        });

        if($('#role-list').length){
            roleList();
        }

        if($('#log-notes-offcanvas').length && $('#view-log-notes').length){
            $(document).on('click','#view-log-notes',function() {
                const user_account_id = $('#user-account-id').text();

                logNotes('user_account', user_account_id);
            });
        }

        if($('#internal-notes').length){
            const user_account_id = $('#user-account-id').text();

            internalNotes('user_account', user_account_id);
        }

        if($('#internal-notes-form').length){
            const user_account_id = $('#user-account-id').text();

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
            email: {
                required: true
            }
        },
        messages: {
            file_as: {
                required: 'Please enter the display name'
            },
            email: {
                required: 'Please enter the email'
            }
        },
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
            const user_account_id = $('#user-account-id').text();
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
            const user_account_id = $('#user-account-id').text();
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
            const user_account_id = $('#user-account-id').text();
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
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get user account details');
                        $('#user-account-profile-picture-modal').modal('hide');
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
0        }
    });
}

function userAccountAssignmentForm(){
    $('#user-account-assignment-form').validate({
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
            const user_account_id = $('#user-account-id').text();
            const transaction = 'assign user account role';
          
            $.ajax({
                type: 'POST',
                url: 'components/role/controller/role-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&user_account_id=' + user_account_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-user-account-assignment');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        roleList();
                        $('#user-account-assignment-modal').modal('hide');
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
                    enableFormSubmitButton('submit-user-account-assignment');
                }
            });
        
            return false;
        }
    });
}

function roleList(){
    const user_account_id = $('#user-account-id').text();
    const type = 'assigned role user account list';

    $.ajax({
        type: 'POST',
        url: 'components/role/view/_role_generation.php',
        dataType: 'json',
        data: { type: type, 'user_account_id': user_account_id },
        success: function (result) {
            document.getElementById('role-list').innerHTML = result[0].ROLE_USER_ACCOUNT;
        }
    });
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get user account details':
            var user_account_id = $('#user-account-id').text();
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

                        document.getElementById('active_summary').innerHTML = response.activeBadge;
                        document.getElementById('locked_summary').innerHTML = response.lockedBadge;
                        
                        $('#file_as_summary').text(response.fileAs);
                        $('#email_summary').text(response.email);
                        $('#password_expiry_summary').text(response.passwordExpiryDate);
                        $('#last_connection_date_summary').text(response.lastConnectionDate);
                        $('#last_password_reset_summary').text(response.lastPasswordReset);
                        $('#account_lock_duration_summary').text(response.accountLockDuration);

                        document.getElementById('user_account_profile_picture').src = response.profilePicture;

                        document.getElementById('two-factor-authentication').checked = response.twoFactorAuthentication === 'Yes';
                        document.getElementById('multiple-login-sessions').checked = response.multipleSession === 'Yes';
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
        case 'user account role dual listbox options':
            var user_account_id = $('#user-account-id').text();

            $.ajax({
                url: 'components/role/view/_role_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    user_account_id : user_account_id
                },
                success: function(response) {
                    var select = document.getElementById('role_id');
                    select.innerHTML = '';

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