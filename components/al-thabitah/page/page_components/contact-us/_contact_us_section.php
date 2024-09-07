<?php
    $getContactUsSectionsDetails = $sectionsModel->getSections(14);
    $contactUsSectionsBlockStyle = $getContactUsSectionsDetails['block_style_id'] ?? null;

    $contactUsSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($contactUsSectionsBlockStyle);
    $contactUsBlockContainer = $contactUsSectionsBlockStyleDetails['block_container'] ?? null;

    echo $contactUsBlockContainer;
?>