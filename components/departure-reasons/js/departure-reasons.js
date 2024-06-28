(function($) {
    'use strict';

    $(function() {
        if($('#departure-reasons-table').length){
            departureReasonsTable('#departure-reasons-table');
        }

        $(document).on('click','.delete-departure-reasons',function() {
            const departure_reasons_id = $(this).data('departure-reasons-id');
            const transaction = 'delete departure reasons';
    
            Swal.fire({
                title: 'Confirm Departure Reason Deletion',
                text: 'Are you sure you want to delete this departure reason?',
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
                        url: 'components/departure-reasons/controller/departure-reasons-controller.php',
                        dataType: 'json',
                        data: {
                            departure_reasons_id : departure_reasons_id, 
                            transaction : transaction
                        },
                        success: function (response) {
                            if (response.success) {
                                showNotification(response.title, response.message, response.messageType);
                                reloadDatatable('#departure-reasons-table');
                            }
                            else {
                                if (response.isInactive || response.userNotExist || response.userInactive || response.userLocked || response.sessionExpired) {
                                    setNotification(response.title, response.message, response.messageType);
                                    window.location = 'logout.php?logout';
                                }
                                else if (response.notExist) {
                                    setNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#departure-reasons-table');
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

        $(document).on('click','#delete-departure-reasons',function() {
            let departure_reasons_id = [];
            const transaction = 'delete multiple departure reasons';

            $('.datatable-checkbox-children').each((index, element) => {
                if ($(element).is(':checked')) {
                    departure_reasons_id.push(element.value);
                }
            });
    
            if(departure_reasons_id.length > 0){
                Swal.fire({
                    title: 'Confirm Multiple Departure Reasons Deletion',
                    text: 'Are you sure you want to delete these departure reasons?',
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
                            url: 'components/departure-reasons/controller/departure-reasons-controller.php',
                            dataType: 'json',
                            data: {
                                departure_reasons_id: departure_reasons_id,
                                transaction : transaction
                            },
                            success: function (response) {
                                if (response.success) {
                                    showNotification(response.title, response.message, response.messageType);
                                    reloadDatatable('#departure-reasons-table');
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
                showNotification('Deletion Multiple Departure Reason Error', 'Please select the departure reasons you wish to delete.', 'danger');
            }
        });

        $('#datatable-search').on('keyup', function () {
            var table = $('#departure-reasons-table').DataTable();
            table.search(this.value).draw();
        });
    });
})(jQuery);

function departureReasonsTable(datatable_name, buttons = false, show_all = false){
    toggleHideActionDropdown();

    const type = 'departure reasons table';
    const page_id = $('#page-id').val();
    const page_link = document.getElementById('page-link').getAttribute('href'); 
    var settings;

    const column = [ 
        { 'data' : 'CHECK_BOX' },
        { 'data' : 'DEPARTURE_REASON_NAME' },
        { 'data' : 'ACTION' }
    ];

    const column_definition = [
        { 'width': '1%', 'bSortable': false, 'aTargets': 0 },
        { 'width': 'auto', 'aTargets': 1 },
        { 'width': '15%', 'bSortable': false, 'aTargets': 2 }
    ];

    const length_menu = show_all ? [[-1], ['All']] : [[10, 25, 50, 100, -1], [10, 25, 50, 100, 'All']];

    settings = {
        'ajax': { 
            'url' : 'components/departure-reasons/view/_departure_reasons_generation.php',
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
            'sLengthMenu': '_MENU_',
            'searchPlaceholder': 'Search',
            'search': '',
            'info': '_START_ - _END_ of _TOTAL_ items',
            'loadingRecords': 'Just a moment while we fetch your data...'
        }
    };

    if (buttons) {
        settings.dom = 'Bfrtip';
        settings.buttons = ['copy', 'csv', 'excel', 'pdf', 'print'];
    }

    destroyDatatable(datatable_name);

    $(datatable_name).dataTable(settings);
}
