<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/system-model.php');
    require('components/global/model/security-model.php');
    require('components/menu-item/model/menu-item-model.php');

    $databaseModel = new DatabaseModel();
    $systemModel = new SystemModel();
    $securityModel = new SecurityModel();
    $menuItemModel = new MenuItemModel($databaseModel);

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
                            
                            $sql = $databaseModel->getConnection()->prepare('CALL buildAppModuleStack(:userID)');
                            $sql->bindValue(':userID', $userID, PDO::PARAM_INT);
                            $sql->execute();
                            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                            $sql->closeCursor();
                        
                            foreach ($options as $row) {
                                $appModuleID = $row['app_module_id'];
                                $appModuleName = $row['app_module_name'];
                                $appVersion = $row['app_version'];
                                $menuItemID = $row['menu_item_id'];
                                $appLogo = $systemModel->checkImage($row['app_logo'], 'app module logo');

                                $menuItemDetails = $menuItemModel->getMenuItem($menuItemID);
                                $menuItemURL = $menuItemDetails['menu_item_url'];
                                    
                                $apps .= '<div class="col-lg-2">
                                            <a href="'. $menuItemURL .'?app_module_id='. $securityModel->encryptData($appModuleID) .'&page_id='. $securityModel->encryptData($menuItemID) .'">
                                                <div class="card light-gradient">
                                                    <div class="card-body text-center px-3 pb-4">
                                                        <div class="d-flex align-items-center justify-content-center round-48 rounded flex-shrink-0 mb-2 mx-auto">
                                                            <img src="'. $appLogo .'" width="55" height="55" class="mb-2" alt="app-logo">
                                                        </div>
                                                        <h5 class="d-flex align-items-center text-dark justify-content-center gap-1">'. $appModuleName .'</h5>
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