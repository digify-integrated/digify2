<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
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
        # Type: user account table
        # Description:
        # Generates the user account table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'user account table':
            $filterByUserAccountStatus = isset($_POST['filter_by_user_account_status']) ? htmlspecialchars($_POST['filter_by_user_account_status'], ENT_QUOTES, 'UTF-8') : null;
            $filterByUserAccountLockStatus = isset($_POST['filter_by_user_account_lock_status']) ? htmlspecialchars($_POST['filter_by_user_account_lock_status'], ENT_QUOTES, 'UTF-8') : null;
            
            $filterByPasswordExpiryDate = isset($_POST['filter_by_password_expiry_date']) ? explode(' - ', $_POST['filter_by_password_expiry_date']) : null;
            $passwordExpiryStartDate = $systemModel->checkDate('empty', $filterByPasswordExpiryDate[0] ?? null, '', 'Y-m-d', '');
            $passwordExpiryEndDate = $systemModel->checkDate('empty', $filterByPasswordExpiryDate[1] ?? null, '', 'Y-m-d', '');
            
            $filterByLastConnectionDate = isset($_POST['filter_last_connection_date']) ? explode(' - ', $_POST['filter_last_connection_date']) : null;
            $lastConnectionStartDate = $systemModel->checkDate('empty', $filterByLastConnectionDate[0] ?? null, '', 'Y-m-d', '');
            $lastConnectionEndDate = $systemModel->checkDate('empty', $filterByLastConnectionDate[1] ?? null, '', 'Y-m-d', '');

            $sql = $databaseModel->getConnection()->prepare('CALL generateUserAccountTable(:filterByUserAccountStatus, :filterByUserAccountLockStatus, :passwordExpiryStartDate, :passwordExpiryEndDate, :lastConnectionStartDate, :lastConnectionEndDate)');
            $sql->bindValue(':filterByUserAccountStatus', $filterByUserAccountStatus, PDO::PARAM_STR);
            $sql->bindValue(':filterByUserAccountLockStatus', $filterByUserAccountLockStatus, PDO::PARAM_STR);
            $sql->bindValue(':passwordExpiryStartDate', $passwordExpiryStartDate, PDO::PARAM_STR);
            $sql->bindValue(':passwordExpiryEndDate', $passwordExpiryEndDate, PDO::PARAM_STR);
            $sql->bindValue(':lastConnectionStartDate', $lastConnectionStartDate, PDO::PARAM_STR);
            $sql->bindValue(':lastConnectionEndDate', $lastConnectionEndDate, PDO::PARAM_STR);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $userAccountDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $userAccountID = $row['user_account_id'];
                $fileAs = $row['file_as'];
                $email = $row['email'];
                $profilePicture = $systemModel->checkImage($row['profile_picture'], 'profile');
                $locked = $row['locked'];
                $active = $row['active'];
                $lastConnectionDate = empty($row['last_connection_date']) ? 'Never Connected' : $systemModel->checkDate('empty', $row['last_connection_date'], '', 'm/d/Y h:i:s a', '');
                $passwordExpiryDate = $systemModel->checkDate('empty', $row['password_expiry_date'], '', 'm/d/Y', '');

                $userAccountIDEncrypted = $securityModel->encryptData($userAccountID);

                $activeBadge = $active == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Active</span>' : '<span class="badge rounded-pill text-bg-danger">Inactive</span>';
                $lockedBadge = $locked == 'Yes' ? '<span class="badge rounded-pill text-bg-danger">Yes</span>' : '<span class=" badge rounded-pill text-bg-success">No</span>';

                $deleteButton = '';
                if($userAccountDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-user-account" data-user-account-id="' . $userAccountID . '" title="Delete Menu Item">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $userAccountID .'">',
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
                    'USER_ACCOUNT_STATUS' => $activeBadge,
                    'LOCK_STATUS' => $lockedBadge,
                    'PASSWORD_EXPIRY_DATE' => $passwordExpiryDate,
                    'LAST_CONNECTION_DATE' => $lastConnectionDate,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $userAccountIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: role user account dual listbox options
        # Description:
        # Generates the role user account dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'role user account dual listbox options':
            if(isset($_POST['role_id']) && !empty($_POST['role_id'])){
                $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateRoleUserAccountDualListBoxOptions(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['user_account_id'],
                        'text' => $row['file_as']
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>