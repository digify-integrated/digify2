<?php
    if (!isset($_GET['page_id']) || empty($_GET['page_id']) || !isset($_GET['app_module_id']) || empty($_GET['app_module_id'])) {
        header('location: apps.php');
        exit;
    }

    $appModuleID = $securityModel->decryptData($_GET['app_module_id']);
    $pageID = $securityModel->decryptData($_GET['page_id']);
    
    $pageDetails = $menuItemModel->getMenuItem($pageID);
    $pageTitle = $pageDetails['menu_item_name'] ?? null;
    $pageURL = $pageDetails['menu_item_url'] ?? null;
    $pageLink = $pageURL . '?app_module_id=' . $securityModel->encryptData($appModuleID) . '&page_id=' . $securityModel->encryptData($pageID);
    
    $appModuleDetails = $appModuleModel->getAppModule($appModuleID);
    $appModuleName = $appModuleDetails['app_module_name'];
    $appLogo = $systemModel->checkImage($appModuleDetails['app_logo'], 'app module logo');

    $pageAccess = $globalModel->checkAccessRights($userID, $pageID, 'read');

    if ($pageAccess['total'] == 0) {
        header('location: 404.php');
        exit;
    }

    if(isset($_GET['id'])){
        if(empty($_GET['id'])){
            header('location: apps.php');
            exit;
        }
    
        $detailID = $securityModel->decryptData($_GET['id']);
    }
    else{
        $detailID = null;
    }
    
    $newRecord = isset($_GET['new']);
?>