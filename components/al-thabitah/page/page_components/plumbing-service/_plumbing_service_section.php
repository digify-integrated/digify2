<?php
    $getPlumbingServiceSectionsDetails = $sectionsModel->getSections(12);
    $plumbingServiceSectionsBlockStyle = $getPlumbingServiceSectionsDetails['block_style_id'] ?? null;

    $plumbingServiceSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($plumbingServiceSectionsBlockStyle);
    $plumbingServiceBlockContainer = $plumbingServiceSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $plumbingServiceBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $plumbingServiceBlockContainer);

    echo $plumbingServiceBlockContainer;
?>