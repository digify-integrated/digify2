(function ($) {
    'use strict';
  
    $(function () {
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