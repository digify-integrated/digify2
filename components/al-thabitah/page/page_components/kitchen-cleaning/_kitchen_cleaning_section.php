<?php
    $getKitchenCleaningSectionsDetails = $sectionsModel->getSections(5);
    $kitchenCleaningSectionsBlockStyle = $getKitchenCleaningSectionsDetails['block_style_id'] ?? null;

    $kitchenCleaningSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($kitchenCleaningSectionsBlockStyle);
    $kitchenCleaningBlockContainer = $kitchenCleaningSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $kitchenCleaningBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $kitchenCleaningBlockContainer);

    echo $kitchenCleaningBlockContainer;
?>