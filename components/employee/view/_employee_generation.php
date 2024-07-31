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
                $employeeImage = $systemModel->checkImage($row['employee_image'], 'profile');

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
        # Type: expirience list
        # Description:
        # Generates the expirience list.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'expirience list':
            $employeeID = isset($_POST['employee_id']) ? htmlspecialchars($_POST['employee_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeExpirience(:employeeID)');
            $sql->bindValue(':employeeID', $employeeID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $list = '';

            $employeeWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

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

                if ($endDate === 'Present') {
                    $endDate = date('F Y');
                }

                $lapsedTime = $systemModel->yearMonthElapsedComparisonString($startDate, $endDate);
                
                $employmentTypeName = !empty($employmentTypeName) ? ' · ' . $employmentTypeName : $employmentTypeName;
                $employmentLocationTypeName = !empty($employmentLocationTypeName) ? ' · ' . $employmentLocationTypeName : $employmentLocationTypeName;

                $updateButton = '';
                if($employeeWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-dark fs-6 bg-transparent p-2 mb-0" data-bs-toggle="modal" data-bs-target="#experience-modal" id="edit-experience-details" data-employee-experience-id="' . $employeeExperienceID . '">
                                            <i class="ti ti-pencil"></i>
                                        </a>';
                }
                
                $list .= '<div class="row">
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
                                    <div class="d-flex mb-2">
                                        '. $updateButton .'
                                        <a href="javascript:void(0);" class="text-dark fs-6 bg-transparent p-2 mb-0 view-employee-experience-log-notes" data-employee-experience-id="' . $employeeExperienceID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text"></i>
                                        </a>
                                        <a href="javascript:void(0);" class="text-dark fs-6 bg-transparent p-2 mb-0">
                                            <i class="ti ti-trash"></i>
                                        </a>
                                    </div>
                                </div>
                                <p class="text-dark text-justify">'. $jobDescription .'</p>
                            </div>
                        </div>';


                $response[] = [
                    'EXPIRIENCE_LIST' => $list
                ];
            }

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