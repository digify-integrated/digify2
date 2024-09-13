(function($) {
    'use strict';

    $(function() {
        displayDetails('get booking details');

        if($('#booking-form').length){
            bookingForm();
        }

        if($('#tag-for-cancellation-form').length){
            tagForCancellationForm();
        }

        if($('#tag-for-cancellation-as-rejected-form').length){
            tagForCancellationAsRejectedForm();
        }

        if($('#tag-as-paid-form').length){
            tagAsPaidForm();
        }

        if($('#tag-for-refund-form').length){
            tagForRefundForm();
        }

        if($('#tag-for-refund-as-rejected-form').length){
            tagForRefundAsRejectedForm();
        }

        if($('#tag-as-refunded-form').length){
            tagAsRefundedForm();
        }

        if($('#personnel-assignment-form').length){
            personnelAssignmentForm();
        }

        if($('#booking-personnel-container').length){
            bookingPersonnelList();
        }

        $(document).on('change', '#service', function() {
            const selectedValue = $(this).val();
            const serviceGroups = {
              'Deep Cleaning': 1,
              'Regular Cleaning': 1,
              'Office Cleaning': 1,
              'Flat Cleaning': 1,
              'Hospital Cleaning': 1,
              'Sofa Cleaning': 2,
              'Mattress Cleaning': 3,
              'Curtain Cleaning': 3,
              'Carpet Cleaning': 3
            };
          
            const groupToShow = serviceGroups[selectedValue];
            const groupsToHide = [1, 2, 3].filter(group => group !== groupToShow);
          
            groupsToHide.forEach(group => $(`#sevices-group-${group}`).addClass('d-none'));
            $(`#sevices-group-${groupToShow}`).removeClass('d-none');
          
            const fieldsToReset = [
              '#frequency',
              '#duration',
              '#number_of_seats',
              '#meters'
            ];
          
            fieldsToReset.forEach(field => $(field).val(''));

            computeBookingAmount();
        });

        $(document).on('change', '#duration', function() {
            computeBookingAmount();
        });

        $(document).on('change', '#number_of_seats', function() {
            computeBookingAmount();
        });

        $(document).on('change', '#meters', function() {
            computeBookingAmount();
        });

        $(document).on('change', '#cleaning_materials', function() {
            computeBookingAmount();
        });

        $(document).on('change', '#discount_type', function() {
            computeBookingAmount();
        });

        $(document).on('change', '#discount_amount', function() {
            computeBookingAmount();
        });

        $(document).on('click','#edit-details',function() {
            displayDetails('get booking details');
        });

        $(document).on('click','#delete-booking',function() {
            const booking_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'delete booking';
    
            Swal.fire({
                title: 'Confirm Booking Deletion',
                text: 'Are you sure you want to delete this booking?',
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
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
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

        $(document).on('click','#tag-as-in-progress',function() {
            const booking_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'tag booking as in-progress';
    
            Swal.fire({
                title: 'Confirm Booking Tagging As In-Progress',
                text: 'Are you sure you want to tag this booking as in-progress?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'In-Progress',
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
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
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

        $(document).on('click','#tag-as-completed',function() {
            const booking_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'tag booking as completed';
    
            Swal.fire({
                title: 'Confirm Booking Tagging As Completed',
                text: 'Are you sure you want to tag this booking as completed?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Completed',
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
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
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

        $(document).on('click','#tag-as-cancelled',function() {
            const booking_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'tag booking as cancelled';
    
            Swal.fire({
                title: 'Confirm Booking Tagging As Cancelled',
                text: 'Are you sure you want to tag this booking as cancelled?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Cancelled',
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
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
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

        $(document).on('click','#tag-as-refunded',function() {
            const booking_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'tag booking payment as refunded';
    
            Swal.fire({
                title: 'Confirm Booking Payment Tagging As Refunded',
                text: 'Are you sure you want to tag this booking payment as refunded?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Refunded',
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
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
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

        $(document).on('click','#assign-personnel',function() {
            generateDropdownOptions('employee booking dual listbox options');
        });

        $(document).on('click','.unassign-personnel',function() {
            const booking_id = $('#details-id').text();
            const booking_personnel_id = $(this).data('booking-personnel-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'unassign booking personnel';
    
            Swal.fire({
                title: 'Confirm Booking Personnel Unassign',
                text: 'Are you sure you want to unassign this employee?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Unassign',
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
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
                            booking_personnel_id : booking_personnel_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                bookingPersonnelList();
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

        $(document).on('click','.start-job',function() {
            const booking_id = $('#details-id').text();
            const booking_personnel_id = $(this).data('booking-personnel-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'start job';
    
            Swal.fire({
                title: 'Confirm Job Start',
                text: 'Are you sure you want to start the job this employee?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'Start',
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
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
                            booking_personnel_id : booking_personnel_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                bookingPersonnelList();
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

        $(document).on('click','.end-job',function() {
            const booking_id = $('#details-id').text();
            const booking_personnel_id = $(this).data('booking-personnel-id');
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'end job';
    
            Swal.fire({
                title: 'Confirm Job End',
                text: 'Are you sure you want to end the job this employee?',
                icon: 'warning',
                showCancelButton: !0,
                confirmButtonText: 'End',
                cancelButtonText: 'Cancel',
                customClass: {
                    confirmButton: 'btn btn-warning mt-2',
                    cancelButton: 'btn btn-secondary ms-2 mt-2'
                },
                buttonsStyling: !1
            }).then(function(result) {
                if (result.value) {
                    $.ajax({
                        type: 'POST',
                        url: 'components/booking/controller/booking-controller.php',
                        dataType: 'json',
                        data: {
                            booking_id : booking_id, 
                            booking_personnel_id : booking_personnel_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                bookingPersonnelList();
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
            const booking_id = $('#details-id').text();

            logNotesMain('booking', booking_id);
        }

        if($('#internal-notes').length){
            const booking_id = $('#details-id').text();

            internalNotes('booking', booking_id);
        }

        if($('#internal-notes-form').length){
            const booking_id = $('#details-id').text();

            internalNotesForm('booking', booking_id);
        }

        // Initialize the QR scanner variable
        let html5QrCode;

        // Function to start the QR code scanner
        function startAndScanQRCode() {
            // Define the callback for successful QR code scan
            const qrCodeSuccessCallback = function(decodedText, decodedResult) {
                console.log('QR Code Data:', decodedText); // Debugging: Show scanned data in the console

                // Extract the EMPID from the vCard data
                const regex = /EMPID:([^\n]+)/; // Regular expression to find EMPID
                const match = decodedText.match(regex);

                if (match && match[1]) {
                    document.getElementById('empid-output').innerText = match[1]; // Display EMPID
                }

                stopQRCodeScanner(); // Stop scanning after extraction
            };

            const qrCodeErrorCallback = function(errorMessage) {
                // Debugging: Print any errors in the console
                console.error(`QR Code Scan Error: ${errorMessage}`);
            };

            // Initialize the QR scanner
            html5QrCode = new Html5Qrcode('qr-reader');

            // Start scanning with the rear camera
            html5QrCode.start(
                { facingMode: 'environment' }, // Camera facing mode for best performance
                {
                    fps: 15, // Higher fps for smoother scanning (15 fps is usually a good balance)
                    qrbox: function(viewfinderWidth, viewfinderHeight) {
                        // Dynamically calculate qrbox size for best performance
                        const minEdgeSize = Math.min(viewfinderWidth, viewfinderHeight);
                        return {
                            width: Math.floor(minEdgeSize * 0.8), // Use 80% of the smaller dimension
                            height: Math.floor(minEdgeSize * 0.8)
                        };
                    },
                    disableFlip: true, // Disable flip if not needed to improve performance
                },
                qrCodeSuccessCallback,
                qrCodeErrorCallback
            ).catch(err => {
                console.error('Unable to start scanning:', err);
            });
        }

        // Function to stop the QR code scanner
        function stopQRCodeScanner() {
            if (html5QrCode) {
                html5QrCode.stop().then(() => {
                    console.log('QR Code scanning stopped.');
                }).catch(err => {
                    console.error('Unable to stop scanning:', err);
                });
            }
        }

        // Event listener to start the scanner when the modal is shown
        document.getElementById('scan-qr-modal').addEventListener('shown.bs.modal', function () {
            startAndScanQRCode();
        });

        // Event listener to stop the scanner when the modal is hidden
        document.getElementById('scan-qr-modal').addEventListener('hidden.bs.modal', function () {
            stopQRCodeScanner();
        });
    });
})(jQuery);

function bookingForm(){
    $('#booking-form').validate({
        rules: {
            first_name: {
                required: true
            },
            last_name: {
                required: true
            },
            address: {
                required: true
            },
            phone: {
                required: true
            },
            email_address: {
                required: true
            },
            source_of_booking: {
                required: true
            },
            service: {
                required: true
            },
            frequency: {
                required: function() {
                    var service = document.getElementById('service').value;
                    return service === 'Deep Cleaning' || service === 'Regular Cleaning' || service === 'Office Cleaning' || service === 'Flat Cleaning' || service === 'Hospital Cleaning';
                }
            },
            duration: {
                required: function() {
                    var service = document.getElementById('service').value;
                    return service === 'Deep Cleaning' || service === 'Regular Cleaning' || service === 'Office Cleaning' || service === 'Flat Cleaning' || service === 'Hospital Cleaning';
                }
            },
            number_of_seats: {
                required: function() {
                    var service = document.getElementById('service').value;
                    return service === 'Sofa Cleaning';
                }
            },
            meters: {
                required: function() {
                    var service = document.getElementById('service').value;
                    return service === 'Mattress Cleaning' || service === 'Curtain Cleaning' || service === 'Carpet Cleaning';
                }
            },
            booking_date: {
                required: true
            },
            booking_time: {
                required: true
            },
            number_of_professionals: {
                required: true
            },
            number_of_hours: {
                required: true
            },
            nationality: {
                required: true
            },
            mode_of_payment: {
                required: true
            },
        },
        messages: {
            first_name: {
                required: 'Enter the first name'
            },
            last_name: {
                required: 'Enter the last'
            },
            address: {
                required: 'Enter the address'
            },
            phone: {
                required: 'Enter the phone'
            },
            email_address: {
                required: 'Enter the email address'
            },
            source_of_booking: {
                required: 'Choose the booking source'
            },
            service: {
                required: 'Choose the service'
            },
            frequency: {
                required: 'Choose the frequency'
            },
            duration: {
                required: 'Choose the duration'
            },
            number_of_seats: {
                required: 'Enter the number of seats'
            },
            meters: {
                required: 'Enter the meters'
            },
            booking_date: {
                required: 'Choose the date'
            },
            booking_time: {
                required: 'Choose the time'
            },
            number_of_professionals: {
                required: 'Choose the number of professionals'
            },
            number_of_hours: {
                required: 'Choose the number of hours'
            },
            nationality: {
                required: 'Choose the nationality'
            },
            mode_of_payment: {
                required: 'Choose the mode of payment'
            },
            discount_type: {
                required: 'Choose the discount type'
            },
            discount_amount: {
                required: 'Enter the discount amount'
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
            const booking_id = $('#details-id').text();
            const transaction = 'update booking';
            const page_link = document.getElementById('page-link').getAttribute('href');
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&booking_id=' + booking_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        displayDetails('get booking details');
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

function bookingPersonnelList(){
    const booking_id = $('#details-id').text();
    const page_id = $('#page-id').val();
    const type = 'booking personnel list';

    $.ajax({
        type: 'POST',
        url: 'components/booking/view/_booking_generation.php',
        dataType: 'json',
        data: { type: type, 'page_id' : page_id, 'booking_id': booking_id },
        beforeSend: function(){
            document.getElementById('booking-personnel-container').innerHTML = '<div class="text-center"><div class="spinner-grow text-dark" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        },
        success: function (result) {
            document.getElementById('booking-personnel-container').innerHTML = result[0].PERSONNEL_LIST;
        }
    });
}

function tagForCancellationForm(){
    $('#tag-for-cancellation-form').validate({
        rules: {
            cancellation_reason: {
                required: true
            }
        },
        messages: {
            cancellation_reason: {
                required: 'Enter the cancellation reason'
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
            const booking_id = $('#details-id').text();
            const transaction = 'tag booking for cancellation';
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&booking_id=' + booking_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-tag-for-cancellation-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
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
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function() {
                    enableFormSubmitButton('submit-tag-for-cancellation-data');
                }
            });
        
            return false;
        }
    });
}

function tagForCancellationAsRejectedForm(){
    $('#tag-for-cancellation-as-rejected-form').validate({
        rules: {
            booking_for_cancellation_rejection_reason: {
                required: true
            }
        },
        messages: {
            booking_for_cancellation_rejection_reason: {
                required: 'Enter the rejection reason'
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
            const booking_id = $('#details-id').text();
            const transaction = 'tag booking for cancellation as rejected';
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&booking_id=' + booking_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-tag-for-cancellation-as-rejected-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
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
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function() {
                    enableFormSubmitButton('submit-tag-for-cancellation-as-rejected-data');
                }
            });
        
            return false;
        }
    });
}

function tagAsPaidForm(){
    $('#tag-as-paid-form').validate({
        rules: {
            payment_amount: {
                required: true
            },
            payment_date: {
                required: true
            },
            payment_reference_number: {
                required: true
            }
        },
        messages: {
            payment_amount: {
                required: 'Choose the payment date'
            },
            payment_date: {
                required: 'Choose the payment date'
            },
            payment_reference_number: {
                required: 'Enter the payment reference number'
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
            const booking_id = $('#details-id').text();
            const transaction = 'tag booking payment as paid';
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&booking_id=' + booking_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-tag-as-paid-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
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
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function() {
                    enableFormSubmitButton('submit-tag-as-paid-data');
                }
            });
        
            return false;
        }
    });
}

function tagForRefundForm(){
    $('#tag-for-refund-form').validate({
        rules: {
            for_refund_reason: {
                required: true
            },
            refund_amount: {
                required: true
            }
        },
        messages: {
            for_refund_reason: {
                required: 'Enter the refund reason'
            },
            refund_amount: {
                required: 'Enter the refund amount'
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
            const booking_id = $('#details-id').text();
            const transaction = 'tag booking payment for refund';
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&booking_id=' + booking_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-tag-for-refund-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
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
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function() {
                    enableFormSubmitButton('submit-tag-for-refund-data');
                }
            });
        
            return false;
        }
    });
}

function tagForRefundAsRejectedForm(){
    $('#tag-for-refund-as-rejected-form').validate({
        rules: {
            for_refund_rejection_reason: {
                required: true
            }
        },
        messages: {
            for_refund_rejection_reason: {
                required: 'Enter the rejection reason'
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
            const booking_id = $('#details-id').text();
            const transaction = 'tag booking payment for refund as rejected';
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&booking_id=' + booking_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-tag-for-refund-as-rejected-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
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
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    showErrorDialog(fullErrorMessage);
                },
                complete: function() {
                    enableFormSubmitButton('submit-tag-for-refund-as-rejected-data');
                }
            });
        
            return false;
        }
    });
}

function personnelAssignmentForm(){
    $('#personnel-assignment-form').validate({
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
            const booking_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            const transaction = 'assign booking personnel';
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&booking_id=' + booking_id,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-personnel-assignment-data');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        bookingPersonnelList();
                        $('#personnel-assignment-modal').modal('hide');
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
                    enableFormSubmitButton('submit-personnel-assignment-data');
                }
            });
        
            return false;
        }
    });
}

function computeBookingAmount() {
    const service = $('#service').val();
    const duration = parseFloat($('#duration').val()) || 0;
    const numberOfSeats = parseFloat($('#number_of_seats').val()) || 0;
    const meters = parseFloat($('#meters').val()) || 0;
    const cleaningMaterials = $('#cleaning_materials').val();
    const discountType = $('#discount_type').val();
    const discountAmount = parseFloat($('#discount_amount').val()) || 0;

    const servicePrices = {
        'Deep Cleaning': 25,
        'Regular Cleaning': 25,
        'Office Cleaning': 25,
        'Flat Cleaning': 25,
        'Hospital Cleaning': 25,
        'Sofa Cleaning': 20,
        'Mattress Cleaning': 15,
        'Curtain Cleaning': 15,
        'Carpet Cleaning': 15
    };

    let bookingSubTotal = 0;

    if (service in servicePrices) {
        if (service === 'Sofa Cleaning') {
            bookingSubTotal = servicePrices[service] * numberOfSeats;
        } else if (['Mattress Cleaning', 'Curtain Cleaning', 'Carpet Cleaning'].includes(service)) {
            bookingSubTotal = servicePrices[service] * meters;
        } else {
            bookingSubTotal = servicePrices[service] * duration;
        }
    }

    // Add cleaning materials cost if selected
    if (cleaningMaterials === 'Yes') {
        bookingSubTotal += 10;
    }

    let totalDiscountAmount = 0;
    if (discountType === 'By Percentage') {
        totalDiscountAmount = (discountAmount / 100) * bookingSubTotal;
    } else if (discountType === 'Fix Amount') {
        totalDiscountAmount = discountAmount;
    }

    // Validate discount amount
    if (totalDiscountAmount > bookingSubTotal) {
        totalDiscountAmount = bookingSubTotal;
    }

    const totalBookingAmount = Math.max(0, bookingSubTotal - totalDiscountAmount);

    // Update the elements with the calculated values
    $('#booking_subtotal').val(bookingSubTotal.toFixed(2));
    $('#total_discount_amount').val(totalDiscountAmount.toFixed(2));
    $('#booking_total').val(totalBookingAmount.toFixed(2));

    $('#booking-subtotal-summary').text('AED ' + bookingSubTotal.toLocaleString('en-AE', { minimumFractionDigits: 2 }));
    $('#discount-subtotal-summary').text((totalDiscountAmount > 0 ? '- ' : '') + 'AED ' + totalDiscountAmount.toLocaleString('en-AE', { minimumFractionDigits: 2 }));
    $('#booking-total-summary').text('AED ' + totalBookingAmount.toLocaleString('en-AE', { minimumFractionDigits: 2 }));
}

function displayDetails(transaction){
    switch (transaction) {
        case 'get booking details':
            var booking_id = $('#details-id').text();
            const page_link = document.getElementById('page-link').getAttribute('href');
            
            $.ajax({
                url: 'components/booking/controller/booking-controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    booking_id : booking_id, 
                    transaction : transaction
                },
                beforeSend: function(){
                    resetModalForm('booking-form');
                },
                success: function(response) {
                    if (response.success) {
                        $('#first_name').val(response.firstName);
                        $('#last_name').val(response.lastName);
                        $('#address').val(response.address);
                        $('#phone').val(response.phone);
                        $('#email_address').val(response.emailAddress);
                        $('#source_of_booking').val(response.sourceOfBooking);
                        $('#service').val(response.service).trigger('change').trigger('input');
                        $('#frequency').val(response.frequency).trigger('change').trigger('input');
                        $('#duration').val(response.duration).trigger('change').trigger('input');
                        $('#number_of_seats').val(response.numberOfSeats).trigger('change').trigger('input');
                        $('#meters').val(response.meters).trigger('change').trigger('input');
                        $('#cleaning_materials').val(response.cleaningMaterials).trigger('change').trigger('input');
                        $('#booking_date').val(response.bookingDate);
                        $('#booking_time').val(response.bookingTime);
                        $('#number_of_professionals').val(response.numberOfProfessionals);
                        $('#number_of_hours').val(response.numberOfHours);
                        $('#nationality').val(response.nationality);
                        $('#special_instructions').val(response.specialInstructions);
                        $('#mode_of_payment').val(response.modeOfPayment);
                        $('#discount_type').val(response.discountType);
                        $('#discount_amount').val(response.discountAmount);

                        $('#booking-reference-number-summary').text(response.bookingReferenceNumber);

                        document.getElementById('payment-status-summary').innerHTML = response.paymentStatusBadge;
                        document.getElementById('booking-status-summary').innerHTML = response.bookingStatusBadge;

                        $('#transaction-date-summary').text(response.transactionDate);
                        $('#payment-reference-number-summary').text(response.paymentReferenceNumber);
                        $('#payment-date-summary').text(response.paymentDate);
                        $('#discount-code-summary').text(response.discountCode);
                        $('#in-progress-date-summary').text(response.inProgressDate);
                        $('#completed-date-summary').text(response.completedDate);
                        $('#refund-amount-summary').text(response.refundAmount);
                        $('#refund-date-summary').text(response.refundDate);
                        $('#cancellation-window-summary').text(response.cancellationWindow);
                        $('#cancellation-request-date-summary').text(response.cancellationRequestDate);
                        $('#cancellation-date-summary').text(response.cancellationDate);
                        $('#cancellation-reason-summary').text(response.cancellationReason);

                        $('#payment-amount-summary').text(response.paymentAmount);
                        $('#for-refund-date-summary').text(response.refundReason);
                        $('#for-refund-reason-summary').text(response.forRefundReason);
                        $('#for-refund-rejection-date-summary').text(response.forRefundRejectionDate);
                        $('#for-refund-rejection-reason-summary').text(response.forRefundRejectionReason);
                        $('#for-cancellation-rejection-date-summary').text(response.refundReason);
                        $('#for-cancellation-rejection-reason-summary').text(response.refundReason);
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
                    computeBookingAmount();
                }
            });
            break;
    }
}

function generateDropdownOptions(type){
    switch (type) {
        case 'employee booking dual listbox options':
            var booking_id = $('#details-id').text();

            $.ajax({
                url: 'components/employee/view/_employee_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type,
                    booking_id : booking_id
                },
                success: function(response) {
                    var select = document.getElementById('employee_id');

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
                    if($('#employee_id').length){
                        $('#employee_id').bootstrapDualListbox({
                            nonSelectedListLabel: 'Non-selected',
                            selectedListLabel: 'Selected',
                            preserveSelectionOnMove: 'moved',
                            moveOnSelect: false,
                            helperSelectNamePostfix: false
                        });

                        $('#employee_id').bootstrapDualListbox('refresh', true);

                        initializeDualListBoxIcon();
                    }
                }
            });
            break;
    }
}