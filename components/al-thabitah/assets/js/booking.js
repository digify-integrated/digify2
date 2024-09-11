(function ($) {
    'use strict';
  
    $(function () {
        if($('#booking-form').length){
            bookingForm();
        }

        $(document).on('change','#booking_date',function() {
            updateTimeOptions()
        });

        const paymentRadios = document.querySelectorAll('input[name="mode_of_payment"]');
        const proceedText = document.getElementById('proceed-text');
    
        paymentRadios.forEach(radio => {
            radio.addEventListener('change', function () {
                if (this.value === 'Stripe') {
                    proceedText.textContent = 'Proceed to payment';
                } else {
                    proceedText.textContent = 'Place booking';
                }
            });
        });

        handleServiceChange();
    });
})(jQuery);

function bookingForm(){
    $('#booking-form').validate({
        rules: {
            service: {
                required: true
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
            }
        },
        messages: {
            service: {
                required: 'Choose the service'
            },
            booking_date: {
                required: 'Choose the booking date'
            },
            booking_time: {
                required: 'Choose the booking time'
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
            first_name: {
                required: 'Enter your first name'
            },
            last_name: {
                required: 'Enter your last name'
            },
            address: {
                required: 'Enter your address'
            },
            phone: {
                required: 'Enter your phone number'
            },
            email_address: {
                required: 'Enter your email address'
            },
            frequency: {
                required: 'Enter the frequency'
            },
            duration: {
                required: 'Enter the duration'
            },
            number_of_seats: {
                required: 'Enter the number of seats'
            },
            meters: {
                required: 'Enter the meters'
            }
        },
        submitHandler: function(form) {
            const transaction = 'add booking';
            const mode_of_payment = $('input[name="mode_of_payment"]:checked').val();
            const discount_code = $('#discount_code').val(); 
          
            $.ajax({
                type: 'POST',
                url: 'components/booking/controller/booking-form-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction + '&discount_code=' + discount_code + '&mode_of_payment=' + mode_of_payment,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-booking');
                },
                success: function (response) {
                    if (response.success) {
                        if(response.redirectLink != ''){
                            window.open(response.redirectLink, '_self');
                        }
                        else{
                            Swal.fire({
                                title: response.title,
                                text: response.message,
                                icon: 'success'
                            });
    
                            resetModalForm('booking-form');
    
                            $('#discount_code').val('');
                            $('#discount-rate').val('');
                            $('#discount-type').val('');
                            $('#discount-amount').val('');
    
                            $('#booking-subtotal-payment-details').text('AED 0.00');
                            $('#discount-subtotal').text('AED 0.00');
                            $('#total-booking-amount').text('AED 0.00');
    
                            document.getElementById('service-summary').innerHTML = '';
                            document.getElementById('cleaning-materials-summary').innerHTML = '';
                        }
                    }
                    else {
                        Swal.fire({
                            title: response.title,
                            text: response.message,
                            icon: 'error'
                        });
                    }
                },
                complete: function() {
                    enableFormSubmitButton('submit-booking');
                    handleServiceChange()
                }
            });
        
            return false;
        }
    });
}

function handleServiceChange() {
    const serviceSelect = document.getElementById('service');
    const cleaningMaterialsSelect = document.getElementById('cleaning_materials');
    const discountAmountInput = document.getElementById('discount-amount');
    const discountType = document.getElementById('discount-type');
    const discountRate = document.getElementById('discount-rate');
    const discountCodeInput = document.getElementById('discount_code');
    const applyDiscountBtn = document.getElementById('apply-discount');
    const resetDiscountBtn = document.getElementById('reset-discount');
    const fields = {
        frequency: document.getElementById('frequency_field'),
        duration: document.getElementById('duration_field'),
        seats: document.getElementById('number_of_seats_field'),
        meters: document.getElementById('meters_field'),
    };
    const inputs = {
        frequency: document.getElementById('frequency'),
        duration: document.getElementById('duration'),
        seats: document.getElementById('number_of_seats'),
        meters: document.getElementById('meters'),
    };

    const summaryRow = document.getElementById('service-summary');
    const cleaningMaterialsSummaryRow = document.getElementById('cleaning-materials-summary');
    const bookingSubtotalElement = document.getElementById('booking-subtotal-payment-details');
    const totalBookingAmountElement = document.getElementById('total-booking-amount');
    const discountSubtotalElement = document.getElementById('discount-subtotal');

    let currentGroup = '';
    let voucherValidated = false;

    // Event listeners for input changes and apply/reset discount
    Object.values(inputs).forEach(input => input.addEventListener('input', () => {
        updateSummary();
        updateBookingAmounts();
    }));
    
    cleaningMaterialsSelect.addEventListener('change', () => {
        updateCleaningMaterialsSummary();
        updateBookingAmounts();
    });

    applyDiscountBtn.addEventListener('click', () => {
        applyDiscount();
    });

    resetDiscountBtn.addEventListener('click', () => {
        resetDiscount();
    });

    discountAmountInput.addEventListener('input', () => {
        updateDiscount();
        updateBookingAmounts(); // Ensure amounts are updated after discount input
    });

    serviceSelect.addEventListener('change', () => {
        const selectedService = serviceSelect.value;
        const serviceGroups = {
            cleaning: ['Deep Cleaning', 'Regular Cleaning', 'Office Cleaning', 'Flat Cleaning', 'Hospital Cleaning'],
            sofa: ['Sofa Cleaning'],
            specialty: ['Mattress Cleaning', 'Curtain Cleaning', 'Carpet Cleaning'],
        };

        let newGroup = '';
        if (serviceGroups.cleaning.includes(selectedService)) newGroup = 'cleaning';
        else if (serviceGroups.sofa.includes(selectedService)) newGroup = 'sofa';
        else if (serviceGroups.specialty.includes(selectedService)) newGroup = 'specialty';

        if (newGroup !== currentGroup) {
            Object.values(fields).forEach(field => field.classList.add('d-none'));
            Object.values(inputs).forEach(input => input.value = '');
        }

        if (newGroup === 'cleaning') {
            fields.frequency.classList.remove('d-none');
            fields.duration.classList.remove('d-none');
        } else if (newGroup === 'sofa') {
            fields.seats.classList.remove('d-none');
        } else if (newGroup === 'specialty') {
            fields.meters.classList.remove('d-none');
        }

        currentGroup = newGroup;
        updateSummary();
        updateBookingAmounts();
    });

    function updateSummary() {
        const selectedService = serviceSelect.value;
        let details = '';
        let price = 0;

        if (selectedService === 'Sofa Cleaning') {
            const seats = inputs.seats.value || 0;
            details = `Number of seats: ${seats}`;
            price = seats * 20;
        } else if (['Deep Cleaning', 'Regular Cleaning', 'Office Cleaning', 'Flat Cleaning', 'Hospital Cleaning'].includes(selectedService)) {
            const frequency = inputs.frequency.value || '--';
            const duration = inputs.duration.value || 0;
            details = `Frequency: ${frequency}<br/>Duration: ${duration} hours`;
            price = duration * 25;
        } else if (selectedService === 'Mattress Cleaning') {
            const meters = inputs.meters.value || 0;
            details = `Meters: ${meters}`;
            price = meters * 15;
        }

        summaryRow.innerHTML = `
            <td class="product-thumbnail">
                <a href="javascript:void(0);" class="text-dark-gray fw-500 d-block lh-initial" id="service-name-summary">${selectedService}</a>
                <span class="fs-14 d-block" id="service-details">${details}</span>
            </td>
            <td class="product-price" data-title="Price">AED ${formatCurrency(price)}</td>
        `;
    }

    function updateCleaningMaterialsSummary() {
        const cleaningMaterials = cleaningMaterialsSelect.value;
        let price = 0;

        if (cleaningMaterials === 'Yes') {
            price = 10;
            cleaningMaterialsSummaryRow.innerHTML = `
                <td class="product-thumbnail">
                    <a href="javascript:void(0);" class="text-dark-gray fw-500 d-block lh-initial">Cleaning Materials</a>
                </td>
                <td class="product-price" data-title="Price">AED ${formatCurrency(price)}</td>
            `;
        } else {
            cleaningMaterialsSummaryRow.innerHTML = '';
        }
    }

    function updateBookingAmounts() {
        let servicePrice = 0;
        let materialsPrice = 0;

        if (summaryRow.innerHTML.includes('product-price')) {
            const servicePriceText = summaryRow.querySelector('.product-price').textContent;
            servicePrice = parseFloat(servicePriceText.replace(/[^0-9.-]+/g, '')) || 0;
        }

        if (cleaningMaterialsSummaryRow.innerHTML.includes('product-price')) {
            const materialsPriceText = cleaningMaterialsSummaryRow.querySelector('.product-price').textContent;
            materialsPrice = parseFloat(materialsPriceText.replace(/[^0-9.-]+/g, '')) || 0;
        }

        const bookingSubtotal = servicePrice + materialsPrice;
        bookingSubtotalElement.textContent = `AED ${formatCurrency(bookingSubtotal)}`;

        updateDiscount(); // Ensure the discount is correctly applied before calculating totals
    }

    function updateDiscount() {
        const discountType = document.getElementById('discount-type').value;
        const discountRate = document.getElementById('discount-rate').value;
        let discountAmount = 0;
        const bookingSubtotal = parseFloat(bookingSubtotalElement.textContent.replace(/[^0-9.-]+/g, '')) || 0;

        if (discountType === 'By Percentage') {
            discountAmount = (discountRate / 100) * bookingSubtotal;
        }
        else{
            discountAmount = discountRate;
        }
        
        const validDiscount = Math.min(discountAmount, bookingSubtotal);  // Cap discount to booking subtotal
        
        discountSubtotalElement.textContent = validDiscount > 0 ? `- AED ${formatCurrency(validDiscount)}` : 'AED 0.00';
        
        const totalBookingAmount = bookingSubtotal - validDiscount;  // Adjusted total after applying discount
        totalBookingAmountElement.textContent = `AED ${formatCurrency(totalBookingAmount)}`;
        
        discountAmountInput.value = validDiscount.toFixed(2); // Ensure the discount field reflects the valid amount
    }

    function applyDiscount() {
        const discountCode = discountCodeInput.value;
        const bookingSubtotal = parseFloat(bookingSubtotalElement.textContent.replace(/[^0-9.-]+/g, '')) || 0;

        if (!discountCode) {
            Swal.fire({
                title: 'Voucher Application Error',
                text: 'Please enter a discount code',
                icon: 'info'
            });
            return;
        }

        const transaction = 'validate voucher';

        fetch('components/voucher/controller/voucher-validation-controller.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `transaction=${transaction}&voucher_code=${discountCode}&booking_subtotal=${bookingSubtotal}`
        })
        .then(response => response.json())
        .then(response => {
            if (response.valid) {
                let discountAmount = parseFloat(response.discount_amount) || 0;
                const discountType = response.discount_type; // 'fixed' or 'percentage'
    
                if (discountType === 'By Percentage') {
                    discountAmount = discountAmount * bookingSubtotal;
                }
    
                // Ensure discount does not exceed booking subtotal
                if (discountAmount > bookingSubtotal) {
                    discountAmount = bookingSubtotal;
                }
    
                document.getElementById('discount-type').value = discountType;
                document.getElementById('discount-rate').value = response.discount_amount;
                discountAmountInput.value = discountAmount.toFixed(2);
                updateDiscount(); 
                updateBookingAmounts();

                Swal.fire({
                    title: response.title,
                    text: response.message,
                    icon: 'success'
                });
            } else {
                Swal.fire({
                    title: response.title,
                    text: response.message,
                    icon: 'error'
                });

                resetDiscount();
            }
        })
        .catch(error => console.error('Error:', error));
    }

    function resetDiscount() {
        discountCodeInput.value = '';
        discountType.value = '';
        discountRate.value = '0';
        discountAmountInput.value = '0';
        discountSubtotalElement.textContent = 'AED 0.00';
        voucherValidated = false;
        updateBookingAmounts();
    }

    function checkVoucherValidity() {
        const discountCode = discountCodeInput.value;
        if (!discountCode) return;

        applyDiscount();
    }

    function formatCurrency(amount) {
        return amount.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }
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