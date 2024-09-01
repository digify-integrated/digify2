<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../services-box/model/services-box-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$servicesBoxModel = new ServicesBoxModel($databaseModel);
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
        # Type: services box table
        # Description:
        # Generates the services box table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'services box table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateServicesBoxTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $servicesBoxDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $servicesBoxID = $row['services_box_id'];
                $servicesBoxName = $row['services_box_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $servicesBoxIDEncrypted = $securityModel->encryptData($servicesBoxID);

                $deleteButton = '';
                if($servicesBoxDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-services-box" data-services-box-id="' . $servicesBoxID . '" title="Delete Services Box">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $servicesBoxID .'">',
                    'SERVICES_BOX_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $servicesBoxName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $servicesBoxIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: services box item table
        # Description:
        # Generates the services box item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'services box item table':
            $servicesBoxID = isset($_POST['services_box_id']) ? htmlspecialchars($_POST['services_box_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateServicesBoxItemTable(:servicesBoxID)');
            $sql->bindValue(':servicesBoxID', $servicesBoxID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $servicesBoxWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $servicesBoxDetails = $servicesBoxModel->getServicesBox($servicesBoxID, null);
            $publishStatus = $servicesBoxDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $servicesBoxItemID = $row['services_box_item_id'];
                $servicesBoxTitle = $row['services_box_title'];
                $servicesBoxHeading = $row['services_box_heading'];
                $servicesBoxParagraph = $row['services_box_paragraph'];
                $callToActionButtonText = $row['call_to_action_button_text'];
                $callToActionButtonLink = $row['call_to_action_button_link'];
                $servicesBoxImage = $row['services_box_image'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $servicesBoxWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-services-box-item" data-bs-toggle="modal" data-bs-target="#services-box-item-modal" data-services-box-item-id="' . $servicesBoxItemID . '" title="Edit Services Box Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-services-box-item" data-services-box-item-id="' . $servicesBoxItemID . '" title="Delete Services Box Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'SERVICES_BOX' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $servicesBoxTitle .'</h6>
                                                        <p>'. $servicesBoxHeading .'</p>
                                                        <p>'. $servicesBoxParagraph .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'CALL_TO_ACTION' => '<a href="'. $callToActionButtonLink .'" target="_blank">'. $callToActionButtonText .'</a>',
                    'SERVICES_BOX_IMAGE' => '<a href="'. $servicesBoxImage .'" target="_blank"><img src="'. $servicesBoxImage .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-services-box-item-log-notes" data-services-box-item-id="' . $servicesBoxItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: services box options
        # Description:
        # Generates the services box options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'services box options':
            $servicesBoxID = isset($_POST['services_box_id']) ? htmlspecialchars($_POST['services_box_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateServicesBoxOptions(:servicesBoxID)');
            $sql->bindValue(':servicesBoxID', $servicesBoxID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['services_box_id'],
                    'text' => $row['services_box_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>