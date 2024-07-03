<?php
    require('components/global/view/_required_php_files.php');
    require('components/global/view/_check_user_status.php');
    require('components/global/view/_page_details.php');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical" data-boxed-layout="full">
<head>
    <?php require_once('components/global/view/_head.php'); ?>
    <link rel="stylesheet" href="./assets/libs/datatables.net-bs5/css/dataTables.bootstrap5.min.css" />
    <link rel="stylesheet" href="./assets/libs/select2/dist/css/select2.min.css">
</head>
<body>
    <?php require_once('components/global/view/_preloader.php'); ?>
    <div id="main-wrapper">
        <?php require_once('components/global/view/_sidebar.php'); ?>
        <div class="page-wrapper">
            <?php require_once('components/global/view/_header.php'); ?>
            <div class="body-wrapper">
                <div class="container-fluid">
                    <?php 
                        require_once('components/global/view/_breadcrumbs.php'); 

                        if($newRecord){
                            require_once('components/civil-status/view/_civil_status_new.php');
                        }
                        else if(!empty($detailID)){
                            require_once('components/civil-status/view/_civil_status_details.php');
                        }
                        else{
                            require_once('components/civil-status/view/_civil_status.php');
                        }
                    ?>
                </div>
                <?php require_once('components/global/view/_customizer.php'); ?>
            </div>
        </div>
    </div>

    <div class="dark-transparent sidebartoggler"></div>
    <?php 
        require_once('components/global/view/_error_modal.php');
        require_once('components/global/view/_global_js.php');
    ?>

    <script src="./assets/libs/max-length/bootstrap-maxlength.min.js"></script>
    <script src="./assets/libs/datatables.net/js/jquery.dataTables.min.js"></script>

    <?php
        $scriptLink = 'civil-status.js';

        if($newRecord){
            $scriptLink = 'civil-status-new.js';
        }
        else if(!empty($detailID)){
            $scriptLink = 'civil-status-details.js';
        }

        echo '<script src="./components/civil-status/js/'. $scriptLink .'?v=' . rand() .'"></script>';
    ?>
</body>

</html>