<?php
    $getAboutUsSectionsDetails = $sectionsModel->getSections(1);
    $aboutUsSectionsBlockStyle = $getAboutUsSectionsDetails['block_style_id'] ?? null;

    $aboutUsSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($aboutUsSectionsBlockStyle);

    echo $aboutUsSectionsBlockStyleDetails['block_container'] ?? null;
?>