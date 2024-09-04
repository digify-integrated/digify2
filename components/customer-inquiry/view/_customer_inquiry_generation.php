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
$customerInquiryModel = new CustomerInquiryModel($databaseModel);
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
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerInquiryTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $customerInquiryDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $customerInquiryID = $row['customer_inquiry_id'];
                $customerName = $row['customer_name'];
                $email = $row['email'];
                $phone = $row['phone'];
                $subject = $row['subject'];
                $message = $row['message'];
                $inquiryStatus = $row['inquiry_status'];
                $inquiryDate =  $systemModel->checkDate('summary', $row['created_date'], '', 'M d, Y', '');

                $badgeClasses = [
                    'Pending' => 'text-bg-info',
                    'In-Progress' => 'text-bg-warning',
                    'Resolved' => 'text-bg-success',
                ];
                
                $inquiryStatusBadge = '<span class="badge rounded-pill ' . ($badgeClasses[$inquiryStatus] ?? 'text-bg-dark') . '">' . $inquiryStatus . '</span>';

                $customerInquiryIDEncrypted = $securityModel->encryptData($customerInquiryID);

                $deleteButton = '';
                if($customerInquiryDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-customer-inquiry" data-customer-inquiry-id="' . $customerInquiryID . '" title="Delete Customer Inquiry">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $customerInquiryID .'">',
                    'CUSTOMER' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $customerName .'</h6>
                                                        <p>'. $email .'</p>
                                                        <p>'. $phone .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'MESSAGE' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $subject .'</h6>
                                                        <p>'. $message .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'INQUIRY_DATE' => $inquiryDate,
                    'INQUIRY_STATUS' => $inquiryStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $customerInquiryIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                   '. $deleteButton .'
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>