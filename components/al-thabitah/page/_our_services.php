<?php
    require('components/page-title/model/page-title-model.php');
    require('components/services-box/model/services-box-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);
    $servicesBoxModel = new ServicesBoxModel($databaseModel);

    require_once('page_components/our-services/_our_services_page_title.php');
    require_once('page_components/our-services/_our_services_services_box.php');
?>