<?php
    $getBookingFormSectionsDetails = $sectionsModel->getSections(16);
    $BookingFormSectionsBlockStyle = $getBookingFormSectionsDetails['block_style_id'] ?? null;

    $BookingFormSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($BookingFormSectionsBlockStyle);
    $BookingFormBlockContainer = $BookingFormSectionsBlockStyleDetails['block_container'] ?? null;

    echo $BookingFormBlockContainer;
?>