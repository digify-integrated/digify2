<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/block-style/model/block-style-model.php');
    
    $databaseModel = new DatabaseModel();
    $blockStyleModel = new BlockStyleModel($databaseModel);
?>

<!DOCTYPE html>
<html class="no-js" lang="en">
    <?php require_once('./components/al-thabitah/view/_head.php'); ?>
    <body data-mobile-nav-style="classic">
        <div class="page-loader"></div>
        <?php 
            require_once('./components/al-thabitah/view/_header.php'); 
        
            if(isset($_GET['page']) && !empty($_GET['page'])){
                $page = $_GET['page'];

                switch ($page) {
                    case 'about_us':
                        require_once('./components/al-thabitah/page/_about_us.php');
                        break;
                    case 'our_services':
                        require_once('./components/al-thabitah/page/_our_services.php');
                        break;
                    case 'house_cleaning':
                        require_once('./components/al-thabitah/page/_house_cleaning.php');
                        break;
                    case 'office_cleaning':
                        require_once('./components/al-thabitah/page/_office_cleaning.php');
                        break;
                    case 'kitchen_cleaning':
                        require_once('./components/al-thabitah/page/_kitchen_cleaning.php');
                        break;
                    case 'water_tank_cleaning':
                        require_once('./components/al-thabitah/page/_water_tank_cleaning.php');
                        break;
                    case 'window_cleaning':
                        require_once('./components/al-thabitah/page/_window_cleaning.php');
                        break;
                    case 'sofa_cleaning':
                        require_once('./components/al-thabitah/page/_sofa_cleaning.php');
                        break;
                    case 'carpet_cleaning':
                        require_once('./components/al-thabitah/page/_carpet_cleaning.php');
                        break;
                    case 'mattress_cleaning':
                        require_once('./components/al-thabitah/page/_mattress_cleaning.php');
                        break;
                    case 'curtain_cleaning':
                        require_once('./components/al-thabitah/page/_curtain_cleaning.php');
                        break;
                    case 'plumbing_service':
                        require_once('./components/al-thabitah/page/_plumbing_service.php');
                        break;
                    case 'pest_control_service':
                        require_once('./components/al-thabitah/page/_pest_control_service.php');
                        break;
                    case 'booking':
                        require_once('./components/al-thabitah/page/_booking.php');
                        break;
                    case 'contact_us':
                        require_once('./components/al-thabitah/page/_contact_us.php');
                        break;
                    default:
                        require_once('./components/al-thabitah/page/404.php');
                        break;
                }
            }
            else{
                require_once('./components/al-thabitah/page/_home.php');
            }
            
            require_once('./components/al-thabitah/view/_footer.php'); 
            require_once('./components/al-thabitah/view/_required_javascript.php'); 
        ?>

<script>
           // Google Translate API endpoint
// Google Translate API endpoint
// Google Translate API endpoint
const API_URL = 'https://translation.googleapis.com/language/translate/v2?key=AIzaSyDtaHoYl8ZWzeO2_sinZAxV9INtNogyWhg'; // Replace with your actual API key

// Save selected language in session storage with expiration
function saveSelectedLanguage(language) {
    const now = new Date();
    const expiryTime = now.getTime() + (24 * 60 * 60 * 1000); // 24 hours in milliseconds
    const languageData = { language, expiry: expiryTime };
    sessionStorage.setItem('selectedLanguage', JSON.stringify(languageData));
}

// Retrieve the selected language from session storage, if valid
function getSelectedLanguage() {
    const languageData = JSON.parse(sessionStorage.getItem('selectedLanguage'));
    if (languageData) {
        const now = new Date().getTime();
        if (now < languageData.expiry) {
            return languageData.language;
        } else {
            sessionStorage.removeItem('selectedLanguage'); // Remove expired language setting
        }
    }
    return null; // Default if no valid language is found
}

// Remove selected language from session storage
function clearSelectedLanguage() {
    sessionStorage.removeItem('selectedLanguage');
}

// Translate multiple texts using the Google Translate API
function translateTexts(texts, sourceLang, targetLang) {
    return new Promise((resolve, reject) => {
        if (sourceLang === targetLang) {
            resolve(texts); // No translation needed
            return;
        }

        const data = {
            q: texts,
            target: targetLang,
            source: sourceLang,
            format: 'text'
        };

        $.ajax({
            type: 'POST',
            url: API_URL,
            data: JSON.stringify(data),
            contentType: 'application/json',
            success: function (response) {
                const translations = response.data.translations.map(t => t.translatedText);
                resolve(translations);
            },
            error: function (xhr, status, error) {
                console.error("Error translating texts:", xhr.responseText);
                reject(error);
            }
        });
    });
}

// Function to check if an element or any of its parents has the 'not-translate' class
function hasNotTranslateClass(element) {
    return element.closest('.not-translate') !== null;
}

// Retrieve translations from localStorage or create a new object if not available
function getTranslationMemory(targetLang) {
    return JSON.parse(localStorage.getItem(`translationMemory_${targetLang}`)) || {};
}

// Save translations to localStorage with a language-specific key
function saveTranslationMemory(targetLang, memory) {
    localStorage.setItem(`translationMemory_${targetLang}`, JSON.stringify(memory));
}

// Function to translate text nodes and placeholders in batches
async function translateTextNodesAndPlaceholders(element, sourceLang, targetLang) {
    let translationMemory = getTranslationMemory(targetLang); // Retrieve language-specific translation memory
    const textsToTranslate = [];
    const elementsToTranslate = [];

    const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT, null, false);

    // Collect text nodes for translation
    while (walker.nextNode()) {
        const textNode = walker.currentNode;
        const parentElement = textNode.parentElement;
        const originalText = textNode.nodeValue.trim();

        if (hasNotTranslateClass(parentElement) || !originalText) continue; // Skip non-translatable elements

        if (!translationMemory[originalText]) {
            textsToTranslate.push(originalText);
            elementsToTranslate.push(textNode);
        } else {
            textNode.nodeValue = translationMemory[originalText]; // Use cached translation
        }
    }

    // Collect placeholder texts for input elements
    const inputElements = element.querySelectorAll('input[placeholder], textarea[placeholder]');
    for (const input of inputElements) {
        const originalPlaceholder = input.placeholder.trim();

        if (hasNotTranslateClass(input) || !originalPlaceholder) continue; // Skip non-translatable elements

        if (!translationMemory[originalPlaceholder]) {
            textsToTranslate.push(originalPlaceholder);
            elementsToTranslate.push(input);
        } else {
            input.placeholder = translationMemory[originalPlaceholder]; // Use cached translation
        }
    }

    // Batch translate texts
    if (textsToTranslate.length > 0) {
        try {
            const translatedTexts = await translateTexts(textsToTranslate, sourceLang, targetLang);

            translatedTexts.forEach((translatedText, index) => {
                const element = elementsToTranslate[index];
                if (element.nodeType === Node.TEXT_NODE) {
                    element.nodeValue = translatedText; // Update text node
                } else if (element.placeholder !== undefined) {
                    element.placeholder = translatedText; // Update placeholder
                }
                // Update cache with translated text
                translationMemory[textsToTranslate[index]] = translatedText;
            });

            saveTranslationMemory(targetLang, translationMemory); // Save updated memory
        } catch (error) {
            console.error("Batch translation error:", error);
        }
    }
}

// Function to reset the page to English without re-translation
function resetToEnglish() {
    clearSelectedLanguage(); // Clear saved language setting
    $('html').attr('lang', 'en'); // Set HTML language attribute to English
    clearTranslationMemory(); // Clear translation memory
    location.reload(); // Reload the page to reset to default English text
}

// Function to clear all translation caches (for debugging or reset)
function clearTranslationMemory() {
    Object.keys(localStorage).forEach(key => {
        if (key.startsWith('translationMemory_')) {
            localStorage.removeItem(key);
        }
    });
    console.log('All translation memories cleared.');
}

// Function to translate all text nodes and placeholders on the page
function translatePage(sourceLang, targetLang) {
    const bodyElement = document.body; // Start from the body element

    if (targetLang === 'en') {
        resetToEnglish(); // Reset to English without re-translation
    } else {
        translateTextNodesAndPlaceholders(bodyElement, sourceLang, targetLang); // Translate text nodes and placeholders
    }
}

// Event listener for language selection change
$('#language').on('change', function () {
    const selectedLang = $(this).val();
    const currentLang = $('html').attr('lang') || 'en'; // Default to English if not set
    console.log('Translating from:', currentLang, 'to:', selectedLang);

    if (selectedLang === 'en') {
        resetToEnglish(); // Reset to English
    } else {
        saveSelectedLanguage(selectedLang); // Save the selected language
        translatePage(currentLang, selectedLang); // Translate page from current language to selected language
        $('html').attr('lang', selectedLang); // Update the HTML language attribute
    }
});

// On page load, check if there is a stored language and use it as default
$(document).ready(function() {
    const storedLang = getSelectedLanguage();
    if (storedLang && storedLang !== 'en') {
        $('html').attr('lang', storedLang); // Set the stored language as default
        translatePage('en', storedLang); // Translate page to stored language
        $('#language').val(storedLang); // Update the dropdown to reflect the stored language
    }
});
        </script>

    </body>
</html>