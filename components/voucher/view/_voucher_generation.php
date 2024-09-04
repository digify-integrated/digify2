<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../voucher/model/voucher-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$contactformModel = new VoucherModel($databaseModel);
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
        # Type: voucher table
        # Description:
        # Generates the voucher table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'voucher table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateVoucherTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $voucherDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $voucherID = $row['voucher_id'];
                $voucherName = $row['voucher_name'];
                $voucherCode = $row['voucher_code'];
                $voucherUsageStartDate =  $systemModel->checkDate('summary', $row['voucher_usage_start_date'], '', 'M d, Y', '');
                $voucherUsageEndDate =  $systemModel->checkDate('summary', $row['voucher_usage_end_date'], '', 'M d, Y', '');
                $discountType =  $row['discount_type'];
                $discountAmount =  $row['discount_amount'];
                $minimumBookingAmount =  $row['minimum_booking_amount'];
                $voucherQuantity =  $row['voucher_quantity'];
                $availableVoucher =  $row['available_voucher'];

                $voucherIDEncrypted = $securityModel->encryptData($voucherID);

                $deleteButton = '';
                if($voucherDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-voucher" data-voucher-id="' . $voucherID . '" title="Delete Voucher">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                if($discountType == 'By Percentage'){
                    $discountAmount = number_format($discountAmount, 2) . '%';
                }
                else{
                    $discountAmount = number_format($discountAmount, 2);
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $voucherID .'">',
                    'VOUCHER_NAME' => $voucherName,
                    'VOUCHER_CODE' => strtoupper($voucherCode),
                    'VOUCHER_USAGE_DATE' => $voucherUsageStartDate . ' - ' . $voucherUsageEndDate,
                    'DISCOUNT_TYPE' => $discountType,
                    'DISCOUNT_AMOUNT' => $discountAmount,
                    'MINIMUM_BOOKING_AMOUNT' => number_format($minimumBookingAmount, 2),
                    'AVAILABLE_VOUCHER' => number_format($availableVoucher) . ' / ' . number_format($availableVoucher),
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $voucherIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: voucher options
        # Description:
        # Generates the voucher options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'voucher options':
            $voucherID = isset($_POST['voucher_id']) ? htmlspecialchars($_POST['voucher_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateVoucherOptions(:voucherID)');
            $sql->bindValue(':voucherID', $voucherID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['voucher_id'],
                    'text' => $row['voucher_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>