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
        # Type: customer address list
        # Description:
        # Generates the customer address list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'customer address list':
            $linkedID = $_SESSION['linked_id'];

            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerAddress(:linkedID)');
            $sql->bindValue(':linkedID', $linkedID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $count = count($options); 
            $sql->closeCursor();

            $list = '';

            if($count > 0){
                $customerWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');
            
                $i = 0;
                $totalIterations = count($options);
            
                foreach ($options as $row) {
                    $customerAddressID = $row['customer_address_id'];
                    $addressTypeName = $row['address_type_name'];
                    $address = $row['address'];
                    $cityName = $row['city_name'];
                    $stateName = $row['state_name'];
                    $countryName = $row['country_name'];
                    $defaultAddress = $row['default_address'];
                    $telephone = $row['telephone'];
                    $mobile = $row['mobile'];
                    $email = $row['email'];
                   
                    $fullAddress = implode(', ', [$address, $cityName, $stateName, $countryName]);
            
                    $badgeClass = $defaultAddress == 'Primary' ? 'bg-success' : 'bg-info';
                    $getDefaultAddress = '<span class="badge ' . $badgeClass . '">' . $defaultAddress . '</span>';
                
                    $updateButton = '';
                    $deleteButton = '';
                    $setDefaultButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-address-details" data-bs-toggle="modal" data-bs-target="#address-modal" data-customer-address-id="' . $customerAddressID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-address-details" data-customer-address-id="' . $customerAddressID . '">Delete</button>';

                        if($defaultAddress != 'Primary'){
                            $setDefaultButton = '<button type="button" class="btn btn-sm btn-outline-success mb-0 set-address-as-default" data-customer-address-id="' . $customerAddressID . '">
                            Set As Default
                            </button>';
                        }
                    }

                    $telephone = !empty($telephone) ? $telephone . '<br/>' : $telephone ?? '';
                    $mobile = !empty($mobile) ? $mobile . '<br/>' : $mobile ?? '';
                    $email = !empty($email) ? $email . '<br/>' : $email ?? '';
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <h6 class="fw-semibold mb-0">'. $addressTypeName .'</h6>
                                        '. $getDefaultAddress .'
                                    </div>
                                </div>
                                <div class="col-lg-12 mt-2 mb-2">
                                    '. $fullAddress .'<br/>
                                    '. $telephone .'
                                    '. $mobile .'
                                    '. $email .'
                                </div>
                                <div class="d-flex gap-2">
                                    '. $updateButton .'
                                    '. $setDefaultButton .'
                                    '. $deleteButton .'
                                </div>
                            </div>';
            
                    $i++;
                }
            }
            else{
                $list = 'No address found.';
            }
            

            $response[] = [
                'ADDRESS_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: employee address list
        # Description:
        # Generates the employee address list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'employee address list':
            $linkedID = $_SESSION['linked_id'];

            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeAddress(:linkedID)');
            $sql->bindValue(':linkedID', $linkedID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $count = count($options); 
            $sql->closeCursor();

            $list = '';

            if($count > 0){
                $employeeWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');
            
                $i = 0;
                $totalIterations = count($options);
            
                foreach ($options as $row) {
                    $employeeAddressID = $row['employee_address_id'];
                    $addressTypeName = $row['address_type_name'];
                    $address = $row['address'];
                    $cityName = $row['city_name'];
                    $stateName = $row['state_name'];
                    $countryName = $row['country_name'];
                    $defaultAddress = $row['default_address'];
                    $telephone = $row['telephone'];
                    $mobile = $row['mobile'];
                    $email = $row['email'];
                   
                    $fullAddress = implode(', ', [$address, $cityName, $stateName, $countryName]);
            
                    $badgeClass = $defaultAddress == 'Primary' ? 'bg-success' : 'bg-info';
                    $getDefaultAddress = '<span class="badge ' . $badgeClass . '">' . $defaultAddress . '</span>';
                
                    $updateButton = '';
                    $deleteButton = '';
                    $setDefaultButton = '';
                    if($employeeWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-address-details" data-bs-toggle="modal" data-bs-target="#address-modal" data-employee-address-id="' . $employeeAddressID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-address-details" data-employee-address-id="' . $employeeAddressID . '">Delete</button>';

                        if($defaultAddress != 'Primary'){
                            $setDefaultButton = '<button type="button" class="btn btn-sm btn-outline-success mb-0 set-address-as-default" data-employee-address-id="' . $employeeAddressID . '">
                            Set As Default
                            </button>';
                        }
                    }

                    $telephone = !empty($telephone) ? $telephone . '<br/>' : $telephone ?? '';
                    $mobile = !empty($mobile) ? $mobile . '<br/>' : $mobile ?? '';
                    $email = !empty($email) ? $email . '<br/>' : $email ?? '';
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <h6 class="fw-semibold mb-0">'. $addressTypeName .'</h6>
                                        '. $getDefaultAddress .'
                                    </div>
                                </div>
                                <div class="col-lg-12 mt-2 mb-2">
                                    '. $fullAddress .'<br/>
                                    '. $telephone .'
                                    '. $mobile .'
                                    '. $email .'
                                </div>
                                <div class="d-flex gap-2">
                                    '. $updateButton .'
                                    '. $setDefaultButton .'
                                    '. $deleteButton .'
                                </div>
                            </div>';
            
                    $i++;
                }
            }
            else{
                $list = 'No address found.';
            }
            

            $response[] = [
                'ADDRESS_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: all user account options
        # Description:
        # Generates the active user account options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'all user account options':
            $generationType = 'All';
            $sql = $databaseModel->getConnection()->prepare('CALL generateUserAccountOptions(:generationType)');
            $sql->bindValue(':generationType', $generationType, PDO::PARAM_STR);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '0',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['user_account_id'],
                    'text' => $row['file_as']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: active user account options
        # Description:
        # Generates the active user account options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'active user account options':
            $generationType = 'Active';
            $sql = $databaseModel->getConnection()->prepare('CALL generateUserAccountOptions(:generationType)');
            $sql->bindValue(':generationType', $generationType, PDO::PARAM_STR);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '0',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['user_account_id'],
                    'text' => $row['file_as']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: inactive user account options
        # Description:
        # Generates the inactive user account options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'inactive user account options':
            $generationType = 'Deactivated';
            $sql = $databaseModel->getConnection()->prepare('CALL generateUserAccountOptions(:generationType)');
            $sql->bindValue(':generationType', $generationType, PDO::PARAM_STR);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '0',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['user_account_id'],
                    'text' => $row['file_as']
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