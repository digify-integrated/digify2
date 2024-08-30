<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../client/model/client-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$clientModel = new ClientModel($databaseModel);
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
        # Type: client table
        # Description:
        # Generates the client table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'client table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateClientTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $clientDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $clientID = $row['client_id'];
                $clientName = $row['client_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $clientIDEncrypted = $securityModel->encryptData($clientID);

                $deleteButton = '';
                if($clientDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-client" data-client-id="' . $clientID . '" title="Delete Client">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $clientID .'">',
                    'CAROUSEL_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $clientName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $clientIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: client item table
        # Description:
        # Generates the client item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'client item table':
            $clientID = isset($_POST['client_id']) ? htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateClientItemTable(:clientID)');
            $sql->bindValue(':clientID', $clientID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $clientWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $clientDetails = $clientModel->getClient($clientID, null);
            $publishStatus = $clientDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $clientItemID = $row['client_item_id'];
                $clientLogo = $row['client_logo'];
                $clientURL = $row['client_url'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $clientWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-client-item" data-bs-toggle="modal" data-bs-target="#client-item-modal" data-client-item-id="' . $clientItemID . '" title="Edit Client Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-client-item" data-client-item-id="' . $clientItemID . '" title="Delete Client Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'CLIENT_LOGO' => '<a href="'. $clientLogo .'" target="_blank"><img src="'. $clientLogo .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'CLIENT_URL' => '<a href="' . $clientURL . '" target="_blank">' . $clientURL . '</a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-client-item-log-notes" data-client-item-id="' . $clientItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: client options
        # Description:
        # Generates the client options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'client options':
            $clientID = isset($_POST['client_id']) ? htmlspecialchars($_POST['client_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateClientOptions(:clientID)');
            $sql->bindValue(':clientID', $clientID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['client_id'],
                    'text' => $row['client_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>