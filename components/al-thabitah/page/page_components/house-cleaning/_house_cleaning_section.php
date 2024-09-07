<?php
    $getHouseCleaningSectionsDetails = $sectionsModel->getSections(3);
    $houseCleaningSectionsBlockStyle = $getHouseCleaningSectionsDetails['block_style_id'] ?? null;

    $houseCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($houseCleaningSectionsBlockStyle);
    $houseCleaningBlockContainer = $houseCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $houseCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $houseCleaningBlockContainer);

    echo $houseCleaningBlockContainer;
?>