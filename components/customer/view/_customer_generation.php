<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../customer/model/customer-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$customerModel = new CustomerModel($databaseModel);
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
        # Type: customer cards
        # Description:
        # Generates the customer cards.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'customer cards':
            $searchValue = isset($_POST['search_value']) ? $_POST['search_value'] : null;
            $filterByCustomerStatus = isset($_POST['filter_by_customer_status']) ? $_POST['filter_by_customer_status'] : null;
            $filterByGender = isset($_POST['filter_by_gender']) ? $_POST['filter_by_gender'] : null;
            $filterByCivilStatus = isset($_POST['filter_by_civil_status']) ? $_POST['filter_by_civil_status'] : null;
            $limit = isset($_POST['limit']) ? $_POST['limit'] : null;
            $offset = isset($_POST['offset']) ? $_POST['offset'] : null;

            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerCard(:searchValue, :filterByCustomerStatus, :filterByGender, :filterByCivilStatus, :limit, :offset)');
            $sql->bindValue(':searchValue', $searchValue, PDO::PARAM_STR);
            $sql->bindValue(':filterByCustomerStatus', $filterByCustomerStatus, PDO::PARAM_STR);
            $sql->bindValue(':filterByGender', $filterByGender, PDO::PARAM_INT);
            $sql->bindValue(':filterByCivilStatus', $filterByCivilStatus, PDO::PARAM_INT);
            $sql->bindValue(':limit', $limit, PDO::PARAM_INT);
            $sql->bindValue(':offset', $offset, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            foreach ($options as $row) {
                $customerID = $row['customer_id'];
                $fullName = $row['full_name'];
                $employmentStatus = $row['customer_status'];
                $customerImage = $systemModel->checkImage($row['customer_image'] ?? null, 'profile');

                $badgeClass = $employmentStatus == 'Active' ? 'text-bg-success' : 'text-bg-danger';
                $employmentStatusBadge = '<span class="badge ' . $badgeClass . ' fs-2 lh-sm mb-9 me-9 py-1 px-2 fw-semibold position-absolute bottom-0 end-0">' . $employmentStatus . '</span>';

                $customerIDEncrypted = $securityModel->encryptData($customerID);

                $customerCard = '<div class="col-lg-4">
                                    <div class="card overflow-hidden rounded-2 border">
                                        <div class="position-relative">
                                            <a href="'. $pageLink .'&id='. $customerIDEncrypted .'" class="hover-img d-block overflow-hidden">
                                                <img src="'. $customerImage .'" class="card-img-top rounded-0 fixed-height" alt="customer-image">
                                            </a>
                                            '. $employmentStatusBadge .'
                                        </div>
                                        <div class="card-body pt-3 p-4">
                                            <a href="'. $pageLink .'&id='. $customerIDEncrypted .'" class="hover-img d-block overflow-hidden">
                                                <div>
                                                    <h6 class="fw-bold fs-4 text-primary">'. $fullName .'</h6>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>';

                $response[] = [
                    'EMPLOYEE_CARD' => $customerCard
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: customer status options
        # Description:
        # Generates the customer status options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'customer status options':
            $response = [
                [
                    'id' => '',
                    'text' => '--'
                ],
                [
                    'id' => 'Active',
                    'text' => 'Active'
                ],
                [
                    'id' => 'Inactive',
                    'text' => 'Inactive'
                ]
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: experience list
        # Description:
        # Generates the experience list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'experience list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerExperience(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                    $customerExperienceID = $row['customer_experience_id'];
                    $jobTitle = $row['job_title'];
                    $employmentTypeName = $row['employment_type_name'];
                    $companyName = $row['company_name'];
                    $location = $row['location'];
                    $employmentLocationTypeName = $row['employment_location_type_name'];
                    $startMonth = $row['start_month'];
                    $startYear = $row['start_year'];
                    $endMonth = $row['end_month'];
                    $endYear = $row['end_year'];
                    $jobDescription = $row['job_description'];
    
                    $startDateFormatted = date('F', mktime(0, 0, 0, $startMonth, 1));
                    $startDate = $startDateFormatted . ' ' . $startYear;                
    
                    $endDate = (!empty($endMonth) && !empty($endYear)) ? date('F', mktime(0, 0, 0, $endMonth, 1)) . ' ' . $endYear : 'Present';
                    $endDateLapse = ($endDate === 'Present') ? date('F Y') : $endDate;
    
                    $lapsedTime = $systemModel->yearMonthElapsedComparisonString($startDate, $endDateLapse);
                    
                    $employmentTypeName = !empty($employmentTypeName) ? ' · ' . $employmentTypeName : $employmentTypeName;
                    $employmentLocationTypeName = !empty($employmentLocationTypeName) ? ' · ' . $employmentLocationTypeName : $employmentLocationTypeName;
    
                    $updateButton = '';
                    $deleteButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-experience-details" data-bs-toggle="modal" data-bs-target="#experience-modal" data-customer-experience-id="' . $customerExperienceID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-experience-details" data-customer-experience-id="' . $customerExperienceID . '">Delete</button>';
                    }
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                            <div>
                                                <h5 class="fs-4 fw-semibold">'. $jobTitle .'</h5>
                                                <p class="mb-0">'. $companyName . $employmentTypeName .'</p>
                                                <p class="mb-0">'. $startDate .' - '. $endDate .' · '. $lapsedTime .'</p>
                                                <p class="mb-2">'. $location . $employmentLocationTypeName .'</p>
                                            </div>
                                        </div>
                                    </div>
                                    <p class="text-dark text-justify">'. $jobDescription .'</p>
                                    <div class="d-flex gap-2">
                                        '. $updateButton .'
                                        <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-experience-log-notes" data-customer-experience-id="' . $customerExperienceID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                        Log Notes
                                        </button>
                                        '. $deleteButton .'
                                    </div>
                                </div>
                            </div>';
            
                    $i++;
                }
            }
            else{
                $list = 'No experience found.';
            }
            

            $response[] = [
                'EXPERIENCE_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: education list
        # Description:
        # Generates the education list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'education list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerEducation(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                    $customerEducationID = $row['customer_education_id'];
                    $school = $row['school'];
                    $degree = $row['degree'];
                    $fieldOfStudy = $row['field_of_study'];
                    $startMonth = $row['start_month'];
                    $startYear = $row['start_year'];
                    $endMonth = $row['end_month'];
                    $endYear = $row['end_year'];
                    $activitiesSocieties = $row['activities_societies'];
                    $educationDescription = $row['education_description'];

                    $startDateFormatted = date('F', mktime(0, 0, 0, $startMonth, 1));
                    $startDate = $startDateFormatted . ' ' . $startYear;                
    
                    $endDate = (!empty($endMonth) && !empty($endYear)) ? date('F', mktime(0, 0, 0, $endMonth, 1)) . ' ' . $endYear : 'Present';

                    $activitiesSocieties = !empty($activitiesSocieties) ? '<p class="mb-0 text-dark">Activities and societies: ' . $activitiesSocieties . '</p>' : $activitiesSocieties;
                    $educationDescription = !empty($educationDescription) ? '<p class="text-dark text-justify">' . $educationDescription . '</p>' : $educationDescription;

                    $degreeFieldOfStudy = '';
                    if (!empty($degree) && !empty($fieldOfStudy)) {
                        $degreeFieldOfStudy = '<p class="mb-0">' . $degree . ' · ' . $fieldOfStudy . '</p>';
                    } 
                    elseif (!empty($degree)) {
                        $degreeFieldOfStudy = '<p class="mb-0">' . $degree . '</p>';
                    } 
                    elseif (!empty($fieldOfStudy)) {
                        $degreeFieldOfStudy = '<p class="mb-0">' . $fieldOfStudy . '</p>';
                    }
    
                    $updateButton = '';
                    $deleteButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-education-details" data-bs-toggle="modal" data-bs-target="#education-modal" data-customer-education-id="' . $customerEducationID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-education-details" data-customer-education-id="' . $customerEducationID . '">Delete</button>';
                    }
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                            <div>
                                                <h5 class="fs-4 fw-semibold">'. $school .'</h5>
                                                '. $degreeFieldOfStudy .'
                                                <p class="mb-2">'. $startDate .' - '. $endDate .'</p>
                                                '. $activitiesSocieties .'
                                            </div>
                                        </div>
                                    </div>
                                    '. $educationDescription .'
                                    <div class="d-flex gap-2 mt-3">
                                        '. $updateButton .'
                                        <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-education-log-notes" data-customer-education-id="' . $customerEducationID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                        Log Notes
                                        </button>
                                        '. $deleteButton .'
                                    </div>
                                </div>
                            </div>';
                    
                    $i++;
                }
            }
            else{
                $list = 'No education found.';
            }
            

            $response[] = [
                'EDUCATION_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: address list
        # Description:
        # Generates the address list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'address list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerAddress(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-address-log-notes" data-customer-address-id="' . $customerAddressID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                    Log Notes
                                    </button>
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
        # Type: bank account list
        # Description:
        # Generates the bank account list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'bank account list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerBankAccount(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                    $customerBankAccountID = $row['customer_bank_account_id'];
                    $bankName = $row['bank_name'];
                    $bankAccountTypeName = $row['bank_account_type_name'];
                    $accountNumber = $row['account_number'];
                    
                    $updateButton = '';
                    $deleteButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-bank-account-details" data-bs-toggle="modal" data-bs-target="#bank-account-modal" data-customer-bank-account-id="' . $customerBankAccountID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-bank-account-details" data-customer-bank-account-id="' . $customerBankAccountID . '">Delete</button>';
                    }
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                            <div>
                                                <p class="mb-1 fs-2">'. $bankAccountTypeName .'</p>
                                                <h6 class="fw-semibold mb-2">'. $bankName .'</h6>
                                                <p class="mb-1 fs-2">'. $accountNumber .'</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex gap-2 mt-2">
                                    '. $updateButton .'                                 
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-bank-account-log-notes" data-customer-bank-account-id="' . $customerBankAccountID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                    Log Notes
                                    </button>
                                    '. $deleteButton .'
                                </div>
                            </div>';

                    $i++;
                }
            }
            else{
                $list = 'No bank account found.';
            }
            

            $response[] = [
                'BANK_ACCOUNT_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: id record list
        # Description:
        # Generates the id record list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'id record list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerIDRecord(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                    $customerIDRecordID = $row['customer_id_record_id'];
                    $idTypeName = $row['id_type_name'];
                    $idNumber = $row['id_number'];
                    $issuingAuthority = $row['issuing_authority'];
                    $issueDate =  $systemModel->checkDate('summary', $row['issue_date'], '', 'M d, Y', '');
                    $idExpirationDate =  $systemModel->checkDate('summary', $row['expiration_date'], '', 'M d, Y', '');
                    $idImage = $systemModel->checkImage($row['id_image'] ?? null, 'id placeholder front');
    
                    $updateButton = '';
                    $deleteButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-id-record-details" data-bs-toggle="modal" data-bs-target="#id-record-modal" data-customer-id-record-id="' . $customerIDRecordID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-id-record-details" data-customer-id-record-id="' . $customerIDRecordID . '">Delete</button>';
                    }
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <label for="id_image" class="cursor-pointer bg-light w-100 mb-3">
                                        <img src="'. $idImage .'" alt="id-record-img" class="card-img w-100 object-fit-cover cursor-pointer edit-id-record-image-details" data-customer-id-record-id="' . $customerIDRecordID . '" height="100">
                                    </label>
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                           <h6 class="fw-semibold mb-2">'. $idTypeName .'</h6>
                                        </div>
                                    </div>
                                </div>
                                <p class="fs-2 mb-0">ID Number: '. $idNumber .'</p>
                                <p class="fs-2 mb-0">Issued on: '. $issueDate .'</p>
                                <p class="fs-2 mb-0">Expires on: '. $idExpirationDate .'</p>
                                <p class="fs-2 mb-0">Issuing Authority on: '. $issuingAuthority .'</p>
                                <div class="d-flex gap-2 mt-2">
                                    '. $updateButton .'                                 
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-id-record-log-notes" data-customer-id-record-id="' . $customerIDRecordID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                    Log Notes
                                    </button>
                                    '. $deleteButton .'
                                </div>
                            </div>';

                    $i++;
                }
            }
            else{
                $list = 'No ID record found.';
            }
            

            $response[] = [
                'ID_RECORD_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: license list
        # Description:
        # Generates the license list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'license list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerLicense(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                    $customerLicenseID = $row['customer_license_id'];
                    $licensedProfession = $row['licensed_profession'];
                    $licensingBody = $row['licensing_body'];
                    $licenseNumber = $row['license_number'];
                    $issueDate =  $systemModel->checkDate('summary', $row['issue_date'], '', 'M d, Y', '');
                    $idExpirationDate =  $systemModel->checkDate('summary', $row['expiration_date'], '', 'M d, Y', '');
    
                    $updateButton = '';
                    $deleteButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-license-details" data-bs-toggle="modal" data-bs-target="#license-modal" data-customer-license-id="' . $customerLicenseID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-license-details" data-customer-license-id="' . $customerLicenseID . '">Delete</button>';
                    }
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="d-flex align-items-center gap-3">
                                           <h6 class="fw-semibold mb-2">'. $licensedProfession .'</h6>
                                        </div>
                                    </div>
                                </div>
                                <p class="fs-2 mb-0">Licensing Body: '. $licensingBody .'</p>
                                <p class="fs-2 mb-0">License Number: '. $licenseNumber .'</p>
                                <p class="fs-2 mb-0">Issued on: '. $issueDate .'</p>
                                <p class="fs-2 mb-0">Expires on: '. $idExpirationDate .'</p>
                                <div class="d-flex gap-2 mt-2">
                                    '. $updateButton .'                                 
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-license-log-notes" data-customer-license-id="' . $customerLicenseID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                    Log Notes
                                    </button>
                                    '. $deleteButton .'
                                </div>
                            </div>';

                    $i++;
                }
            }
            else{
                $list = 'No license found.';
            }
            

            $response[] = [
                'LICENSE_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: emergency contact list
        # Description:
        # Generates the emergency contact list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'emergency contact list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerEmergencyContact(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                    $customerEmergencyContactID = $row['customer_emergency_contact_id'];
                    $emergencyContactName = $row['emergency_contact_name'];
                    $relationName = $row['relation_name'];
                    $telephone = $row['telephone'];
                    $mobile = $row['mobile'];
                    $email = $row['email'];

                    $updateButton = '';
                    $deleteButton = '';
                    $setDefaultButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-emergency-contact-details" data-bs-toggle="modal" data-bs-target="#emergency-contact-modal" data-customer-emergency-contact-id="' . $customerEmergencyContactID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-emergency-contact-details" data-customer-emergency-contact-id="' . $customerEmergencyContactID . '">Delete</button>';
                    }

                    $telephone = !empty($telephone) ? $telephone . '<br/>' : $telephone ?? '';
                    $mobile = !empty($mobile) ? $mobile . '<br/>' : $mobile ?? '';
                    $email = !empty($email) ? $email . '<br/>' : $email ?? '';
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="fw-semibold mb-1">'. $emergencyContactName .'</h6>
                                            <p class="fs-2">'. $relationName .'</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12 mb-2">
                                    '. $telephone .'
                                    '. $mobile .'
                                    '. $email .'
                                </div>
                                <div class="d-flex gap-2">
                                    '. $updateButton .'                                
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-emergency-contact-log-notes" data-customer-emergency-contact-id="' . $customerEmergencyContactID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                    Log Notes
                                    </button>
                                    '. $deleteButton .'
                                </div>
                            </div>';
            
                    $i++;
                }
            }
            else{
                $list = 'No emergency contact found.';
            }
            

            $response[] = [
                'EMERGENCY_CONTACT_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: language list
        # Description:
        # Generates the language list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'language list':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerLanguage(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
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
                    $customerLanguageID = $row['customer_language_id'];
                    $languageName = $row['language_name'];
                    $languageProficiencyName = $row['language_proficiency_name'];

                    $updateButton = '';
                    $deleteButton = '';
                    $setDefaultButton = '';
                    if($customerWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-language-details" data-bs-toggle="modal" data-bs-target="#language-modal" data-customer-language-id="' . $customerLanguageID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-language-details" data-customer-language-id="' . $customerLanguageID . '">Delete</button>';
                    }

                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div>
                                            <h6 class="fw-semibold mb-1">'. $languageName .'</h6>
                                            <p class="mb-2 fs-2">'. $languageProficiencyName .'</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex gap-2">
                                    '. $updateButton .'                                
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-customer-language-log-notes" data-customer-language-id="' . $customerLanguageID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
                                    Log Notes
                                    </button>
                                    '. $deleteButton .'
                                </div>
                            </div>';
            
                    $i++;
                }
            }
            else{
                $list = 'No language found.';
            }
            

            $response[] = [
                'LANGUAGE_LIST' => $list
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: customer options
        # Description:
        # Generates the customer options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'customer options':
            $customerID = isset($_POST['customer_id']) ? htmlspecialchars($_POST['customer_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCustomerOptions(:customerID)');
            $sql->bindValue(':customerID', $customerID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '0',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['customer_id'],
                    'text' => $row['customer_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>