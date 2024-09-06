<?php
    require('components/slider/model/slider-model.php');
    require('components/call-to-action/model/call-to-action-model.php');
    require('components/client/model/client-model.php');
    require('components/services-box/model/services-box-model.php');

    $sliderModel = new SliderModel($databaseModel);
    $callToActionModel = new CallToActionModel($databaseModel);
    $clientModel = new ClientModel($databaseModel);
    $servicesBoxModel = new ServicesBoxModel($databaseModel);

    require_once('page_components/home/_home_slider.php');
    require_once('page_components/home/_home_call_to_action_1.php');
    require_once('page_components/home/_home_call_to_action_2.php');
    require_once('page_components/global/_global_client.php');
    require_once('page_components/home/_home_services_box.php');
    require_once('page_components/home/_home_call_to_action_3.php');
    require_once('page_components/home/_home_call_to_action_4.php');
?>