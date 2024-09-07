<?php
    $getWaterTankCleaningSectionsDetails = $sectionsModel->getSections(6);
    $waterTankCleaningSectionsBlockStyle = $getWaterTankCleaningSectionsDetails['block_style_id'] ?? null;

    $waterTankCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($waterTankCleaningSectionsBlockStyle);
    $waterTankCleaningBlockContainer = $waterTankCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $waterTankCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $waterTankCleaningBlockContainer);

    echo $waterTankCleaningBlockContainer;
?>