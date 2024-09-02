<?php
require_once("assets/libs/libretranslate/LibreTranslate.php");

use Jefs42\LibreTranslate;

class MyTranslator {
    private $translator;

    public function __construct() {
        $this->translator = new LibreTranslate('https://trans.zillyhuhn.com');
    }

    public function translate($texts, $source_language, $target_language) {
        $translations = [];

        foreach ($texts as $text) {
            $response = $this->translator->translate($text, $source_language, $target_language);
        
            if (is_string($response)) {
                $translations[] = $response;
            } else {
                var_dump($response); // Inspect the response
                throw new \Exception('Translation failed: Unknown error');
            }
        }

        return $translations;
    }    
}

$translator = new MyTranslator();

if (isset($_POST['texts']) && isset($_POST['source_language']) && isset($_POST['target_language'])) {
    $texts = $_POST['texts'];
    $source_language = $_POST['source_language'];
    $target_language = $_POST['target_language'];

    try {
        $translations = $translator->translate($texts, $source_language, $target_language);
        echo json_encode(['translations' => $translations]);
    } catch (\Exception $e) {
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Invalid request']);
}
?>