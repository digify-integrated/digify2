<?php
    $getCarpetCleaningSectionsDetails = $sectionsModel->getSections(9);
    $carpetCleaningSectionsBlockStyle = $getCarpetCleaningSectionsDetails['block_style_id'] ?? null;

    $carpetCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($carpetCleaningSectionsBlockStyle);
    $carpetCleaningBlockContainer = $carpetCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $carpetCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $carpetCleaningBlockContainer);

    echo $carpetCleaningBlockContainer;
?>