$(document).ready(function () {
    $(document).on('click','#resend-verification',function() {
        const user_account_id = $('#user_account_id').val();
        const transaction = 'resend registration verification';

        Swal.fire({
            title: 'Confirm Registration Verification Link Resend',
            text: 'Are you sure you want to resend the registration verification link?',
            icon: 'warning',
            showCancelButton: !0,
            confirmButtonText: 'Resend',
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
                    url: 'components/authentication/controller/authentication-controller.php',
                    dataType: 'json',
                    data: {
                        user_account_id : user_account_id, 
                        transaction : transaction
                    },
                    beforeSend: function() {
                        disableFormSubmitButton('resend-verification');
                    },
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
                                showNotification(response.title, response.message, response.messageType);
                            }
                            else if (response.userVerified) {
                                showNotification(response.title, response.message, response.messageType);
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
                        enableFormSubmitButton('resend-verification');
                    }
                });
                return false;
            }
        });
    });
});