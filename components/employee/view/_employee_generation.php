<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../employee/model/employee-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
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
        # Type: employee cards
        # Description:
        # Generates the employee cards.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'employee cards':
            $searchValue = isset($_POST['search_value']) ? $_POST['search_value'] : null;
            $filterByCompany = isset($_POST['filter_by_company']) ? $_POST['filter_by_company'] : null;
            $filterByDepartment = isset($_POST['filter_by_department']) ? $_POST['filter_by_department'] : null;
            $filterByJobPosition = isset($_POST['filter_by_job_position']) ? $_POST['filter_by_job_position'] : null;
            $filterByEmployeeStatus = isset($_POST['filter_by_employee_status']) ? $_POST['filter_by_employee_status'] : null;
            $filterByEmploymentType = isset($_POST['filter_by_employment_type']) ? $_POST['filter_by_employment_type'] : null;
            $filterByGender = isset($_POST['filter_by_gender']) ? $_POST['filter_by_gender'] : null;
            $filterByCivilStatus = isset($_POST['filter_by_civil_status']) ? $_POST['filter_by_civil_status'] : null;
            $limit = isset($_POST['limit']) ? $_POST['limit'] : null;
            $offset = isset($_POST['offset']) ? $_POST['offset'] : null;

            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeCard(:searchValue, :filterByCompany, :filterByDepartment, :filterByJobPosition, :filterByEmployeeStatus, :filterByEmploymentType, :filterByGender, :filterByCivilStatus, :limit, :offset)');
            $sql->bindValue(':searchValue', $searchValue, PDO::PARAM_STR);
            $sql->bindValue(':filterByCompany', $filterByCompany, PDO::PARAM_INT);
            $sql->bindValue(':filterByDepartment', $filterByDepartment, PDO::PARAM_INT);
            $sql->bindValue(':filterByJobPosition', $filterByJobPosition, PDO::PARAM_INT);
            $sql->bindValue(':filterByEmployeeStatus', $filterByEmployeeStatus, PDO::PARAM_STR);
            $sql->bindValue(':filterByEmploymentType', $filterByEmploymentType, PDO::PARAM_INT);
            $sql->bindValue(':filterByGender', $filterByGender, PDO::PARAM_INT);
            $sql->bindValue(':filterByCivilStatus', $filterByCivilStatus, PDO::PARAM_INT);
            $sql->bindValue(':limit', $limit, PDO::PARAM_INT);
            $sql->bindValue(':offset', $offset, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            foreach ($options as $row) {
                $employeeID = $row['employee_id'];
                $fullName = $row['full_name'];
                $departmentName = $row['department_name'];
                $jobPositionName = $row['job_position_name'];
                $employmentStatus = $row['employment_status'];
                $employeeImage = $systemModel->checkImage($row['employee_image'] ?? null, 'profile');

                $badgeClass = $employmentStatus == 'Active' ? 'text-bg-success' : 'text-bg-danger';
                $employmentStatusBadge = '<span class="badge ' . $badgeClass . ' fs-2 lh-sm mb-9 me-9 py-1 px-2 fw-semibold position-absolute bottom-0 end-0">' . $employmentStatus . '</span>';

                $employeeIDEncrypted = $securityModel->encryptData($employeeID);

                $employeeCard = '<div class="col-lg-4">
                                    <div class="card overflow-hidden rounded-2 border">
                                        <div class="position-relative">
                                            <a href="'. $pageLink .'&id='. $employeeIDEncrypted .'" class="hover-img d-block overflow-hidden">
                                                <img src="'. $employeeImage .'" class="card-img-top rounded-0 fixed-height" alt="employee-image">
                                            </a>
                                            '. $employmentStatusBadge .'
                                        </div>
                                        <div class="card-body pt-3 p-4">
                                            <a href="'. $pageLink .'&id='. $employeeIDEncrypted .'" class="hover-img d-block overflow-hidden">
                                                <div>
                                                    <h6 class="fw-bold fs-4 text-primary">'. $fullName .'</h6>
                                                    <p class="mb-0 fs-2 text-muted">'. $jobPositionName .'</p>
                                                    <p class="mb-0 fs-2 text-muted">'. $departmentName .'</p>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>';

                $response[] = [
                    'EMPLOYEE_CARD' => $employeeCard
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: employee status options
        # Description:
        # Generates the employee status options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'employee status options':
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
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeExperience(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
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
                    $employeeExperienceID = $row['employee_experience_id'];
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
                    if($employeeWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-experience-details" data-bs-toggle="modal" data-bs-target="#experience-modal" data-employee-experience-id="' . $employeeExperienceID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-experience-details" data-employee-experience-id="' . $employeeExperienceID . '">Delete</button>';
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
                                        <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-employee-experience-log-notes" data-employee-experience-id="' . $employeeExperienceID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
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
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeEducation(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
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
                    $employeeEducationID = $row['employee_education_id'];
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
                    if($employeeWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-education-details" data-bs-toggle="modal" data-bs-target="#education-modal" data-employee-education-id="' . $employeeEducationID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-education-details" data-employee-education-id="' . $employeeEducationID . '">Delete</button>';
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
                                        <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-employee-education-log-notes" data-employee-education-id="' . $employeeEducationID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
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
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeAddress(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
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
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-employee-address-log-notes" data-employee-address-id="' . $employeeAddressID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
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
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeBankAccount(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
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
                    $employeeBankAccountID = $row['employee_bank_account_id'];
                    $bankName = $row['bank_name'];
                    $bankAccountTypeName = $row['bank_account_type_name'];
                    $accountNumber = $row['account_number'];
                    
                    $updateButton = '';
                    $deleteButton = '';
                    if($employeeWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-bank-account-details" data-bs-toggle="modal" data-bs-target="#bank-account-modal" data-employee-bank-account-id="' . $employeeBankAccountID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-bank-account-details" data-employee-bank-account-id="' . $employeeBankAccountID . '">Delete</button>';
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
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-employee-bank-account-log-notes" data-employee-bank-account-id="' . $employeeBankAccountID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
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
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeIDRecord(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
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
                    $employeeIDRecordID = $row['employee_id_record_id'];
                    $idTypeName = $row['id_type_name'];
                    $idNumber = $row['id_number'];
                    $issuingAuthority = $row['issuing_authority'];
                    $issueDate =  $systemModel->checkDate('summary', $row['issue_date'], '', 'M d, Y', '');
                    $idExpirationDate =  $systemModel->checkDate('summary', $row['expiration_date'], '', 'M d, Y', '');
                    $idImage = $systemModel->checkImage($row['id_image'] ?? null, 'id placeholder front');
    
                    $updateButton = '';
                    $deleteButton = '';
                    if($employeeWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-id-record-details" data-bs-toggle="modal" data-bs-target="#id-record-modal" data-employee-id-record-id="' . $employeeIDRecordID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-id-record-details" data-employee-id-record-id="' . $employeeIDRecordID . '">Delete</button>';
                    }
                    
                    $mbClass = ($i < $totalIterations - 1) ? 'mb-3' : 'mb-0';
            
                    $list .= '<div class="row ' . $mbClass . '">
                                <div class="col-md-12">
                                    <label for="id_image" class="cursor-pointer bg-light mb-3">
                                        <img src="'. $idImage .'" alt="id-record-img" class="card-img w-100 object-fit-cover cursor-pointer edit-id-record-image-details" data-employee-id-record-id="' . $employeeIDRecordID . '" height="100">
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
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-employee-id-record-log-notes" data-employee-id-record-id="' . $employeeIDRecordID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
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
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeLicense(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
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
                    $employeeLicenseID = $row['employee_license_id'];
                    $licensedProfession = $row['licensed_profession'];
                    $licensingBody = $row['licensing_body'];
                    $licenseNumber = $row['license_number'];
                    $issueDate =  $systemModel->checkDate('summary', $row['issue_date'], '', 'M d, Y', '');
                    $idExpirationDate =  $systemModel->checkDate('summary', $row['expiration_date'], '', 'M d, Y', '');
    
                    $updateButton = '';
                    $deleteButton = '';
                    if($employeeWriteAccess['total'] > 0){
                        $updateButton = ' <button type="button" class="btn btn-sm btn-outline-info mb-0 edit-license-details" data-bs-toggle="modal" data-bs-target="#license-modal" data-employee-license-id="' . $employeeLicenseID . '">Edit</button>';
                        $deleteButton = ' <button type="button" class="btn btn-sm btn-outline-danger mb-0 delete-license-details" data-employee-license-id="' . $employeeLicenseID . '">Delete</button>';
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
                                    <button type="button" class="btn btn-sm btn-outline-warning mb-0 view-employee-license-log-notes" data-employee-license-id="' . $employeeLicenseID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas">
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
        # Type: employee options
        # Description:
        # Generates the employee options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'employee options':
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeOptions(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '0',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['employee_id'],
                    'text' => $row['employee_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>