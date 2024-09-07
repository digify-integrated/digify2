<?php
    $getOfficeCleaningSectionsDetails = $sectionsModel->getSections(4);
    $officeCleaningSectionsBlockStyle = $getOfficeCleaningSectionsDetails['block_style_id'] ?? null;

    $officeCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($officeCleaningSectionsBlockStyle);
    $officeCleaningBlockContainer = $officeCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $officeCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $officeCleaningBlockContainer);

    echo $officeCleaningBlockContainer;
?>