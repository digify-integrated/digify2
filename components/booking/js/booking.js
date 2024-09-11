(function($) {
    'use strict';

    $(function() {
        if($('#booking-table').length){
            bookingTable('#booking-table');
        }

        $(document).on('click','.delete-booking',function() {
            const booking_id = $(this).data('booking-id');
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
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#booking-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#booking-table');
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

        $(document).on('click','#delete-booking',function() {
            let booking_id = [];
            const transaction = 'delete multiple booking';

            $('.datatable-checkbox-children').each((index, element) => {
                if ($(element).is(':checked')) {
                    booking_id.push(element.value);
                }
            });
    
            if(booking_id.length > 0){
                Swal.fire({
                    title: 'Confirm Multiple Customer Inquiries Deletion',
                    text: 'Are you sure you want to delete these customer inquiries?',
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
                                booking_id: booking_id,
                                transaction : transaction
                            },
                            success: function (response) {
                                if (response.success) {
                                    showNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#booking-table');
                                }
                                else {
                                    if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
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
                            complete: function(){
                                toggleHideActionDropdown();
                            }
                        });
                        
                        return false;
                    }
                });
            }
            else{
                showNotification('Deletion Multiple Customer Inquiries Error', 'Please select the customer inquiries you wish to delete.', 'danger');
            }
        });

        $(document).on('click','#apply-filter',function() {
            bookingTable('#booking-table');
            $('#filter-offcanvas').offcanvas('hide');
        });

        $('#datatable-search').on('keyup', function () {
            var table = $('#booking-table').DataTable();
            table.search(this.value).draw();
        });
    });
})(jQuery);

function bookingTable(datatable_name, buttons = false, show_all = false){
    toggleHideActionDropdown();

    const type = 'booking table';
    const page_id = $('#page-id').val();
    const filter_by_service = $('#filter_by_service').val();
    const filter_by_booking_status = $('#filter_by_booking_status').val();
    const filter_by_payment_status = $('#filter_by_payment_status').val();
    const filter_by_mode_of_payment = $('#filter_by_mode_of_payment').val();
    const filter_by_source_of_booking = $('#filter_by_source_of_booking').val();
    const booking_start_date = $('#booking_start_date').val();
    const booking_end_date = $('#booking_end_date').val();
    const transaction_start_date = $('#transaction_start_date').val();
    const transaction_end_date = $('#transaction_end_date').val();
    const payment_start_date = $('#payment_start_date').val();
    const payment_end_date = $('#payment_end_date').val();
    const page_link = document.getElementById('page-link').getAttribute('href');

    var settings;

    const column = [ 
        { 'data' : 'CHECK_BOX' },
        { 'data' : 'BOOKING_REFERENCE_NUMBER' },
        { 'data' : 'CLIENT' },
        { 'data' : 'SERVICE' },
        { 'data' : 'BOOKING_SCHEDULE' },
        { 'data' : 'PAYMENT_STATUS' },
        { 'data' : 'BOOKING_STATUS' },
        { 'data' : 'SOURCE_OF_BOOKING' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': '1%','bSortable': false, 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 },
        { 'width': 'auto', 'aTargets': 2 },
        { 'width': 'auto', 'aTargets': 3 },
        { 'width': 'auto', 'aTargets': 4 },
        { 'width': 'auto', 'aTargets': 5 },
        { 'width': 'auto', 'aTargets': 6 },
        { 'width': 'auto', 'aTargets': 7 },
        { 'width': '10%','bSortable': false, 'aTargets': 8 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/booking/view/_booking_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {
                'type' : type,
                'page_id' : page_id,
                'filter_by_service' : filter_by_service,
                'filter_by_booking_status' : filter_by_booking_status,
                'filter_by_payment_status' : filter_by_payment_status,
                'filter_by_mode_of_payment' : filter_by_mode_of_payment,
                'filter_by_source_of_booking' : filter_by_source_of_booking,
                'booking_start_date' : booking_start_date,
                'booking_end_date' : booking_end_date,
                'transaction_start_date' : transaction_start_date,
                'transaction_end_date' : transaction_end_date,
                'payment_start_date' : payment_start_date,
                'payment_end_date' : payment_end_date,
                'page_link' : page_link
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