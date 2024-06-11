<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../system-setting/model/system-setting-model.php';
require_once '../../global/model/system-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$systemSettingModel = new SystemSettingModel($databaseModel);
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
        # Type: system setting table
        # Description:
        # Generates the system setting table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'system setting table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateSystemSettingTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $systemSettingDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $systemSettingID = $row['system_setting_id'];
                $systemSettingName = $row['system_setting_name'];
                $description = $row['system_setting_description'];
                $value = $row['value'];

                $systemSettingIDEncrypted = $securityModel->encryptData($systemSettingID);

                $deleteButton = '';
                if($systemSettingDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-system-setting" data-system-setting-id="' . $systemSettingID . '" title="Delete Menu Item">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $systemSettingID .'">',
                    'SYSTEM_SETTING' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $systemSettingName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>',
                    'VALUE' => $value,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $systemSettingIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: system setting options
        # Description:
        # Generates the system setting options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'system setting options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateSystemSettingOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $systemSettingID = $row['system_setting_id'];
                $systemSettingName = $row['system_setting_name'];

                $response[] = [
                    'id' => $row['system_setting_id'],
                    'text' => $row['system_setting_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>