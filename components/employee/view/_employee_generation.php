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
        # Type: employee table
        # Description:
        # Generates the employee table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'employee table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateEmployeeTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $employeeDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $employeeID = $row['employee_id'];
                $employeeName = $row['employee_name'];
                $parentEmployeeName = $row['parent_employee_name'];
                $managerName = $row['manager_name'];

                $employeeIDEncrypted = $securityModel->encryptData($employeeID);

                $deleteButton = '';
                if($employeeDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-employee" data-employee-id="' . $employeeID . '" title="Delete Employee">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $employeeID .'">',
                    'DEPARTMENT_NAME' => $employeeName,
                    'MANAGER_NAME' => $managerName,
                    'PARENT_DEPARTMENT_NAME' => $parentEmployeeName,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $employeeIDEncrypted .'" class="text-info" title="View Details">
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
            $searchValue = isset($_POST['search_value']) ? htmlspecialchars($_POST['search_value'], ENT_QUOTES, 'UTF-8') : null;
            $filterByCompany = isset($_POST['filter_by_company']) ? htmlspecialchars($_POST['filter_by_company'], ENT_QUOTES, 'UTF-8') : null;
            $filterByDepartment = isset($_POST['filter_by_department']) ? htmlspecialchars($_POST['filter_by_department'], ENT_QUOTES, 'UTF-8') : null;
            $filterByJobPosition = isset($_POST['filter_by_job_position']) ? htmlspecialchars($_POST['filter_by_job_position'], ENT_QUOTES, 'UTF-8') : null;
            $filterByEmployeeStatus = isset($_POST['filter_by_employee_status']) ? htmlspecialchars($_POST['filter_by_employee_status'], ENT_QUOTES, 'UTF-8') : null;
            $filterByEmploymentType = isset($_POST['filter_by_employment_type']) ? htmlspecialchars($_POST['filter_by_employment_type'], ENT_QUOTES, 'UTF-8') : null;
            $filterByGender = isset($_POST['filter_by_gender']) ? htmlspecialchars($_POST['filter_by_gender'], ENT_QUOTES, 'UTF-8') : null;
            $filterByCivilStatus = isset($_POST['filter_by_civil_status']) ? htmlspecialchars($_POST['filter_by_civil_status'], ENT_QUOTES, 'UTF-8') : null;
            $limit = isset($_POST['limit']) ? htmlspecialchars($_POST['limit'], ENT_QUOTES, 'UTF-8') : null;
            $offset = isset($_POST['offset']) ? htmlspecialchars($_POST['offset'], ENT_QUOTES, 'UTF-8') : null;

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
                                                <h6 class="fw-bold fs-4 text-primary">'. $fullName .'</h6>
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center">
                                                        <span class="fs-2 text-muted">'. $departmentName .'</span>
                                                    </div>
                                                    <div class="d-flex align-items-center">
                                                        <span class="fs-2 text-muted">'. $jobPositionName .'</span>
                                                    </div>
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