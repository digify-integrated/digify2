<?php
require_once("assets/libs/libretranslate/LibreTranslate.php");

use Jefs42\LibreTranslate;

class MyTranslator {
    private $translator;

    public function __construct() {
        $this->translator = new LibreTranslate('https://trans.zillyhuhn.com');
    }

    public function translate($text, $source_language, $target_language) {
        $response = $this->translator->translate($text, $source_language, $target_language);
    
        if (is_string($response)) {
            return $response;
        } else {
            var_dump($response); // Inspect the response
            throw new \Exception('Translation failed: Unknown error');
        }
    }    
}

$translator = new MyTranslator();

$text = "HOW CAN WE HELP YOU?
Need cleaning solutions? Get in touch with us!
We’re here to help with any questions you might have and look forward to connecting with you. Feel free to reach out to us or drop by our office for a friendly chat over coffee.";
$source_language = 'en';
$target_language = 'ar';

try {
    $translated_text = $translator->translate($text, $source_language, $target_language);
    echo $translated_text; // Outputs: ¡Hola!
} catch (\Exception $e) {
    echo 'Error: ' . $e->getMessage();
}
?>