<?php
    $getAboutUsVisionMissionSectionsDetails = $sectionsModel->getSections(2);
    $aboutUsVisionMissionSectionsBlockStyle = $getAboutUsVisionMissionSectionsDetails['block_style_id'] ?? null;

    $aboutUsVisionMissionSectionsBlockStyleDetails = $blockStyleModel->getBlockContainer($aboutUsVisionMissionSectionsBlockStyle);

    echo $aboutUsVisionMissionSectionsBlockStyleDetails['block_container'] ?? null;
?>