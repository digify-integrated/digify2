<?php
    $getContactUsMapSectionsDetails = $sectionsModel->getSections(15);
    $contactUsMapSectionsBlockStyle = $getContactUsMapSectionsDetails['block_style_id'] ?? null;

    $contactUsMapSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($contactUsMapSectionsBlockStyle);
    $contactUsMapBlockContainer = $contactUsMapSectionsBlockStyleDetails['block_container'] ?? null;

    echo $contactUsMapBlockContainer;
?>