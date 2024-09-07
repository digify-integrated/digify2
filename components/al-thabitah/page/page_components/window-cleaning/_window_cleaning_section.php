<?php
    $getWindowCleaningSectionsDetails = $sectionsModel->getSections(7);
    $windowCleaningSectionsBlockStyle = $getWindowCleaningSectionsDetails['block_style_id'] ?? null;

    $windowCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($windowCleaningSectionsBlockStyle);
    $windowCleaningBlockContainer = $windowCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $windowCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $windowCleaningBlockContainer);

    echo $windowCleaningBlockContainer;
?>