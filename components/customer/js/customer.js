(function($) {
    'use strict';

    $(function() {
        generateDropdownOptions('customer status options');
        generateDropdownOptions('gender options');
        generateDropdownOptions('civil status options');

        let offset = 0;
        const limit = 9;
        let isFetching = false

        function customerCards(clearExisting) {
            if (isFetching) return;
            isFetching = true;
        
            const type = 'customer cards';
            const page_id = $('#page-id').val();
            const page_link = document.getElementById('page-link').getAttribute('href');            
        
            var search_value = $('#datatable-search').val();
            var filter_by_customer_status = $('#customer_status_filter').val();
            var filter_by_gender = $('#gender_filter').val();
            var filter_by_civil_status = $('#civil_status_filter').val();
        
            $.ajax({
                type: 'POST',
                url: 'components/customer/view/_customer_generation.php',
                dataType: 'json',
                data: {
                    page_id: page_id,
                    page_link: page_link,
                    limit: limit,
                    offset: offset,
                    search_value: search_value,
                    filter_by_customer_status: filter_by_customer_status,
                    filter_by_gender: filter_by_gender,
                    filter_by_civil_status: filter_by_civil_status,
                    type: type
                },
                beforeSend: function() {
                    if (clearExisting) {
                        $('#customer-card').empty();
                        offset = 0;
                    }
                },
                success: function(response) {
                    response.forEach(card => {
                        $('#customer-card').append(card.EMPLOYEE_CARD);
                    });
        
                    offset += limit;
                    isFetching = false;
                },
                error: function(xhr, status, error) {
                    var fullErrorMessage = `XHR status: ${status}, Error: ${error}`;
                    if (xhr.responseText) {
                        fullErrorMessage += `, Response: ${xhr.responseText}`;
                    }
                    console.error(fullErrorMessage);
                    isFetching = false;
                }
            });
        }
        
        $(window).scroll(function() {
            if ($(window).scrollTop() + $(window).height() == $(document).height()) {
                customerCards(false);
            }
        });
        
        $('#datatable-search').on('keyup', function() {
            offset = 0;
            customerCards(true);
        });
        
        $(document).on('click','#apply-filter',function() {
            offset = 0;
            customerCards(true);            
            $('#filter-offcanvas').offcanvas('hide');
        });
       
        customerCards(true);
       
    });
})(jQuery);

function generateDropdownOptions(type){
    switch (type) {
        case 'customer status options':
            
            $.ajax({
                url: 'components/customer/view/_customer_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#customer_status_filter').select2({
                        dropdownParent: $('#filter-offcanvas'),
                        data: response
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
        case 'gender options':
            
            $.ajax({
                url: 'components/gender/view/_gender_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#gender_filter').select2({
                        dropdownParent: $('#filter-offcanvas'),
                        data: response
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
        case 'civil status options':
            
            $.ajax({
                url: 'components/civil-status/view/_civil_status_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#civil_status_filter').select2({
                        dropdownParent: $('#filter-offcanvas'),
                        data: response
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