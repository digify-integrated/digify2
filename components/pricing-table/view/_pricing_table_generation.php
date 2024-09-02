<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../pricing-table/model/pricing-table-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$pricingTableModel = new PricingTableModel($databaseModel);
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
        # Type: pricing table
        # Description:
        # Generates the pricing table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'pricing table':
            $sql = $databaseModel->getConnection()->prepare('CALL generatePricingTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $pricingTableDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $pricingTableID = $row['pricing_table_id'];
                $pricingTableName = $row['pricing_table_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $pricingTableIDEncrypted = $securityModel->encryptData($pricingTableID);

                $deleteButton = '';
                if($pricingTableDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-pricing-table" data-pricing-table-id="' . $pricingTableID . '" title="Delete Pricing Table">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $pricingTableID .'">',
                    'PRICING_TABLE_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $pricingTableName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $pricingTableIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: pricing table options
        # Description:
        # Generates the pricing table options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'pricing table options':
            $pricingTableID = isset($_POST['pricing_table_id']) ? htmlspecialchars($_POST['pricing_table_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generatePricingTableOptions(:pricingTableID)');
            $sql->bindValue(':pricingTableID', $pricingTableID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['pricing_table_id'],
                    'text' => $row['pricing_table_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>