<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/system-model.php');
    require('components/global/model/security-model.php');

    $databaseModel = new DatabaseModel();
    $systemModel = new SystemModel();
    $securityModel = new SecurityModel();

    $pageTitle = 'Apps';

    require('components/global/config/session.php');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">

<head>
    <?php include_once('components/global/view/_head.php'); ?>
</head>

<body>
    <?php include_once('components/global/view/_preloader.php'); ?>
    <div id="main-wrapper" class="o_home_menu_background">
        <div class="body-wrapper bg-transparent w-100">
            <div class="container-fluid">
                <div class="row">
                        <?php
                            $apps = '';
                            
                            $sql = $databaseModel->getConnection()->prepare('CALL buildAppModule(:userID)');
                            $sql->bindValue(':userID', $userID, PDO::PARAM_INT);
                            $sql->execute();
                            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                            $sql->closeCursor();
                        
                            foreach ($options as $row) {
                                $appModuleID = $row['app_module_id'];
                                $appModuleName = $row['app_module_name'];
                                $appVersion = $row['app_version'];
                                $redirectLink = $row['redirect_link'];
                                $appLogo = $systemModel->checkImage($row['app_logo'], 'app module logo');
                                    
                                $apps .= '<div class="col-lg-2">
                                            <a href="'. $redirectLink .'?app_module_id='. $securityModel->encryptData($appModuleID) .'">
                                                <div class="card border-0 zoom-in bg-light-subtle shadow-none">
                                                    <div class="card-body">
                                                        <div class="text-center">
                                                            <img src="'. $appLogo .'" width="50" height="50" class="mb-3" alt="app-logo">
                                                            <p class="fw-semibold fs-3 text-dark mb-1">'. $appModuleName .'</p> 
                                                        </div>
                                                    </div>
                                                </div>
                                                </a>
                                        </div>';
                            }
                        
                            echo $apps;
                        ?>
                </div>            
            </div>
        </div>
    </div>
    <?php 
        include_once('./components/global/view/_error_modal.php');
        include_once('./components/global/view/_global_js.php');
    ?>
    <script src="./components/authentication/js/index.js?v=<?php echo rand(); ?>"></script>
</body>

</html>