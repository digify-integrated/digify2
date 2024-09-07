<?php
    require('components/page-title/model/page-title-model.php');
    require('components/sections/model/sections-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);
    $sectionsModel = new SectionsModel($databaseModel);

    require_once('page_components/pest-control-service/_pest_control_service_page_title.php');
    require_once('page_components/pest-control-service/_pest_control_service_section.php');
?>