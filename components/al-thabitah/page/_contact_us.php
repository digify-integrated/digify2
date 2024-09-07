<?php
    require('components/page-title/model/page-title-model.php');
    require('components/sections/model/sections-model.php');
    require('components/contact-form/model/contact-form-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);
    $sectionsModel = new SectionsModel($databaseModel);
    $contactFormModel = new ContactFormModel($databaseModel);

    require_once('page_components/contact-us/_contact_us_page_title.php');
    require_once('page_components/contact-us/_contact_us_section.php');
    require_once('page_components/contact-us/_contact_us_map_section.php');
    require_once('page_components/contact-us/_contact_us_contact_form.php');
?>