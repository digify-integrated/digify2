<?php
    require('components/page-title/model/page-title-model.php');
    require('components/sections/model/sections-model.php');
    require('components/client/model/client-model.php');
    require('components/testimonial/model/testimonial-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);
    $sectionsModel = new SectionsModel($databaseModel);
    $clientModel = new ClientModel($databaseModel);
    $testimonialModel = new TestimonialModel($databaseModel);

    require_once('page_components/about-us/_about_us_page_title.php');
    require_once('page_components/about-us/_about_us_section.php');
    require_once('page_components/about-us/_about_us_vision_mission.php');
    require_once('page_components/global/_global_client.php');
    require_once('page_components/about-us/_about_us_testimonial.php');
?>