<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../role/model/role-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$roleModel = new RoleModel($databaseModel);
$userAccountModel = new UserAccountModel($databaseModel);
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
        # Type: role table
        # Description:
        # Generates the role table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'role table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateRoleTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $roleDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $roleID = $row['role_id'];
                $roleName = $row['role_name'];
                $roleDescription = $row['role_description'];

                $roleIDEncrypted = $securityModel->encryptData($roleID);
                
                $deleteButton = '';
                if($roleDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-role" data-role-id="' . $roleID . '" title="Delete Role">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $roleID .'">',
                    'ROLE_NAME' => '<div class="ms-3">
                                        <div class="user-meta-info">
                                            <h6 class="user-name mb-0">'. $roleName .'</h6>
                                            <small>'. $roleDescription .'</small>
                                        </div>
                                    </div>',
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="'. $pageLink .'&id='. $roleIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: assigned role user account table
        # Description:
        # Generates the assigned role user account table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned role user account table':
            if(isset($_POST['role_id']) && !empty($_POST['role_id'])){
                $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateRoleUserAccountTable(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                $deleteRoleUserAccount = $globalModel->checkSystemActionAccessRights($userID, 6);

                foreach ($options as $row) {
                    $roleUserAccountID = $row['role_user_account_id'];
                    $userAccountID = $row['user_account_id'];
                    $fileAs = $row['file_as'];

                    $userAccountDetails = $userAccountModel->getUserAccount($userAccountID, null);
                    $email = $userAccountDetails['email'];
                    $profilePicture = $systemModel->checkImage($userAccountDetails['profile_picture'], 'profile');
                    $lastConnectionDate = empty($userAccountDetails['last_connection_date']) ? 'Never Connected' : $systemModel->checkDate('empty', $userAccountDetails['last_connection_date'], '', 'm/d/Y h:i:s a', '');

                    $deleteButton = '';
                    if($deleteRoleUserAccount['total'] > 0){
                        $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-role-user-account" data-role-user-account-id="' . $roleUserAccountID . '" title="Delete User Account">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                    }

                    $response[] = [
                        'USER_ACCOUNT' => '<div class="d-flex align-items-center">
                                                <img src="'. $profilePicture .'" alt="avatar" class="rounded-circle" width="35" height="35" />
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $fileAs .'</h6>
                                                        <small>'. $email .'</small>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>',
                        'LAST_CONNECTION_DATE' => $lastConnectionDate,
                        'ACTION' => '<div class="d-flex gap-2">
                                        <a href="javascript:void(0);" class="text-info view-role-user-account-log-notes" data-role-user-account-id="' . $roleUserAccountID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text fs-5"></i>
                                        </a>
                                        '. $deleteButton .'
                                    </div>'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: assigned role user account list
        # Description:
        # Generates the assigned role user account table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned role user account list':
            if(isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])){
                $table = '';
                $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateUserAccountRoleList(:userAccountID)');
                $sql->bindValue(':userAccountID', $userAccountID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                $deleteRoleUserAccount = $globalModel->checkSystemActionAccessRights($userID, 6);

                foreach ($options as $row) {
                    $roleUserAccountID = $row['role_user_account_id'];
                    $roleName = $row['role_name'];
                    $assignmentDate = $systemModel->checkDate('empty', $row['date_assigned'], '', 'm/d/Y h:i:s a', '');

                    $deleteButton = '';
                    if($deleteRoleUserAccount['total'] > 0){
                        $deleteButton = '<button class="btn bg-danger-subtle text-danger delete-role-user-account" data-role-user-account-id="' . $roleUserAccountID . '">Delete</button>';
                    }

                    $table .= '<div class="d-flex align-items-center justify-content-between pb-3">
                                    <div>
                                        <h5 class="fs-4 fw-semibold mb-0">'. $roleName .'</h5>
                                        <small class="mb-0 mt-1">Date Assigned : '. $assignmentDate .'</small>
                                    </div>
                                    '. $deleteButton .'
                                </div>';
                }

                if(empty($table)){
                    $table = '<div class="d-flex align-items-center text-center justify-content-between pb-0">
                                No user role found
                            </div>';
                }

                $response[] = [
                    'ROLE_USER_ACCOUNT' => $table
                ];

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: assigned menu item permission table
        # Description:
        # Generates the assigned menu item permission table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned menu item permission table':
            if(isset($_POST['role_id']) && !empty($_POST['role_id'])){
                $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateRoleMenuItemPermissionTable(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                $updateRoleAccess = $globalModel->checkSystemActionAccessRights($userID, 8);
                $deleteRoleAccess = $globalModel->checkSystemActionAccessRights($userID, 9);

                foreach ($options as $row) {
                    $rolePermissionID = $row['role_permission_id'];
                    $menuItemName = $row['menu_item_name'];
                    $readAccess = $row['read_access'];
                    $writeAccess = $row['write_access'];
                    $createAccess = $row['create_access'];
                    $deleteAccess = $row['delete_access'];

                    $readAccessChecked = $readAccess ? 'checked' : '';
                    $writeAccessChecked = $writeAccess ? 'checked' : '';
                    $createAccessChecked = $createAccess ? 'checked' : '';
                    $deleteAccessChecked = $deleteAccess ? 'checked' : '';

                    $disabled = '';
                    if($updateRoleAccess['total'] == 0){
                        $disabled = 'disabled';
                    }
                    
                    $deleteButton = '';
                    if($deleteRoleAccess['total'] > 0){
                        $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-role-permission" data-role-permission-id="' . $rolePermissionID . '" title="Delete Role Permission">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                    }

                    $readAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="read" ' . $readAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $writeAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="write" ' . $writeAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $createAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="create" ' . $createAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $deleteAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="delete" ' . $deleteAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $response[] = [
                        'MENU_ITEM' => $menuItemName,
                        'READ_ACCESS' => $readAccessButton,
                        'WRITE_ACCESS' => $writeAccessButton,
                        'CREATE_ACCESS' => $createAccessButton,
                        'DELETE_ACCESS' => $deleteAccessButton,
                        'ACTION' => '<div class="d-flex gap-2">
                                        <a href="javascript:void(0);" class="text-info view-role-permission-log-notes" data-role-permission-id="' . $rolePermissionID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text fs-5"></i>
                                        </a>
                                        '. $deleteButton .'
                                    </div>'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: assigned system action permission table
        # Description:
        # Generates the assigned system action permission table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned system action permission table':
            if(isset($_POST['role_id']) && !empty($_POST['role_id'])){
                $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateRoleSystemActionPermissionTable(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                $updateRoleSystemActionAccess = $globalModel->checkSystemActionAccessRights($userID, 11);
                $deleteRoleSystemActionAccess = $globalModel->checkSystemActionAccessRights($userID, 12);

                foreach ($options as $row) {
                    $roleSystemActionPermissionID = $row['role_system_action_permission_id'];
                    $roleName = $row['system_action_name'];
                    $roleAccess = $row['system_action_access'];

                    $roleAccessChecked = $roleAccess ? 'checked' : '';

                    $disabled = '';
                    if($updateRoleSystemActionAccess['total'] == 0){
                        $disabled = 'disabled';
                    }
                    
                    $deleteButton = '';
                    if($deleteRoleSystemActionAccess['total'] > 0){
                        $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-role-system-action-permission" data-role-system-action-permission-id="' . $roleSystemActionPermissionID . '" title="Delete System Action Permission">
                            <i class="ti ti-trash fs-5"></i>
                        </a>';
                    }

                    $roleAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-system-action-permission" type="checkbox" data-role-system-action-permission-id="' . $roleSystemActionPermissionID . '" ' . $roleAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $response[] = [
                        'SYSTEM_ACTION' => $roleName,
                        'SYSTEM_ACTION_ACCESS' => $roleAccessButton,
                        'ACTION' => '<div class="d-flex gap-2">
                                        <a href="javascript:void(0);" class="text-info view-role-system-action-permission-log-notes" data-role-system-action-permission-id="' . $roleSystemActionPermissionID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text fs-5"></i>
                                        </a>
                                        '. $deleteButton .'
                                    </div>'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: assigned role permission table
        # Description:
        # Generates the assigned role permission table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned role permission table':
            if(isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])){
                $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateMenuItemRolePermissionTable(:menuItemID)');
                $sql->bindValue(':menuItemID', $menuItemID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                $updateRoleAccess = $globalModel->checkSystemActionAccessRights($userID, 8);
                $deleteRoleAccess = $globalModel->checkSystemActionAccessRights($userID, 9);

                foreach ($options as $row) {
                    $rolePermissionID = $row['role_permission_id'];
                    $roleName = $row['role_name'];
                    $readAccess = $row['read_access'];
                    $writeAccess = $row['write_access'];
                    $createAccess = $row['create_access'];
                    $deleteAccess = $row['delete_access'];

                    $readAccessChecked = $readAccess ? 'checked' : '';
                    $writeAccessChecked = $writeAccess ? 'checked' : '';
                    $createAccessChecked = $createAccess ? 'checked' : '';
                    $deleteAccessChecked = $deleteAccess ? 'checked' : '';

                    $disabled = '';
                    if($updateRoleAccess['total'] == 0){
                        $disabled = 'disabled';
                    }
                    
                    $deleteButton = '';
                    if($deleteRoleAccess['total'] > 0){
                        $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-role-permission" data-role-permission-id="' . $rolePermissionID . '" title="Delete Role Permission">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                    }

                    $readAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="read" ' . $readAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $writeAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="write" ' . $writeAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $createAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="create" ' . $createAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $deleteAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="delete" ' . $deleteAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $response[] = [
                        'ROLE' => $roleName,
                        'READ_ACCESS' => $readAccessButton,
                        'WRITE_ACCESS' => $writeAccessButton,
                        'CREATE_ACCESS' => $createAccessButton,
                        'DELETE_ACCESS' => $deleteAccessButton,
                        'ACTION' => '<div class="d-flex gap-2">
                                        <a href="javascript:void(0);" class="text-info view-role-permission-log-notes" data-role-permission-id="' . $rolePermissionID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text fs-5"></i>
                                        </a>
                                        '. $deleteButton .'
                                    </div>'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: assigned role system action permission table
        # Description:
        # Generates the assigned role permission table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned role system action permission table':
            if(isset($_POST['system_action_id']) && !empty($_POST['system_action_id'])){
                $roleID = htmlspecialchars($_POST['system_action_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateSystemActionRolePermissionTable(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                $updateRoleSystemActionAccess = $globalModel->checkSystemActionAccessRights($userID, 11);
                $deleteRoleSystemActionAccess = $globalModel->checkSystemActionAccessRights($userID, 12);

                foreach ($options as $row) {
                    $roleSystemActionPermissionID = $row['role_system_action_permission_id'];
                    $roleName = $row['role_name'];
                    $roleAccess = $row['system_action_access'];

                    $roleAccessChecked = $roleAccess ? 'checked' : '';

                    $disabled = '';
                    if($updateRoleSystemActionAccess['total'] == 0){
                        $disabled = 'disabled';
                    }
                    
                    $deleteButton = '';
                    if($deleteRoleSystemActionAccess['total'] > 0){
                        $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-role-system-action-permission" data-role-system-action-permission-id="' . $roleSystemActionPermissionID . '" title="Delete System Action Permission">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                    }

                    $roleAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-system-action-permission" type="checkbox" data-role-system-action-permission-id="' . $roleSystemActionPermissionID . '" ' . $roleAccessChecked . ' '. $disabled .'>
                                        </div>';

                    $response[] = [
                        'ROLE' => $roleName,
                        'SYSTEM_ACTION_ACCESS' => $roleAccessButton,
                        'ACTION' => '<div class="d-flex gap-2">
                                        <a href="javascript:void(0);" class="text-info view-role-system-action-permission-log-notes" data-role-system-action-permission-id="' . $roleSystemActionPermissionID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text fs-5"></i>
                                        </a>
                                        '. $deleteButton .'
                                    </div>'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: menu item role dual listbox options
        # Description:
        # Generates the menu item role dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu item role dual listbox options':
            if(isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])){
                $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateMenuItemRoleDualListBoxOptions(:menuItemID)');
                $sql->bindValue(':menuItemID', $menuItemID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['role_id'],
                        'text' => $row['role_name']
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: system action role dual listbox options
        # Description:
        # Generates the system action role dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'system action role dual listbox options':
            if(isset($_POST['system_action_id']) && !empty($_POST['system_action_id'])){
                $roleID = htmlspecialchars($_POST['system_action_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateSystemActionRoleDualListBoxOptions(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['role_id'],
                        'text' => $row['role_name']
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: user account role dual listbox options
        # Description:
        # Generates the user account role dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'user account role dual listbox options':
            if(isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])){
                $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateUserAccountRoleDualListBoxOptions(:userAccountID)');
                $sql->bindValue(':userAccountID', $userAccountID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['role_id'],
                        'text' => $row['role_name']
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>