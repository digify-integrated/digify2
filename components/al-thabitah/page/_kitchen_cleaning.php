<?php
    require('components/page-title/model/page-title-model.php');
    require('components/sections/model/sections-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);
    $sectionsModel = new SectionsModel($databaseModel);

    require_once('page_components/kitchen-cleaning/_kitchen_cleaning_page_title.php');
    require_once('page_components/kitchen-cleaning/_kitchen_cleaning_section.php');
?>