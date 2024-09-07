<?php
    $getCurtainCleaningSectionsDetails = $sectionsModel->getSections(11);
    $curtainCleaningSectionsBlockStyle = $getCurtainCleaningSectionsDetails['block_style_id'] ?? null;

    $curtainCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($curtainCleaningSectionsBlockStyle);
    $curtainCleaningBlockContainer = $curtainCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $curtainCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $curtainCleaningBlockContainer);

    echo $curtainCleaningBlockContainer;
?>