<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../columns/model/columns-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$contactformModel = new ColumnsModel($databaseModel);
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
        # Type: columns table
        # Description:
        # Generates the columns table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'columns table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateColumnsTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $columnsDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $columnsID = $row['columns_id'];
                $columnsName = $row['columns_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $columnsIDEncrypted = $securityModel->encryptData($columnsID);

                $deleteButton = '';
                if($columnsDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-columns" data-columns-id="' . $columnsID . '" title="Delete Columns">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $columnsID .'">',
                    'CONTACT_FORM_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $columnsName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $columnsIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: columns options
        # Description:
        # Generates the columns options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'columns options':
            $columnsID = isset($_POST['columns_id']) ? htmlspecialchars($_POST['columns_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateColumnsOptions(:columnsID)');
            $sql->bindValue(':columnsID', $columnsID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['columns_id'],
                    'text' => $row['columns_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>