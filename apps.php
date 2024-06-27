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
    <?php require_once('components/global/view/_head.php'); ?>
</head>

<body>
    <?php require_once('components/global/view/_preloader.php'); ?>
    <div id="main-wrapper" class="o_home_menu_background">
        <div class="body-wrapper apps-wrapper bg-transparent w-100">
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
                            $appModuleDescription = $row['app_module_description'];
                            $appVersion = $row['app_version'];
                            $menuItemID = $row['menu_item_id'];
                            $appLogo = $systemModel->checkImage($row['app_logo'], 'app module logo');

                            $menuItemDetails = $menuItemModel->getMenuItem($menuItemID);
                            $menuItemURL = $menuItemDetails['menu_item_url'];
                                    
                            $apps .= '<div class="col-lg-2 hover-img">
                                        <a href="'. $menuItemURL .'?app_module_id='. $securityModel->encryptData($appModuleID) .'&page_id='. $securityModel->encryptData($menuItemID) .'">
                                            <div class="card" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="'. $appModuleDescription .'">
                                                <div class="card-body text-center">
                                                    <div class="position-relative overflow-hidden d-inline-block">
                                                        <img src="'. $appLogo .'" alt="app-logo" class="img-fluid mb-2 position-relative" width="80" height="80">
                                                    </div>
                                                    <h5 class="fw-semibold fs-6 mb-0 text-dark">'. $appModuleName .'</h5>
                                                    <span class="badge text-bg-danger fs-1 position-absolute top-0 end-0 d-flex align-items-center justify-content-center me-3 mt-3">'. $appVersion .'</span>
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
        require_once('./components/global/view/_error_modal.php');
        require_once('./components/global/view/_global_js.php');
    ?>
    <script src="./components/authentication/js/index.js?v=<?php echo rand(); ?>"></script>
</body>

</html>