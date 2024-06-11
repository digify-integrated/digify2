<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../menu-group/model/menu-group-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$menuGroupModel = new MenuGroupModel($databaseModel);
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
        # Type: menu group table
        # Description:
        # Generates the menu group table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu group table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateMenuGroupTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $menuGroupDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $menuGroupID = $row['menu_group_id'];
                $menuGroupName = $row['menu_group_name'];
                $orderSequence = $row['order_sequence'];

                $menuGroupIDEncrypted = $securityModel->encryptData($menuGroupID);

                $deleteButton = '';
                if($menuGroupDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-menu-group" data-menu-group-id="' . $menuGroupID . '" title="Delete Menu Group">
                                    <i class="ti ti-trash fs-5"></i>
                                </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $menuGroupID .'">',
                    'MENU_GROUP_NAME' => $menuGroupName,
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="'. $pageLink .'&id='. $menuGroupIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: menu group options
        # Description:
        # Generates the menu group options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu group options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateMenuGroupOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['menu_group_id'],
                    'text' => $row['menu_group_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: menu group radio filter
        # Description:
        # Generates the menu group options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu group radio filter':
            $sql = $databaseModel->getConnection()->prepare('CALL generateMenuGroupOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $filterOptions = '<div class="form-check py-2 mb-0">
                            <input class="form-check-input p-2" type="radio" name="filter-menu-group" id="filter-menu-group-all" value="" checked>
                            <label class="form-check-label d-flex align-items-center ps-2" for="filter-menu-group-all">All</label>
                        </div>';

            foreach ($options as $row) {
                $menuGroupID = $row['menu_group_id'];
                $menuGroupName = $row['menu_group_name'];

                $filterOptions .= '<div class="form-check py-2 mb-0">
                                <input class="form-check-input p-2" type="radio" name="filter-menu-group" id="filter-menu-group-'. $menuGroupID .'" value="'. $menuGroupID .'">
                                <label class="form-check-label d-flex align-items-center ps-2" for="filter-menu-group-'. $menuGroupID .'">'. $menuGroupName .'</label>
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