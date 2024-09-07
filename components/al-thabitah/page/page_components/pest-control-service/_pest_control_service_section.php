<?php
    $getPestControlServiceSectionsDetails = $sectionsModel->getSections(13);
    $pestControlServiceSectionsBlockStyle = $getPestControlServiceSectionsDetails['block_style_id'] ?? null;

    $pestControlServiceSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($pestControlServiceSectionsBlockStyle);
    $pestControlServiceBlockContainer = $pestControlServiceSectionsBlockStyleDetails['block_container'] ?? null;

    ob_start();
    include './components/al-thabitah/view/_services_shortcut.php';
    $servicesShortcutContent = ob_get_clean();
    $pestControlServiceBlockContainer = str_replace('#{SERVICES_SHORTCUT}', $servicesShortcutContent, $pestControlServiceBlockContainer);

    echo $pestControlServiceBlockContainer;
?>