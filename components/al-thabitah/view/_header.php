<?php
    require('components/header/model/header-model.php');

    $headerModel = new HeaderModel($databaseModel);

    $getHeaderDetails = $headerModel->getHeader(1);
    $headerBlockStyle = $getHeaderDetails['block_style_id'] ?? null;

    $headerBlockStyleDetails = $blockStyleModel->getBlockContainer($headerBlockStyle);

    echo $headerBlockStyleDetails['block_container'] ?? null;
?>