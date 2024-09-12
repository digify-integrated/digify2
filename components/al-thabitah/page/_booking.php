<?php
    require('components/page-title/model/page-title-model.php');
    require('components/sections/model/sections-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);
    $sectionsModel = new SectionsModel($databaseModel);

    require_once('page_components/booking/_booking_page_title.php');
    require_once('page_components/booking/_booking_form_section.php');
?>