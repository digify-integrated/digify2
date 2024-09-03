<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../customer-inquiry/model/customer-inquiry-model.php';
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
        # Type: customer inquiry table
        # Description:
        # Generates the customer inquiry table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'customer inquiry table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateServicesBoxTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $servicesBoxDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $servicesBoxID = $row['customer_inquiry_id'];
                $servicesBoxName = $row['customer_inquiry_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $servicesBoxIDEncrypted = $securityModel->encryptData($servicesBoxID);

                $deleteButton = '';
                if($servicesBoxDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-customer-inquiry" data-customer-inquiry-id="' . $servicesBoxID . '" title="Delete Customer Inquiry">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $servicesBoxID .'">',
                    'customer_inquiry_NAME' => '<div class="d-flex align-items-center">
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
        # Type: customer inquiry item table
        # Description:
        # Generates the customer inquiry item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'customer inquiry item table':
            $servicesBoxID = isset($_POST['customer_inquiry_id']) ? htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateServicesBoxItemTable(:servicesBoxID)');
            $sql->bindValue(':servicesBoxID', $servicesBoxID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $servicesBoxWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $servicesBoxDetails = $servicesBoxModel->getServicesBox($servicesBoxID, null);
            $publishStatus = $servicesBoxDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $servicesBoxItemID = $row['customer_inquiry_item_id'];
                $servicesBoxTitle = $row['customer_inquiry_title'];
                $servicesBoxHeading = $row['customer_inquiry_heading'];
                $servicesBoxParagraph = $row['customer_inquiry_paragraph'];
                $callToActionButtonText = $row['call_to_action_button_text'];
                $callToActionButtonLink = $row['call_to_action_button_link'];
                $servicesBoxImage = $row['customer_inquiry_image'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $servicesBoxWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-customer-inquiry-item" data-bs-toggle="modal" data-bs-target="#customer-inquiry-item-modal" data-customer-inquiry-item-id="' . $servicesBoxItemID . '" title="Edit Customer Inquiry Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-customer-inquiry-item" data-customer-inquiry-item-id="' . $servicesBoxItemID . '" title="Delete Customer Inquiry Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'customer_inquiry' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $servicesBoxTitle .'</h6>
                                                        <p>'. $servicesBoxHeading .'</p>
                                                        <p>'. $servicesBoxParagraph .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'CALL_TO_ACTION' => '<a href="'. $callToActionButtonLink .'" target="_blank">'. $callToActionButtonText .'</a>',
                    'customer_inquiry_IMAGE' => '<a href="'. $servicesBoxImage .'" target="_blank"><img src="'. $servicesBoxImage .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-customer-inquiry-item-log-notes" data-customer-inquiry-item-id="' . $servicesBoxItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: customer inquiry options
        # Description:
        # Generates the customer inquiry options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'customer inquiry options':
            $servicesBoxID = isset($_POST['customer_inquiry_id']) ? htmlspecialchars($_POST['customer_inquiry_id'], ENT_QUOTES, 'UTF-8') : null;
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
                    'id' => $row['customer_inquiry_id'],
                    'text' => $row['customer_inquiry_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>