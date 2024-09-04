(function($) {
    'use strict';

    $(function() {
        if($('#voucher-table').length){
            voucherTable('#voucher-table');
        }

        $(document).on('click','.delete-voucher',function() {
            const voucher_id = $(this).data('voucher-id');
            const transaction = 'delete voucher';
    
            Swal.fire({
                title: 'Confirm Voucher Deletion',
                text: 'Are you sure you want to delete this voucher?',
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
                        url: 'components/voucher/controller/voucher-controller.php',
                        dataType: 'json',
                        data: {
                            voucher_id : voucher_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#voucher-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#voucher-table');
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

        $(document).on('click','#delete-voucher',function() {
            let voucher_id = [];
            const transaction = 'delete multiple voucher';

            $('.datatable-checkbox-children').each((index, element) => {
                if ($(element).is(':checked')) {
                    voucher_id.push(element.value);
                }
            });
    
            if(voucher_id.length > 0){
                Swal.fire({
                    title: 'Confirm Multiple Vouchers Deletion',
                    text: 'Are you sure you want to delete these vouchers?',
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
                            url: 'components/voucher/controller/voucher-controller.php',
                            dataType: 'json',
                            data: {
                                voucher_id: voucher_id,
                                transaction : transaction
                            },
                            success: function (response) {
                                if (response.success) {
                                    showNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#voucher-table');
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
                showNotification('Deletion Multiple Vouchers Error', 'Please select the vouchers you wish to delete.', 'danger');
            }
        });

        $('#datatable-search').on('keyup', function () {
            var table = $('#voucher-table').DataTable();
            table.search(this.value).draw();
        });
    });
})(jQuery);

function voucherTable(datatable_name, buttons = false, show_all = false){
    toggleHideActionDropdown();

    const type = 'voucher table';
    const page_id = $('#page-id').val();
    const page_link = document.getElementById('page-link').getAttribute('href');

    var settings;

    const column = [ 
        { 'data' : 'CHECK_BOX' },
        { 'data' : 'VOUCHER_NAME' },
        { 'data' : 'VOUCHER_CODE' },
        { 'data' : 'VOUCHER_USAGE_DATE' },
        { 'data' : 'DISCOUNT_TYPE' },
        { 'data' : 'DISCOUNT_AMOUNT' },
        { 'data' : 'MINIMUM_BOOKING_AMOUNT' },
        { 'data' : 'AVAILABLE_VOUCHER' },
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
        { 'width': '15%','bSortable': false, 'aTargets': 8 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/voucher/view/_voucher_generation.php',
            'method' : 'POST',
            'dataType': 'json',
            'data': {
                'type' : type,
                'page_id' : page_id,
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