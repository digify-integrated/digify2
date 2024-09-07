<?php
    $getContactUsContactFormDetails = $contactFormModel->getContactForm(1);
    $contactUsContactFormBlockStyle = $getContactUsContactFormDetails['block_style_id'] ?? null;

    $contactUsContactFormBlockStyleDetails = $blockStyleModel->getBlockContainer($contactUsContactFormBlockStyle);
    $contactUsContactFormBlockContainer = $contactUsContactFormBlockStyleDetails['block_container'] ?? null;

    echo $contactUsContactFormBlockContainer;
?>