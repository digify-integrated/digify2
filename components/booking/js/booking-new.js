(function($) {
    'use strict';

    $(function() {
        if($('#booking-form').length){
            bookingForm();
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

        $(document).on('change', '#service', function() {
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

        $(document).on('change','#booking_date',function() {
            updateTimeOptions()
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
            const transaction = 'add booking';
            const page_link = document.getElementById('page-link').getAttribute('href');
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-data');
                },
                success: function (response) {
                    if (response.success) {
                        setNotification(response.title, response.message, response.messageType);
                        window.location = page_link + '&id=' + response.bookingID;
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

function updateTimeOptions() {
    const bookingDateInput = document.getElementById('booking_date');
    const bookingTimeSelect = document.getElementById('booking_time');
    const allTimes = [
        '9:00 AM', '10:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM'
    ];
    const currentDate = new Date();
    const threeHoursFromNow = new Date();
    threeHoursFromNow.setHours(currentDate.getHours() + 3);

    // Clear existing options
    bookingTimeSelect.innerHTML = '<option value="">--</option>';

    const selectedDate = new Date(bookingDateInput.value);
    if (selectedDate.toDateString() === currentDate.toDateString()) {
        // Show time slots greater than 3 hours from now
        allTimes.forEach(time => {
            const [hour, period] = time.split(' ');
            const [hours, minutes] = hour.split(':').map(Number);
            const timeDate = new Date();
            timeDate.setHours(hours + (period === 'PM' && hours < 12 ? 12 : 0), minutes);

            if (timeDate >= threeHoursFromNow) {
                const option = document.createElement('option');
                option.value = time;
                option.textContent = time;
                bookingTimeSelect.appendChild(option);
            }
        });
    } else {
        // Show all time slots
        allTimes.forEach(time => {
            const option = document.createElement('option');
            option.value = time;
            option.textContent = time;
            bookingTimeSelect.appendChild(option);
        });
    }
}