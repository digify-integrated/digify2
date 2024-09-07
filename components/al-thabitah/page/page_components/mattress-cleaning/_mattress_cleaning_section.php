<?php
    $getMattressCleaningSectionsDetails = $sectionsModel->getSections(10);
    $mattressCleaningSectionsBlockStyle = $getMattressCleaningSectionsDetails['block_style_id'] ?? null;

    $mattressCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($mattressCleaningSectionsBlockStyle);
    $mattressCleaningBlockContainer = $mattressCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $mattressCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $mattressCleaningBlockContainer);

    echo $mattressCleaningBlockContainer;
?>