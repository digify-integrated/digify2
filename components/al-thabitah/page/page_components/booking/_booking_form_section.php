<?php
    $getBookingFormSectionsDetails = $sectionsModel->getSections(16);
    $BookingFormSectionsBlockStyle = $getBookingFormSectionsDetails['block_style_id'] ?? null;

    $BookingFormSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($BookingFormSectionsBlockStyle);
    $BookingFormBlockContainer = $BookingFormSectionsBlockStyleDetails['block_container'] ?? null;
    
    $BookingFormBlockContainer = str_replace('#{CURRENT_DATE}', date('Y-m-d'), $BookingFormBlockContainer);

    echo $BookingFormBlockContainer;
?>