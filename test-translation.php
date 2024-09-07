<!DOCTYPE html>
<html>
<head>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div>
        <p id="company">company</p>
    </div>
    <div>
        <p>Translate</p>
        <input type="text" id="text-to-translate" placeholder="Enter text to translate">
        <select id="gender">
            <option value="Male" selected>Male</option>
            <option value="Female">Female</option>
        </select>

        <select id="language">
            <option value="en" selected>English</option>
            <option value="ar">Arabic</option>
            <option value="fr">French</option>
            <option value="es">Spanish</option>
            <!-- Add more language options as needed -->
        </select>
        <button id="translate-button">Translate</button>
    </div>

    <script>
        // Google Translate API endpoint
        const API_URL = 'https://translation.googleapis.com/language/translate/v2?key=AIzaSyDtaHoYl8ZWzeO2_sinZAxV9INtNogyWhg';

       /// دالة لترجمة النص
function translateText(text, targetLang, callback) {
  const data = { q: text, target: targetLang };
  $.ajax({
    type: 'POST',
    url: API_URL,
    data: JSON.stringify(data),
    contentType: 'application/json',
    success: function(response) {
      callback(response.data.translations[0].translatedText);
    },
    error: function(xhr, status, error) {
      console.error(xhr, status, error);
      callback(text); // إرجاع النص الأصلي إذا فشلت الترجمة
    }
  });
}

// دالة لترجمة كل النص في الصفحة
function translatePage() {
  const lang = $('#language').val();
  const elementsToTranslate = $('*').not('script, style, iframe, img'); // exclude non-translatable elements

  // create a translation memory object
  const translationMemory = {};

  elementsToTranslate.each(function() {
    const element = $(this);
    const text = element.text();

    // check if the text is already translated in the memory
    if (translationMemory[text]) {
      element.html(translationMemory[text]);
    } else {
      // translate the text using machine translation
      translateText(text, lang, function(translatedText) {
        element.html(translatedText); // use html() to preserve HTML structure
        translationMemory[text] = translatedText; // store the translation in memory
      });
    }

    // translate attributes that contain text
    const attributesToTranslate = ['placeholder', 'title', 'alt'];
    $.each(attributesToTranslate, function(index, attribute) {
      const attrValue = element.attr(attribute);
      if (attrValue !== undefined && attrValue !== '') {
        translateText(attrValue, lang, function(translatedAttrValue) {
          element.attr(attribute, translatedAttrValue);
        });
      }
    });
  });

  // translate templates and themes
  const templatesToTranslate = ['header', 'footer', 'sidebar'];
  $.each(templatesToTranslate, function(index, template) {
    const templateHtml = $(template).html();
    translateText(templateHtml, lang, function(translatedTemplateHtml) {
      $(template).html(translatedTemplateHtml);
    });
  });

  // translate JavaScript code
  const jsCodeToTranslate = ['script1', 'script2'];
  $.each(jsCodeToTranslate, function(index, jsCode) {
    const jsCodeText = $(jsCode).text();
    translateText(jsCodeText, lang, function(translatedJsCodeText) {
      $(jsCode).text(translatedJsCodeText);
    });
  });
}

// ربط حدث النقر على زر الترجمة
$('#translate-button').on('click', function() {
  translatePage();
});
    </script>
</body>
</html>