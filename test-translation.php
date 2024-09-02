<!DOCTYPE html>
<html>
<head>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div>
        <p class="to_translate">company</p>
    </div>
    <div>
        <p class="to_translate">Translate</p>
    </div>

    <script>
        $(document).ready(function() {
    var texts = [];
    var elements = [];

    $('.to_translate').each(function() {
        texts.push($(this).text());
        elements.push($(this));
    });

    $.ajax({
        type: 'POST',
        url: 'test.php',
        data: {
            texts: texts,
            source_language: 'en',
            target_language: 'ar'
        },
        dataType: 'json',
        success: function(response) {
            if (response.translations) {
                for (var i = 0; i < response.translations.length; i++) {
                    elements[i].text(response.translations[i]);
                }
            } else {
                console.error(response.error);
            }
        }
    });
});
    </script>
</body>
</html>