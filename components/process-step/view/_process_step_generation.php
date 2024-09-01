<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../process-step/model/process-step-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$procesStepModel = new ProcesStepModel($databaseModel);
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
        # Type: process step table
        # Description:
        # Generates the process step table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'process step table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateProcesStepTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $procesStepDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $procesStepID = $row['process_step_id'];
                $procesStepName = $row['process_step_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $procesStepIDEncrypted = $securityModel->encryptData($procesStepID);

                $deleteButton = '';
                if($procesStepDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-process-step" data-process-step-id="' . $procesStepID . '" title="Delete Process Step">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $procesStepID .'">',
                    'PROCESS_STEP_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $procesStepName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $procesStepIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: process step item table
        # Description:
        # Generates the process step item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'process step item table':
            $procesStepID = isset($_POST['process_step_id']) ? htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateProcesStepItemTable(:procesStepID)');
            $sql->bindValue(':procesStepID', $procesStepID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $procesStepWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $procesStepDetails = $procesStepModel->getProcesStep($procesStepID, null);
            $publishStatus = $procesStepDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $procesStepItemID = $row['process_step_item_id'];
                $procesStepTitle = $row['process_step_title'];
                $procesStepHeading = $row['process_step_heading'];
                $processStepLink = $row['process_step_link'];
                $procesStepImage = $row['process_step_image'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $procesStepWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-process-step-item" data-bs-toggle="modal" data-bs-target="#process-step-item-modal" data-process-step-item-id="' . $procesStepItemID . '" title="Edit Process Step Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-process-step-item" data-process-step-item-id="' . $procesStepItemID . '" title="Delete Process Step Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'PROCESS_STEP' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $procesStepTitle .'</h6>
                                                        <p>'. $procesStepHeading .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'PROCESS_STEP_LINK' => '<a href="'. $processStepLink .'" target="_blank">'. $processStepLink .'</a>',
                    'PROCESS_STEP_IMAGE' => '<a href="'. $procesStepImage .'" target="_blank"><img src="'. $procesStepImage .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-process-step-item-log-notes" data-process-step-item-id="' . $procesStepItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                        <i class="ti ti-file-text fs-5"></i>
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
        # Type: process step options
        # Description:
        # Generates the process step options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'process step options':
            $procesStepID = isset($_POST['process_step_id']) ? htmlspecialchars($_POST['process_step_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateProcesStepOptions(:procesStepID)');
            $sql->bindValue(':procesStepID', $procesStepID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['process_step_id'],
                    'text' => $row['process_step_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>