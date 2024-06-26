(function($) {
    'use strict';

    $(function() {
        checkNotification();
        maxLength();
        initializeFilterDaterange();

        $(document).on('click','#internal-notes-button',function() {
            resetModalForm('internal-notes-form');
        });

        $(document).on('click','#copy-error-message',function() {
            copyToClipboard('error-dialog');
        });

        $(document).on('click','.password-addon',function() {
            if (0 < $(this).siblings('input').length) {
                var inputField = $(this).siblings('input');
                var eyeIcon = $(this).find('i');
        
                if (inputField.attr('type') === 'password') {
                    inputField.attr('type', 'text');
                    eyeIcon.removeClass('ti-eye').addClass('ti-eye-off');
                }
                else {
                    inputField.attr('type', 'password');
                    eyeIcon.removeClass('ti-eye-off').addClass('ti-eye');
                }
            }
        });

        $(document).on('click','#datatable-checkbox',function() {
            var status = $(this).is(':checked') ? true : false;
            $('.datatable-checkbox-children').prop('checked',status);
    
            toggleActionDropdown();
        });

        $(document).on('click','.datatable-checkbox-children',function() {
            toggleActionDropdown();
        });

        $(document).on('click','.light-layout',function() {
            saveUICustomization('theme', 'light');
        });

        $(document).on('click','.dark-layout',function() {
            saveUICustomization('theme', 'dark');
        });

        $(document).on('click','.color-theme',function() {
            const color_theme = $(this).data('theme-color');

            saveUICustomization('color theme', color_theme);
        });

        $(document).on('click','#boxed-layout',function() {
            saveUICustomization('boxed layout', 1);
        });

        $(document).on('click','#full-layout',function() {
            saveUICustomization('boxed layout', 0);
        });

        $(document).on('click','#full-sidebar',function() {
            saveUICustomization('sidebar type', 'full');
        });

        $(document).on('click','#mini-sidebar',function() {
            saveUICustomization('sidebar type', 'mini-sidebar');
        });

        $(document).on('click','#card-with-border',function() {
            saveUICustomization('card border', 1);
        });

        $(document).on('click','#card-without-border',function() {
            saveUICustomization('card border', 0);
        });
    });
})(jQuery);

function discardCreate(windows_location){
    Swal.fire({
        title: 'Discard Changes Confirmation',
        text: 'You are about to discard your changes. Proceeding will permanently erase any unsaved modifications. Are you sure you want to continue?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Discard',
        cancelButtonText: 'Cancel',
        customClass: {
            confirmButton: 'btn btn-danger mt-2',
            cancelButton: 'btn btn-secondary ms-2 mt-2'
        },
        buttonsStyling: false
    }).then(function(result) {
        if (result.value) {
            window.location = windows_location;
        }
    });
}

function maxLength(){
    if ($('[maxlength]').length) {
        $('[maxlength]').maxlength({
            alwaysShow: true,
            warningClass: 'badge rounded-pill bg-info fs-1 mt-0',
            limitReachedClass: 'badge rounded-pill bg-danger fs-1 mt-0',
        });
    }
}

function checkOptionExist(element, option){
    $(element).val(option).trigger('change');
}

function reloadDatatable(datatable){
    toggleHideActionDropdown();
    $(datatable).DataTable().ajax.reload();
}

function destroyDatatable(datatable_name){
    $(datatable_name).DataTable().clear().destroy();
}

function clearDatatable(datatable_name){
    $(datatable_name).dataTable().fnClearTable();
}

function readjustDatatableColumn() {
    const adjustDataTable = () => {
        const tables = $.fn.dataTable.tables({ visible: true, api: true });
        tables.columns.adjust();
        tables.fixedColumns().relayout();
    };
  
    $('a[data-bs-toggle="tab"], a[data-bs-toggle="pill"], #System-Modal').on('shown.bs.tab shown.bs.modal', adjustDataTable);
}

function toggleActionDropdown(){
    const inputElements = Array.from(document.querySelectorAll('.datatable-checkbox-children'));
    const multipleAction = $('.action-dropdown');
    const checkedValue = inputElements.filter(chk => chk.checked).length;

    multipleAction.toggleClass('d-none', checkedValue === 0);
}

function toggleHideActionDropdown(){
    $('.action-dropdown').addClass('d-none');
    $('#datatable-checkbox').prop('checked', false);
}

function handleColorTheme(e) {
    $('html').attr('data-color-theme', e);
    $(e).prop('checked', !0);
}

function copyToClipboard(elementID) {
    const element = document.getElementById(elementID);
    const text = element.innerHTML;

    navigator.clipboard.writeText(text)
        .then(() => showNotification('Copy Successful', 'Text copied to clipboard', 'success'))
        .catch((err) => showNotification('Copy Error', err, 'danger'));
}

function showErrorDialog(error){
    const errorDialogElement = document.getElementById('error-dialog');

    if (errorDialogElement) {
        errorDialogElement.innerHTML = error;
        $('#system-error-modal').modal('show');
    }
    else {
        console.error('Error dialog element not found.');
    }    
}

function updateFormSubmitButton(buttonId, disabled) {
    try {
        const submitButton = document.querySelector(`#${buttonId}`);
    
        if (submitButton) {
            submitButton.disabled = disabled;
        }
        else {
            console.error(`Button with ID '${buttonId}' not found.`);
        }
    }
    catch (error) {
        console.error(error);
    }
}

function disableFormSubmitButton(buttonId) {
    updateFormSubmitButton(buttonId, true);
}

function enableFormSubmitButton(buttonId) {
    updateFormSubmitButton(buttonId, false);
}

function handleSystemError(xhr, status, error) {
    let fullErrorMessage = `XHR status: ${status}, Error: ${error}${xhr.responseText ? `, Response: ${xhr.responseText}` : ''}`;
    showErrorDialog(fullErrorMessage);
}

function resetModalForm(form_id) {
    var form = document.getElementById(form_id);
  
    form.querySelectorAll('.is-invalid').forEach(function(element) {
        element.classList.remove('is-invalid');
    });

    form.reset();
}

function showNotification(notificationTitle, notificationMessage, notificationType, timeOut = 5000) {
    const validNotificationTypes = ['success', 'info', 'warning', 'error'];
    const isDuplicate = isDuplicateNotification(notificationMessage);

    if (!validNotificationTypes.includes(notificationType)) {
        console.error('Invalid notification type:', notificationType);
        return;
    }

    const toastrOptions = {
        closeButton: true,
        progressBar: true,
        newestOnTop: false,
        preventDuplicates: true,
        preventOpenDuplicates: true,
        positionClass: 'toast-top-full-width',
        timeOut: timeOut,
        showMethod: 'fadeIn',
        hideMethod: 'fadeOut'
    };

    if (!isDuplicate) {
        toastr.options = toastrOptions;
        toastr[notificationType](notificationMessage, notificationTitle);
    }
}

function isDuplicateNotification(message) {
    let isDuplicate = false;
    
    $('.toast').each(function() {
        if ($(this).find('.toast-message').text() === message[0].innerText) {
            isDuplicate = true;
            return false;
        }
    });

    return isDuplicate;
}
  
function setNotification(notificationTitle, notificationMessage, notificationType){
    sessionStorage.setItem('notificationTitle', notificationTitle);
    sessionStorage.setItem('notificationMessage', notificationMessage);
    sessionStorage.setItem('notificationType', notificationType);
}
  
function checkNotification() {
    const { 
        'notificationTitle': notificationTitle, 
        'notificationMessage': notificationMessage, 
        'notificationType': notificationType 
    } = sessionStorage;
    
    if (notificationTitle && notificationMessage && notificationType) {
        sessionStorage.removeItem('notificationTitle');
        sessionStorage.removeItem('notificationMessage');
        sessionStorage.removeItem('notificationType');

        showNotification(notificationTitle, notificationMessage, notificationType);
    }
}

function logNotes(databaseTable, referenceID){
    const type = 'log notes';

    $.ajax({
        type: 'POST',
        url: 'components/global/view/_log_notes_generation.php',
        dataType: 'json',
        data: { type: type, 'database_table': databaseTable, 'reference_id': referenceID },
        success: function (result) {
            document.getElementById('log-notes').innerHTML = result[0].LOG_NOTE;
        }
    });
}

function logNotesMain(databaseTable, referenceID){
    const type = 'log notes main';

    $.ajax({
        type: 'POST',
        url: 'components/global/view/_log_notes_generation.php',
        dataType: 'json',
        data: { type: type, 'database_table': databaseTable, 'reference_id': referenceID },
        success: function (result) {
            document.getElementById('log-notes-main').innerHTML = result[0].LOG_NOTE;
        }
    });
}

function internalNotes(databaseTable, referenceID){
    const type = 'internal notes';

    $.ajax({
        type: 'POST',
        url: 'components/global/view/_internal_notes_generation.php',
        dataType: 'json',
        data: { type: type, 'database_table': databaseTable, 'reference_id': referenceID },
        success: function (result) {
            document.getElementById('internal-notes').innerHTML = result[0].INTERNAL_NOTES;
        }
    });
}

function initializeDualListBoxIcon(){
    $('.moveall i').removeClass().addClass('ti ti-chevron-right');
    $('.removeall i').removeClass().addClass('ti ti-chevron-left');
    $('.move i').removeClass().addClass('ti ti-chevron-right');
    $('.remove i').removeClass().addClass('ti ti-chevron-left');
}

function initializeFilterDaterange(){
    if ($('.filter-daterange').length) {
        $('.filter-daterange').each(function() {
            $(this).daterangepicker({
                ranges: {
                    Today: [moment(), moment()],
                    Yesterday: [
                        moment().subtract(1, 'days'),
                        moment().subtract(1, 'days'),
                    ],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [
                        moment().subtract(1, 'month').startOf('month'),
                        moment().subtract(1, 'month').endOf('month'),
                    ],
                },
                drops: 'up',
                alwaysShowCalendars: true,
                autoUpdateInput: false
            }).on('apply.daterangepicker', function (e, picker) {
                picker.element.val(picker.startDate.format(picker.locale.format) + ' - ' + picker.endDate.format(picker.locale.format));
            }).on('cancel.daterangepicker', function (e, picker) {
                $(this).val('');
                picker.setStartDate({});
                picker.setEndDate({});
            });
        });
        
    }
}

function internalNotesForm(databaseTable, referenceID){
    $('#internal-notes-form').validate({
        rules: {
            internal_note: {
                required: true
            }
        },
        messages: {
            internal_note: {
                required: 'Please enter the internal note'
            }
        },
        errorPlacement: function (error, element) {
            showNotification('Attention Required: Error Found', error, 'error', 1500);
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
            const transaction = 'add internal notes';
            var formData = new FormData(form);
            formData.append('transaction', transaction);
            formData.append('database_table', databaseTable);
            formData.append('reference_id', referenceID);
          
            $.ajax({
                type: 'POST',
                url: 'components/global/controller/internal-notes-controller.php',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-internal-notes');
                },
                success: function (response) {
                    if (response.success) {
                        showNotification(response.title, response.message, response.messageType);
                        internalNotes(databaseTable, referenceID);
                        $('#internal-notes-modal').modal('hide');
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
                    enableFormSubmitButton('submit-internal-notes');
                    resetModalForm('internal-notes-form');
                }
            });
        
            return false;
        }
    });
}

function saveUICustomization(type, customizationValue){
    const transaction = 'update ui customization setting';

    $.ajax({
        type: 'POST',
        url: 'components/global/controller/ui-customization-controller.php',
        dataType: 'json',
        data: {
            type : type, 
            customizationValue : customizationValue, 
            transaction : transaction
        },
        success: function (response) {
            if (!response.success) {
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
        }
    });
}