<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../booking/model/booking-model.php';
require_once '../../employee/model/employee-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$bookingModel = new BookingModel($databaseModel);
$employeeModel = new EmployeeModel($databaseModel);
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
        # Type: booking table
        # Description:
        # Generates the booking table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'booking table':
            $filterByService = isset($_POST['filter_by_service']) ? $_POST['filter_by_service'] : null;
            $filterByBookingStatus = isset($_POST['filter_by_booking_status']) ? $_POST['filter_by_booking_status'] : null;
            $filterByPaymentStatus = isset($_POST['filter_by_payment_status']) ? $_POST['filter_by_payment_status'] : null;
            $filterByModeOfPayment = isset($_POST['filter_by_mode_of_payment']) ? $_POST['filter_by_mode_of_payment'] : null;
            $filterBySourceOfBooking = isset($_POST['filter_by_source_of_booking']) ? $_POST['filter_by_source_of_booking'] : null;
            $bookingStartDate = $systemModel->checkDate('empty', $_POST['booking_start_date'], '', 'Y-m-d', '');
            $bookingEndDate = $systemModel->checkDate('empty', $_POST['booking_end_date'], '', 'Y-m-d', '');
            $paymentStartDate = $systemModel->checkDate('empty', $_POST['payment_start_date'], '', 'Y-m-d', '');
            $paymentEndDate = $systemModel->checkDate('empty', $_POST['payment_end_date'], '', 'Y-m-d', '');
            $transactionStartDate = $systemModel->checkDate('empty', $_POST['transaction_start_date'], '', 'Y-m-d', '');
            $transactionEndDate = $systemModel->checkDate('empty', $_POST['transaction_end_date'], '', 'Y-m-d', '');

            $sql = $databaseModel->getConnection()->prepare('CALL generateBookingTable(:filterByService, :filterByBookingStatus, :filterByPaymentStatus, :filterByModeOfPayment, :filterBySourceOfBooking, :bookingStartDate, :bookingEndDate, :paymentStartDate, :paymentEndDate, :transactionStartDate, :transactionEndDate)');
            $sql->bindValue(':filterByService', $filterByService, PDO::PARAM_STR);
            $sql->bindValue(':filterByBookingStatus', $filterByBookingStatus, PDO::PARAM_STR);
            $sql->bindValue(':filterByPaymentStatus', $filterByPaymentStatus, PDO::PARAM_STR);
            $sql->bindValue(':filterByModeOfPayment', $filterByModeOfPayment, PDO::PARAM_STR);
            $sql->bindValue(':filterBySourceOfBooking', $filterBySourceOfBooking, PDO::PARAM_STR);
            $sql->bindValue(':bookingStartDate', $bookingStartDate, PDO::PARAM_STR);
            $sql->bindValue(':bookingEndDate', $bookingEndDate, PDO::PARAM_STR);
            $sql->bindValue(':paymentStartDate', $paymentStartDate, PDO::PARAM_STR);
            $sql->bindValue(':paymentEndDate', $paymentEndDate, PDO::PARAM_STR);
            $sql->bindValue(':transactionStartDate', $transactionStartDate, PDO::PARAM_STR);
            $sql->bindValue(':transactionEndDate', $transactionEndDate, PDO::PARAM_STR);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $bookingDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $bookingID = $row['booking_id'];
                $bookingReferenceNumber = $row['booking_reference_number'];
                $firstName = $row['first_name'];
                $lastName = $row['last_name'];
                $phone = $row['phone'];
                $emailAddress = $row['email_address'];
                $sourceOfBooking = $row['source_of_booking'];
                $service = $row['service'];
                $bookingDate =  $systemModel->checkDate('summary', $row['booking_date'], '', 'M d, Y', '');
                $bookingTime = $row['booking_time'];
                $paymentStatus = $row['payment_status'];
                $bookingStatus = $row['booking_status'];

                $bookingStatusBadgeClasses = [
                    'Pending' => 'text-bg-info',
                    'In-Progress' => 'text-bg-warning',
                    'Completed' => 'text-bg-success',
                    'For Cancellation' => 'text-bg-warning',
                    'Rejected' => 'text-bg-danger',
                    'Cancelled' => 'text-bg-danger'
                ];

                $paymentStatusBadgeClasses = [
                    'Pending' => 'text-bg-info',
                    'Paid' => 'text-bg-success',
                    'For Refund' => 'text-bg-warning',
                    'Rejected' => 'text-bg-danger',
                    'Refunded' => 'text-bg-danger'
                ];
                    
                $bookingStatusBadge = '<span class="badge rounded-pill ' . ($bookingStatusBadgeClasses[$bookingStatus] ?? 'text-bg-dark') . '">' . $bookingStatus . '</span>';
                $paymentStatusBadge = '<span class="badge rounded-pill ' . ($paymentStatusBadgeClasses[$paymentStatus] ?? 'text-bg-dark') . '">' . $paymentStatus . '</span>';

                $bookingIDEncrypted = $securityModel->encryptData($bookingID);

                $deleteButton = '';
                if($bookingDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-booking" data-booking-id="' . $bookingID . '" title="Delete Booking">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $bookingID .'">',
                    'BOOKING_REFERENCE_NUMBER' => $bookingReferenceNumber,
                    'CLIENT' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $firstName . ' ' . $lastName .'</h6>
                                                        <p>'. $emailAddress .'</p>
                                                        <p>'. $phone .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'SERVICE' => $service,
                    'BOOKING_SCHEDULE' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $bookingDate .'</h6>
                                                        <p>'. $bookingTime .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'PAYMENT_STATUS' => $paymentStatusBadge,
                    'BOOKING_STATUS' => $bookingStatusBadge,
                    'SOURCE_OF_BOOKING' => $sourceOfBooking,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $bookingIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: booking cancellation approval table
        # Description:
        # Generates the booking cancellation approval table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'booking cancellation approval table':
            $filterByService = isset($_POST['filter_by_service']) ? $_POST['filter_by_service'] : null;
            $filterByPaymentStatus = isset($_POST['filter_by_payment_status']) ? $_POST['filter_by_payment_status'] : null;
            $filterByModeOfPayment = isset($_POST['filter_by_mode_of_payment']) ? $_POST['filter_by_mode_of_payment'] : null;
            $filterBySourceOfBooking = isset($_POST['filter_by_source_of_booking']) ? $_POST['filter_by_source_of_booking'] : null;
            $bookingStartDate = $systemModel->checkDate('empty', $_POST['booking_start_date'], '', 'Y-m-d', '');
            $bookingEndDate = $systemModel->checkDate('empty', $_POST['booking_end_date'], '', 'Y-m-d', '');
            $paymentStartDate = $systemModel->checkDate('empty', $_POST['payment_start_date'], '', 'Y-m-d', '');
            $paymentEndDate = $systemModel->checkDate('empty', $_POST['payment_end_date'], '', 'Y-m-d', '');
            $transactionStartDate = $systemModel->checkDate('empty', $_POST['transaction_start_date'], '', 'Y-m-d', '');
            $transactionEndDate = $systemModel->checkDate('empty', $_POST['transaction_end_date'], '', 'Y-m-d', '');

            $sql = $databaseModel->getConnection()->prepare('CALL generateBookingCancellationTable(:filterByService, :filterByPaymentStatus, :filterByModeOfPayment, :filterBySourceOfBooking, :bookingStartDate, :bookingEndDate, :paymentStartDate, :paymentEndDate, :transactionStartDate, :transactionEndDate)');
            $sql->bindValue(':filterByService', $filterByService, PDO::PARAM_STR);
            $sql->bindValue(':filterByPaymentStatus', $filterByPaymentStatus, PDO::PARAM_STR);
            $sql->bindValue(':filterByModeOfPayment', $filterByModeOfPayment, PDO::PARAM_STR);
            $sql->bindValue(':filterBySourceOfBooking', $filterBySourceOfBooking, PDO::PARAM_STR);
            $sql->bindValue(':bookingStartDate', $bookingStartDate, PDO::PARAM_STR);
            $sql->bindValue(':bookingEndDate', $bookingEndDate, PDO::PARAM_STR);
            $sql->bindValue(':paymentStartDate', $paymentStartDate, PDO::PARAM_STR);
            $sql->bindValue(':paymentEndDate', $paymentEndDate, PDO::PARAM_STR);
            $sql->bindValue(':transactionStartDate', $transactionStartDate, PDO::PARAM_STR);
            $sql->bindValue(':transactionEndDate', $transactionEndDate, PDO::PARAM_STR);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $bookingDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $bookingID = $row['booking_id'];
                $bookingReferenceNumber = $row['booking_reference_number'];
                $firstName = $row['first_name'];
                $lastName = $row['last_name'];
                $phone = $row['phone'];
                $emailAddress = $row['email_address'];
                $sourceOfBooking = $row['source_of_booking'];
                $service = $row['service'];
                $bookingDate =  $systemModel->checkDate('summary', $row['booking_date'], '', 'M d, Y', '');
                $bookingTime = $row['booking_time'];
                $paymentStatus = $row['payment_status'];
                $bookingStatus = $row['booking_status'];

                $bookingStatusBadgeClasses = [
                    'Pending' => 'text-bg-info',
                    'In-Progress' => 'text-bg-warning',
                    'Completed' => 'text-bg-success',
                    'For Cancellation' => 'text-bg-warning',
                    'Rejected' => 'text-bg-danger',
                    'Cancelled' => 'text-bg-danger'
                ];

                $paymentStatusBadgeClasses = [
                    'Pending' => 'text-bg-info',
                    'Paid' => 'text-bg-success',
                    'For Refund' => 'text-bg-warning',
                    'Rejected' => 'text-bg-danger',
                    'Refunded' => 'text-bg-danger'
                ];
                    
                $bookingStatusBadge = '<span class="badge rounded-pill ' . ($bookingStatusBadgeClasses[$bookingStatus] ?? 'text-bg-dark') . '">' . $bookingStatus . '</span>';
                $paymentStatusBadge = '<span class="badge rounded-pill ' . ($paymentStatusBadgeClasses[$paymentStatus] ?? 'text-bg-dark') . '">' . $paymentStatus . '</span>';

                $bookingIDEncrypted = $securityModel->encryptData($bookingID);

                $deleteButton = '';
                if($bookingDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-booking" data-booking-id="' . $bookingID . '" title="Delete Booking">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $bookingID .'">',
                    'BOOKING_REFERENCE_NUMBER' => $bookingReferenceNumber,
                    'CLIENT' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $firstName . ' ' . $lastName .'</h6>
                                                        <p>'. $emailAddress .'</p>
                                                        <p>'. $phone .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'SERVICE' => $service,
                    'BOOKING_SCHEDULE' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $bookingDate .'</h6>
                                                        <p>'. $bookingTime .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'PAYMENT_STATUS' => $paymentStatusBadge,
                    'BOOKING_STATUS' => $bookingStatusBadge,
                    'SOURCE_OF_BOOKING' => $sourceOfBooking,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $bookingIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: booking refund approval table
        # Description:
        # Generates the booking refund approval table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'booking refund approval table':
            $filterByService = isset($_POST['filter_by_service']) ? $_POST['filter_by_service'] : null;
            $filterByBookingStatus = isset($_POST['filter_by_booking_status']) ? $_POST['filter_by_booking_status'] : null;
            $filterByModeOfPayment = isset($_POST['filter_by_mode_of_payment']) ? $_POST['filter_by_mode_of_payment'] : null;
            $filterBySourceOfBooking = isset($_POST['filter_by_source_of_booking']) ? $_POST['filter_by_source_of_booking'] : null;
            $bookingStartDate = $systemModel->checkDate('empty', $_POST['booking_start_date'], '', 'Y-m-d', '');
            $bookingEndDate = $systemModel->checkDate('empty', $_POST['booking_end_date'], '', 'Y-m-d', '');
            $paymentStartDate = $systemModel->checkDate('empty', $_POST['payment_start_date'], '', 'Y-m-d', '');
            $paymentEndDate = $systemModel->checkDate('empty', $_POST['payment_end_date'], '', 'Y-m-d', '');
            $transactionStartDate = $systemModel->checkDate('empty', $_POST['transaction_start_date'], '', 'Y-m-d', '');
            $transactionEndDate = $systemModel->checkDate('empty', $_POST['transaction_end_date'], '', 'Y-m-d', '');

            $sql = $databaseModel->getConnection()->prepare('CALL generateBookingRefundTable(:filterByService, :filterByBookingStatus, :filterByModeOfPayment, :filterBySourceOfBooking, :bookingStartDate, :bookingEndDate, :paymentStartDate, :paymentEndDate, :transactionStartDate, :transactionEndDate)');
            $sql->bindValue(':filterByService', $filterByService, PDO::PARAM_STR);
            $sql->bindValue(':filterByBookingStatus', $filterByBookingStatus, PDO::PARAM_STR);
            $sql->bindValue(':filterByModeOfPayment', $filterByModeOfPayment, PDO::PARAM_STR);
            $sql->bindValue(':filterBySourceOfBooking', $filterBySourceOfBooking, PDO::PARAM_STR);
            $sql->bindValue(':bookingStartDate', $bookingStartDate, PDO::PARAM_STR);
            $sql->bindValue(':bookingEndDate', $bookingEndDate, PDO::PARAM_STR);
            $sql->bindValue(':paymentStartDate', $paymentStartDate, PDO::PARAM_STR);
            $sql->bindValue(':paymentEndDate', $paymentEndDate, PDO::PARAM_STR);
            $sql->bindValue(':transactionStartDate', $transactionStartDate, PDO::PARAM_STR);
            $sql->bindValue(':transactionEndDate', $transactionEndDate, PDO::PARAM_STR);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $bookingDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $bookingID = $row['booking_id'];
                $bookingReferenceNumber = $row['booking_reference_number'];
                $firstName = $row['first_name'];
                $lastName = $row['last_name'];
                $phone = $row['phone'];
                $emailAddress = $row['email_address'];
                $sourceOfBooking = $row['source_of_booking'];
                $service = $row['service'];
                $bookingDate =  $systemModel->checkDate('summary', $row['booking_date'], '', 'M d, Y', '');
                $bookingTime = $row['booking_time'];
                $paymentStatus = $row['payment_status'];
                $bookingStatus = $row['booking_status'];

                $bookingStatusBadgeClasses = [
                    'Pending' => 'text-bg-info',
                    'In-Progress' => 'text-bg-warning',
                    'Completed' => 'text-bg-success',
                    'For Cancellation' => 'text-bg-warning',
                    'Rejected' => 'text-bg-danger',
                    'Cancelled' => 'text-bg-danger'
                ];

                $paymentStatusBadgeClasses = [
                    'Pending' => 'text-bg-info',
                    'Paid' => 'text-bg-success',
                    'For Refund' => 'text-bg-warning',
                    'Rejected' => 'text-bg-danger',
                    'Refunded' => 'text-bg-danger'
                ];
                    
                $bookingStatusBadge = '<span class="badge rounded-pill ' . ($bookingStatusBadgeClasses[$bookingStatus] ?? 'text-bg-dark') . '">' . $bookingStatus . '</span>';
                $paymentStatusBadge = '<span class="badge rounded-pill ' . ($paymentStatusBadgeClasses[$paymentStatus] ?? 'text-bg-dark') . '">' . $paymentStatus . '</span>';

                $bookingIDEncrypted = $securityModel->encryptData($bookingID);

                $deleteButton = '';
                if($bookingDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-booking" data-booking-id="' . $bookingID . '" title="Delete Booking">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $bookingID .'">',
                    'BOOKING_REFERENCE_NUMBER' => $bookingReferenceNumber,
                    'CLIENT' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $firstName . ' ' . $lastName .'</h6>
                                                        <p>'. $emailAddress .'</p>
                                                        <p>'. $phone .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'SERVICE' => $service,
                    'BOOKING_SCHEDULE' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $bookingDate .'</h6>
                                                        <p>'. $bookingTime .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'PAYMENT_STATUS' => $paymentStatusBadge,
                    'BOOKING_STATUS' => $bookingStatusBadge,
                    'SOURCE_OF_BOOKING' => $sourceOfBooking,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $bookingIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: booking personnel list
        # Description:
        # Generates the booking personnel list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'booking personnel list':
            $bookingID = isset($_POST['booking_id']) ? htmlspecialchars($_POST['booking_id'], ENT_QUOTES, 'UTF-8') : null;

            $getBookingDetails = $bookingModel->getBooking($bookingID);
            $bookingStatus = $getBookingDetails['booking_status'] ?? null;

            $sql = $databaseModel->getConnection()->prepare('CALL generateBookingPersonnelList(:bookingID)');
            $sql->bindValue(':bookingID', $bookingID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $count = count($options); 
            $sql->closeCursor();

            $list = '';

            if($count > 0){
                foreach ($options as $row) {
                    $bookingPersonnelID = $row['booking_personnel_id'];
                    $employeeID = $row['employee_id'];
                    $jobStartDate = $systemModel->checkDate('empty', $row['job_start_date'], '', 'M d, Y h:i a', '');
                    $jobEndDate = $systemModel->checkDate('empty', $row['job_end_date'], '', 'M d, Y h:i a', '');
                    $assignmentDate = $systemModel->checkDate('empty', $row['created_date'], '', 'M d, Y h:i a', '');

                    $employeeDetails = $employeeModel->getEmployee($employeeID);
                    $employeeImage = $systemModel->checkImage($employeeDetails['employee_image'] ?? null, 'profile');
                    $fullName = $employeeDetails['full_name'] ?? null;
                    $jobPositionName = $employeeDetails['job_position_name'] ?? null;

                    $jobButton = '';
                    $deleteButton = '';

                    if(empty($jobStartDate) && ($bookingStatus == 'Pending' || $bookingStatus == 'In-Progress')){
                        $deleteButton = '<button class="btn btn-danger w-100 unassign-personnel" data-booking-personnel-id="'. $bookingPersonnelID .'">Unassign</button>';
                    }

                    if($bookingStatus == 'Pending' || $bookingStatus == 'In-Progress' || $bookingStatus == 'Completed'){
                        if(empty($jobStartDate) && empty($jobEndDate)){
                            $jobButton = '<button class="btn btn-success mb-3 w-100 start-job" data-booking-personnel-id="'. $bookingPersonnelID .'">Start Job</button>';
                        }

                        if(!empty($jobStartDate) && empty($jobEndDate)){
                            $jobButton = '<button class="btn btn-warning mb-3 w-100 end-job" data-booking-personnel-id="'. $bookingPersonnelID .'">End Job</button>';
                        }
                    }
            
                    $list .= '<div class="col-lg-4">
                            <div class="card">
                                <div class="card-body p-4">
                                    <img src="'. $employeeImage .'" alt="modernize-img" class="img-fluid rounded-circle mb-2" width="60" height="60">
                                    <h4 class="card-title">'. $fullName .'</h4>
                                    <p>'. $jobPositionName .'</p>
                                    <p>Job Start Date: '. $jobStartDate .'</p>
                                    <p>Job End Date: '. $jobEndDate .'</p>
                                    '. $jobButton .'
                                    '. $deleteButton .'
                                </div>
                            </div>
                        </div>';
                }
            }
            else{
                $list = 'No personnel found.';
            }
            

            $response[] = [
                'PERSONNEL_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>