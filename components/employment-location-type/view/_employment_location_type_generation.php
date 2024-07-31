<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../employment-location-type/model/employment-location-type-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$employmentLocationTypeModel = new EmploymentLocationTypeModel($databaseModel);
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
        # Type: employment location type table
        # Description:
        # Generates the employment location type table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'employment location type table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmploymentLocationTypeTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $employmentLocationTypeDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $employmentLocationTypeID = $row['employment_location_type_id'];
                $employmentLocationTypeName = $row['employment_location_type_name'];

                $employmentLocationTypeIDEncrypted = $securityModel->encryptData($employmentLocationTypeID);

                $deleteButton = '';
                if($employmentLocationTypeDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-employment-location-type" data-employment-location-type-id="' . $employmentLocationTypeID . '" title="Delete Employment Location Type">
                                    <i class="ti ti-trash fs-5"></i>
                                </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $employmentLocationTypeID .'">',
                    'EMPLOYMENT_LOCATION_TYPE_NAME' => $employmentLocationTypeName,
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="'. $pageLink .'&id='. $employmentLocationTypeIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: employment location type options
        # Description:
        # Generates the employment location type options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'employment location type options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmploymentLocationTypeOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['employment_location_type_id'],
                    'text' => $row['employment_location_type_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>