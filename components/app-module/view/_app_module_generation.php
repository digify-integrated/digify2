<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../app-module/model/app-module-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$appModuleModel = new AppModuleModel($databaseModel);
$securityModel = new SecurityModel();
$globalModel = new GlobalModel($databaseModel, $securityModel);

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $pageID = isset($_POST['page_id']) ? $_POST['page_id'] : null;
    $pageLink = isset($_POST['page_link']) ? $_POST['page_link'] : null;
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: app module table
        # Description:
        # Generates the app module table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'app module table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateAppModuleTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $appModuleDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $appModuleID = $row['app_module_id'];
                $appModuleName = $row['app_module_name'];
                $orderSequence = $row['order_sequence'];

                $appModuleIDEncrypted = $securityModel->encryptData($appModuleID);

                $deleteButton = '';
                if($appModuleDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-app-module" data-app-module-id="' . $appModuleID . '" title="Delete Menu Group">
                                    <i class="ti ti-trash fs-5"></i>
                                </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $appModuleID .'">',
                    'APP_MODULE_NAME' => $appModuleName,
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="'. $pageLink .'&id='. $appModuleIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                    '. $deleteButton .'
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: app module options
        # Description:
        # Generates the app module options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'app module options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateAppModuleOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['app_module_id'],
                    'text' => $row['app_module_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: app module radio filter
        # Description:
        # Generates the app module options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'app module radio filter':
            $sql = $databaseModel->getConnection()->prepare('CALL generateAppModuleOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $filterOptions = '<div class="form-check py-2 mb-0">
                            <input class="form-check-input p-2" type="radio" name="filter-app-module" id="filter-app-module-all" value="" checked>
                            <label class="form-check-label d-flex align-items-center ps-2" for="filter-app-module-all">All</label>
                        </div>';

            foreach ($options as $row) {
                $appModuleID = $row['app_module_id'];
                $appModuleName = $row['app_module_name'];

                $filterOptions .= '<div class="form-check py-2 mb-0">
                                <input class="form-check-input p-2" type="radio" name="filter-app-module" id="filter-app-module-'. $appModuleID .'" value="'. $appModuleID .'">
                                <label class="form-check-label d-flex align-items-center ps-2" for="filter-app-module-'. $appModuleID .'">'. $appModuleName .'</label>
                            </div>';
            }

            $response[] = [
                'filterOptions' => $filterOptions
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>