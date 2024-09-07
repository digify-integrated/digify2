<?php
    $getSofaCleaningSectionsDetails = $sectionsModel->getSections(8);
    $sofaCleaningSectionsBlockStyle = $getSofaCleaningSectionsDetails['block_style_id'] ?? null;

    $sofaCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($sofaCleaningSectionsBlockStyle);
    $sofaCleaningBlockContainer = $sofaCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $sofaCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $sofaCleaningBlockContainer);

    echo $sofaCleaningBlockContainer;
?>