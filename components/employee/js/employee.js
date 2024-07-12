(function($) {
    'use strict';

    $(function() {
        

        generateDropdownOptions('company options');
        generateDropdownOptions('department options');
        generateDropdownOptions('job position options');
        generateDropdownOptions('employee status options');
        generateDropdownOptions('employment type options');
        generateDropdownOptions('gender options');
        generateDropdownOptions('civil status options');

        let offset = 0;
        const limit = 9;
        let isFetching = false

        function employeeCards(clearExisting) {
            if (isFetching) return;
            isFetching = true;
        
            const type = 'employee cards';
            const page_id = $('#page-id').val();
            const page_link = document.getElementById('page-link').getAttribute('href');            
        
            var search_value = $('#datatable-search').val();
            var filter_by_company = $('#company_filter').val();
            var filter_by_department = $('#department_filter').val();
            var filter_by_job_position = $('#job_position_filter').val();
            var filter_by_employee_status = $('#employee_status_filter').val();
            var filter_by_employment_type = $('#employment_type_filter').val();
            var filter_by_gender = $('#gender_filter').val();
            var filter_by_civil_status = $('#civil_status_filter').val();
        
            $.ajax({
                type: 'POST',
                url: 'components/employee/view/_employee_generation.php',
                dataType: 'json',
                data: {
                    page_id: page_id,
                    page_link: page_link,
                    limit: limit,
                    offset: offset,
                    search_value: search_value,
                    filter_by_company: filter_by_company,
                    filter_by_department: filter_by_department,
                    filter_by_job_position: filter_by_job_position,
                    filter_by_employee_status: filter_by_employee_status,
                    filter_by_employment_type: filter_by_employment_type,
                    filter_by_gender: filter_by_gender,
                    filter_by_civil_status: filter_by_civil_status,
                    type: type
                },
                beforeSend: function() {
                    if (clearExisting) {
                        $('#employee-card').empty();
                        offset = 0;
                    }
                },
                success: function(response) {
                    response.forEach(card => {
                        $('#employee-card').append(card.EMPLOYEE_CARD);
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
                employeeCards(false);
            }
        });
        
        $('#datatable-search').on('keyup', function() {
            employeeCards(true);
        });
        
        $(document).on('click','#apply-filter',function() {
            employeeCards(true);
            $('#filter-offcanvas').offcanvas('hide');
        });
       
        employeeCards(true);
       
    });
})(jQuery);

function generateDropdownOptions(type){
    switch (type) {
        case 'company options':
            
            $.ajax({
                url: 'components/company/view/_company_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#company_filter').select2({
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
        case 'department options':
            
            $.ajax({
                url: 'components/department/view/_department_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#department_filter').select2({
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
        case 'job position options':
            
            $.ajax({
                url: 'components/job-position/view/_job_position_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#job_position_filter').select2({
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
        case 'employee status options':
            
            $.ajax({
                url: 'components/employee/view/_employee_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#employee_status_filter').select2({
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
        case 'employment type options':
            
            $.ajax({
                url: 'components/employment-type/view/_employment_type_generation.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    type : type
                },
                success: function(response) {
                    $('#employment_type_filter').select2({
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