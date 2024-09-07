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

// Translate text using the Google Translate API
function translateText(text, sourceLang, targetLang) {
    return new Promise((resolve, reject) => {
        // Prevent translating to the same language
        if (sourceLang === targetLang) {
            resolve(text);
            return;
        }

        const data = {
            q: text,
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
                resolve(response.data.translations[0].translatedText);
            },
            error: function (xhr, status, error) {
                console.error("Error translating text:", xhr.responseText);
                reject(error);
            }
        });
    });
}

// Check if an element or any of its parents has the 'not-translate' class
function hasNotTranslateClass(element) {
    return element.closest('.not-translate') !== null;
}

// Function to recursively translate text nodes and placeholders
async function translateTextNodesAndPlaceholders(element, sourceLang, targetLang) {
    const translationMemory = JSON.parse(localStorage.getItem('translationMemory')) || {};

    const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT, null, false);

    // Translate text nodes
    while (walker.nextNode()) {
        const textNode = walker.currentNode;
        const parentElement = textNode.parentElement;
        const originalText = textNode.nodeValue.trim();

        // Skip translation if the element or any of its parents has the 'not-translate' class
        if (hasNotTranslateClass(parentElement)) continue;

        if (originalText && !translationMemory[originalText]) {
            try {
                const translatedText = await translateText(originalText, sourceLang, targetLang);
                textNode.nodeValue = translatedText; // Update text node
                translationMemory[originalText] = translatedText;
            } catch (error) {
                console.error("Translation error:", error);
            }
        } else if (translationMemory[originalText]) {
            textNode.nodeValue = translationMemory[originalText]; // Use cached translation
        }
    }

    // Translate placeholder text for input elements
    const inputElements = element.querySelectorAll('input[placeholder], textarea[placeholder]');
    for (const input of inputElements) {
        const originalPlaceholder = input.placeholder.trim();

        // Skip translation for elements with .not-translate class or their parents
        if (hasNotTranslateClass(input)) continue;

        if (originalPlaceholder && !translationMemory[originalPlaceholder]) {
            try {
                const translatedPlaceholder = await translateText(originalPlaceholder, sourceLang, targetLang);
                input.placeholder = translatedPlaceholder; // Update placeholder
                translationMemory[originalPlaceholder] = translatedPlaceholder;
            } catch (error) {
                console.error("Translation error:", error);
            }
        } else if (translationMemory[originalPlaceholder]) {
            input.placeholder = translationMemory[originalPlaceholder]; // Use cached translation
        }
    }

    // Store translations in localStorage
    localStorage.setItem('translationMemory', JSON.stringify(translationMemory));
}

// Function to translate all text nodes and placeholders on the page
function translatePage(sourceLang, targetLang) {
    const bodyElement = document.body; // Start from the body element
    translateTextNodesAndPlaceholders(bodyElement, sourceLang, targetLang); // Translate text nodes and placeholders
}

// Event listener for language selection change
$('#language').on('change', function () {
    const selectedLang = $(this).val();
    const currentLang = $('html').attr('lang') || 'en'; // Default to English if not set
    translatePage(currentLang, selectedLang); // Translate page from current language to selected language
    $('html').attr('lang', selectedLang); // Update the HTML language attribute
});



        </script>

    </body>
</html>