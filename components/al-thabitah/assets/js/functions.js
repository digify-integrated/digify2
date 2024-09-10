(function ($) {
    'use strict';
  
    $(function () {
        if($('#contact-us-form').length){
            contactUsForm();
        }

        /*if($('#booking-form').length){
            handleServiceChange();
        }*/

        // Google Translate API endpoint
        const API_URL = 'https://translation.googleapis.com/language/translate/v2?key=AIzaSyDtaHoYl8ZWzeO2_sinZAxV9INtNogyWhg'; // Replace with your actual API key
        const MAX_BATCH_SIZE = 128; // Maximum number of text segments per request
    
        // Save selected language in session storage with expiration
        function saveSelectedLanguage(language, title) {
            const expiryTime = Date.now() + 24 * 60 * 60 * 1000; // 24 hours in milliseconds
            sessionStorage.setItem('selectedLanguage', JSON.stringify({ language, expiry: expiryTime }));
            sessionStorage.setItem('selectedTitle', JSON.stringify({ title, expiry: expiryTime }));
        }
    
        // Retrieve and validate the selected language from session storage
        function getSessionItem(key) {
            const item = JSON.parse(sessionStorage.getItem(key));
            if (item && Date.now() < item.expiry) return item;
            sessionStorage.removeItem(key); // Remove expired item
            return null;
        }
    
        // Retrieve or clear translation memory from local storage
        function manageTranslationMemory(targetLang, memory = null) {
            const storageKey = `translationMemory_${targetLang}`;
            if (memory) localStorage.setItem(storageKey, JSON.stringify(memory));
            else return JSON.parse(localStorage.getItem(storageKey)) || {};
        }
    
        // Translate multiple texts using the Google Translate API in batches
        async function translateTexts(texts, sourceLang, targetLang) {
            if (!targetLang || sourceLang === targetLang) return texts;
    
            const allTranslations = [];
            const batches = [];
    
            for (let i = 0; i < texts.length; i += MAX_BATCH_SIZE) {
                batches.push(texts.slice(i, i + MAX_BATCH_SIZE));
            }
    
            for (const batch of batches) {
                try {
                    const response = await $.ajax({
                    type: 'POST',
                    url: API_URL,
                    data: JSON.stringify({ q: batch, target: targetLang, source: sourceLang, format: 'text' }),
                    contentType: 'application/json'
                    });
        
                    const translations = response.data.translations.map(t => t.translatedText);
                    allTranslations.push(...translations);
                } catch (error) {
                    console.error("Error translating texts:", error);
                    throw error;
                }
            }
    
            return allTranslations;
        }
    
        // Function to translate text nodes and placeholders in batches
        async function translateTextNodesAndPlaceholders(element, sourceLang, targetLang) {
            const translationMemory = manageTranslationMemory(targetLang);
            const textsToTranslate = [];
            const elementsToTranslate = [];
    
            const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT, null, false);
    
            while (walker.nextNode()) {
                const textNode = walker.currentNode;
                const parentElement = textNode.parentElement;
                const originalText = textNode.nodeValue.trim();
        
                if (!originalText || parentElement.closest('.not-translate')) continue; // Skip non-translatable elements
        
                if (!translationMemory[originalText]) {
                    textsToTranslate.push(originalText);
                    elementsToTranslate.push(textNode);
                } else {
                    textNode.nodeValue = translationMemory[originalText]; // Use cached translation
                }
            }
    
            const inputElements = element.querySelectorAll('input[placeholder], textarea[placeholder]');
            inputElements.forEach(input => {
                const originalPlaceholder = input.placeholder.trim();
        
                if (!originalPlaceholder || input.closest('.not-translate')) return; // Skip non-translatable elements
        
                if (!translationMemory[originalPlaceholder]) {
                    textsToTranslate.push(originalPlaceholder);
                    elementsToTranslate.push(input);
                } else {
                    input.placeholder = translationMemory[originalPlaceholder]; // Use cached translation
                }
            });
    
            if (textsToTranslate.length > 0) {
                try {
                    const translatedTexts = await translateTexts(textsToTranslate, sourceLang, targetLang);
        
                    translatedTexts.forEach((translatedText, index) => {
                        const element = elementsToTranslate[index];
                        if (element.nodeType === Node.TEXT_NODE) {
                            element.nodeValue = translatedText;
                        } else {
                            element.placeholder = translatedText;
                        }
                        translationMemory[textsToTranslate[index]] = translatedText; // Update cache
                    });
        
                    manageTranslationMemory(targetLang, translationMemory); // Save updated memory
                } catch (error) {
                    console.error("Batch translation error:", error);
                }
            }
        }
    
        // Function to clear all translation caches
        function clearTranslationMemory() {
            Object.keys(localStorage).forEach(key => {
                if (key.startsWith('translationMemory_')) localStorage.removeItem(key);
            });
            console.log('All translation memories cleared.');
        }
    
        // Function to translate the entire page
        function translatePage(sourceLang, targetLang) {
            if (targetLang === 'en') {
                resetToEnglish();
            } else {
                translateTextNodesAndPlaceholders(document.body, sourceLang, targetLang);
            }
        }
    
        // Function to reset the page to English
        function resetToEnglish() {
            sessionStorage.removeItem('selectedLanguage');
            $('html').attr('lang', 'en');
            clearTranslationMemory();
            location.reload();
        }
    
        // Event listener for language selection
        $('.language-selector').on('click', function () {
            const selectedLang = $(this).data('language');
            const selectedTitle = $(this).data('title');
            const currentLang = $('html').attr('lang') || 'en';
    
            console.log('Translating from:', currentLang, 'to:', selectedLang);
    
            if (selectedLang === 'en') {
                resetToEnglish();
            } else {
                $('#current-language-text').text(selectedTitle);
                saveSelectedLanguage(selectedLang, selectedTitle);
                translatePage(currentLang, selectedLang);
                $('html').attr('lang', selectedLang);
            }
        });
    
        // Initialize the page with the stored language if available
        const storedLang = getSessionItem('selectedLanguage')?.language;
        const storedTitle = getSessionItem('selectedTitle')?.title;
        if (storedLang && storedLang !== 'en') {
            $('html').attr('lang', storedLang);
            translatePage('en', storedLang);
            $('#current-language-text').text(storedTitle);
        }
    });
})(jQuery);

function contactUsForm(){
    $('#contact-us-form').validate({
        rules: {
            customer_name: {
                required: true
            },
            email: {
                required: true
            },
            phone: {
                required: true
            },
            subject: {
                required: true
            },
            message: {
                required: true
            }
        },
        messages: {
            customer_name: {
                required: 'Enter your name'
            },
            email: {
                required: 'Enter your email'
            },
            phone: {
                required: 'Enter your phone'
            },
            subject: {
                required: 'Enter your subject'
            },
            message: {
                required: 'Enter your message'
            }
        },
        submitHandler: function(form) {
            const transaction = 'add customer inquiry form';
          
            $.ajax({
                type: 'POST',
                url: 'components/customer-inquiry/controller/customer-inquiry-controller.php',
                data: $(form).serialize() + '&transaction=' + transaction,
                dataType: 'json',
                beforeSend: function() {
                    disableFormSubmitButton('submit-customer-inquiry');
                },
                success: function (response) {
                    if (response.success) {
                        Swal.fire({
                            title: response.title,
                            text: response.message,
                            icon: 'success'
                        });

                        resetModalForm('contact-us-form');
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
                    enableFormSubmitButton('submit-customer-inquiry');
                }
            });
        
            return false;
        }
    });
}

/*function handleServiceChange() {
    const serviceSelect = document.getElementById('service');
    const cleaningMaterialsSelect = document.getElementById('cleaning_materials');
    const discountAmountInput = document.getElementById('discount-amount'); // Discount amount input field

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
    const totalBookingAmountElement = document.getElementById('total-booking-amount'); // Total booking amount element
    const discountSubtotalElement = document.getElementById('discount-subtotal'); // Discount subtotal element
    let currentGroup = '';
  
    // Add event listeners to inputs to update summary on change
    Object.values(inputs).forEach(input => input.addEventListener('input', updateSummary));
    cleaningMaterialsSelect.addEventListener('change', () => {
        updateCleaningMaterialsSummary();
        updateBookingAmounts(); // Update booking amounts when cleaning materials change
    });
  
    discountAmountInput.addEventListener('input', updateDiscount); // Update discount on change
  
    serviceSelect.addEventListener('change', () => {
        const selectedService = serviceSelect.value;
    
        const serviceGroups = {
            cleaning: ['Deep Cleaning', 'Regular Cleaning', 'Office Cleaning', 'Flat Cleaning', 'Hospital Cleaning'],
            sofa: ['Sofa Cleaning'],
            specialty: ['Mattress Cleaning', 'Curtain Cleaning', 'Carpet Cleaning'],
        };
    
        // Determine the group of the selected service
        let newGroup = '';
        if (serviceGroups.cleaning.includes(selectedService)) newGroup = 'cleaning';
        else if (serviceGroups.sofa.includes(selectedService)) newGroup = 'sofa';
        else if (serviceGroups.specialty.includes(selectedService)) newGroup = 'specialty';
    
        // Only reset fields if the service group has changed
        if (newGroup !== currentGroup) {
            Object.values(fields).forEach(field => field.classList.add('d-none'));
            Object.values(inputs).forEach(input => input.value = '');
        }
    
        // Display relevant fields based on the new group
        if (newGroup === 'cleaning') {
            fields.frequency.classList.remove('d-none');
            fields.duration.classList.remove('d-none');
        } else if (newGroup === 'sofa') {
            fields.seats.classList.remove('d-none');
        } else if (newGroup === 'specialty') {
            fields.meters.classList.remove('d-none');
        }
    
        currentGroup = newGroup;
        updateSummary();  // Call updateSummary to ensure the summary is updated immediately after selection
        updateBookingAmounts(); // Update booking amounts after service selection
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
            const frequency = inputs.frequency.value || 'N/A';
            const duration = inputs.duration.value || 0;
            details = `Frequency: ${frequency}<br/>Duration: ${duration} hours`;
            price = duration * 25;
        } else if (selectedService === 'Mattress Cleaning') {
            const meters = inputs.meters.value || 0;
            details = `Meters: ${meters}`;
            price = meters * 15;
        }
    
        // Update the service summary row
        summaryRow.innerHTML = `
            <td class="product-thumbnail">
            <a href="javascript:void(0);" class="text-dark-gray fw-500 d-block lh-initial" id="service-name-summary">${selectedService}</a>
            <span class="fs-14 d-block" id="service-details">${details}</span>
            </td>
            <td class="product-price" data-title="Price">AED ${price.toFixed(2)}</td>
        `;
    
        updateBookingAmounts(); // Update booking amounts whenever the service changes
    }
  
    function updateCleaningMaterialsSummary() {
        const cleaningMaterials = cleaningMaterialsSelect.value;
        let price = 0;
    
        // Only show price if "Yes" is selected
        if (cleaningMaterials === 'Yes') {
            price = 10; // Set price to 10 AED if "Yes" is selected
            cleaningMaterialsSummaryRow.innerHTML = `
            <td class="product-thumbnail">
                <a href="javascript:void(0);" class="text-dark-gray fw-500 d-block lh-initial">Cleaning Materials</a>
            </td>
            <td class="product-price" data-title="Price">AED ${price.toFixed(2)}</td>
            `;
        } else {
            cleaningMaterialsSummaryRow.innerHTML = ''; // Clear the summary if "No" is selected
        }
    
        updateBookingAmounts(); // Update booking amounts when cleaning materials change
    }
  
    function updateBookingAmounts() {
        let servicePrice = 0;
        let materialsPrice = 0;
    
        // Calculate service price from the current summary
        if (summaryRow.innerHTML.includes('product-price')) {
            const servicePriceText = summaryRow.querySelector('.product-price').textContent;
            servicePrice = parseFloat(servicePriceText.replace('AED ', '')) || 0;
        }
    
        // Calculate cleaning materials price
        if (cleaningMaterialsSummaryRow.innerHTML.includes('product-price')) {
            const materialsPriceText = cleaningMaterialsSummaryRow.querySelector('.product-price').textContent;
            materialsPrice = parseFloat(materialsPriceText.replace('AED ', '')) || 0;
        }
    
        // Calculate booking subtotal
        const bookingSubtotal = servicePrice + materialsPrice;
        bookingSubtotalElement.textContent = `AED ${bookingSubtotal.toFixed(2)}`;
    
        // Calculate total booking amount
        const discount = parseFloat(discountAmountInput.value) || 0;
        const totalBookingAmount = bookingSubtotal - discount;
        totalBookingAmountElement.textContent = `AED ${totalBookingAmount.toFixed(2)}`;
    
        // Update discount subtotal display
        updateDiscount();
    }
  
    function updateDiscount() {
        const discount = parseFloat(discountAmountInput.value) || 0;
        if(discount > 0){
            discountSubtotalElement.textContent = `- AED ${discount.toFixed(2)}`; // Update discount amount
        }
        else{
            discountSubtotalElement.textContent = `AED 0.00`; // Update discount amount
        }
    }
}*/