<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../work-schedule/model/work-schedule-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$workScheduleModel = new WorkScheduleModel($databaseModel);
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
        # Type: work schedule table
        # Description:
        # Generates the work schedule table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'work schedule table':
            $filterByScheduleType = isset($_POST['filter_by_schedule_type']) ? htmlspecialchars($_POST['filter_by_schedule_type'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateWorkScheduleTable(:filterByScheduleType)');
            $sql->bindValue(':filterByScheduleType', $filterByScheduleType, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $workScheduleDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $workScheduleID = $row['work_schedule_id'];
                $workScheduleName = $row['work_schedule_name'];
                $scheduleTypeName = $row['schedule_type_name'];

                $workScheduleIDEncrypted = $securityModel->encryptData($workScheduleID);

                $deleteButton = '';
                if($workScheduleDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-work-schedule" data-work-schedule-id="' . $workScheduleID . '" title="Delete Work Schedule">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $workScheduleID .'">',
                    'WORK_SCHEDULE_NAME' => $workScheduleName,
                    'SCHEDULE_TYPE' => $scheduleTypeName,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $workScheduleIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: work hours table
        # Description:
        # Generates the work hours table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'work hours table':
            $workScheduleID = isset($_POST['work_schedule_id']) ? htmlspecialchars($_POST['work_schedule_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateWorkHoursTable(:workScheduleID)');
            $sql->bindValue(':workScheduleID', $workScheduleID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $updateWorkHours = $globalModel->checkSystemActionAccessRights($userID, 18);
            $deleteWorkHours = $globalModel->checkSystemActionAccessRights($userID, 19);

            foreach ($options as $row) {
                $workHoursID = $row['work_hours_id'];
                $dayOfWeek = $row['day_of_week'];
                $dayPeriod = $row['day_period'];
                $startTime = $systemModel->checkDate('empty', $row['start_time'], '', 'h:i a', '');
                $endTime = $systemModel->checkDate('empty', $row['end_time'], '', 'h:i a', '');
                $notes = $row['notes'];

                $update = '';
                if($updateWorkHours['total'] > 0){
                    $update = '<button class="btn btn-icon btn-success update-fixed-working-hours" type="button" data-bs-toggle="modal" data-bs-target="#create-work-hours-modal" data-work-hours-id="' . $workHoursID . '">
                            <i class="ti ti-pencil"></i>
                        </button>';
                }


                $deleteButton = '';
                if($deleteWorkHours['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-work-hours" data-work-hours-id="' . $workHoursID . '" title="Delete Work Schedule">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'DAY_OF_WEEK' => $dayOfWeek,
                    'DAY_PERIOD' => $dayPeriod,
                    'START_TIME' => $startTime,
                    'END_TIME' => $endTime,
                    'NOTES' => $notes,
                    'ACTION' => '<div class="action-btn">
                                    <a href="javascript:void(0);" data-work-hours-id="'. $workHoursID .'" data-bs-toggle="modal" data-bs-target="#work-hours-modal" class="text-info update-work-hours" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                    <a href="javascript:void(0);" class="text-warning view-work-hours-log-notes ms-3" data-work-hours-id="' . $workHoursID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                        <i class="ti ti-file-text fs-5"></i>
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
        # Type: work schedule options
        # Description:
        # Generates the work schedule options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'work schedule options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateWorkScheduleOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['work_schedule_id'],
                    'text' => $row['work_schedule_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: work schedule radio filter
        # Description:
        # Generates the work schedule options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'work schedule radio filter':
            $sql = $databaseModel->getConnection()->prepare('CALL generateWorkScheduleOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $filterOptions = '<div class="form-check py-2 mb-0">
                            <input class="form-check-input p-2" type="radio" name="filter-work-schedule" id="filter-work-schedule-all" value="" checked>
                            <label class="form-check-label d-flex align-items-center ps-2" for="filter-work-schedule-all">All</label>
                        </div>';

            foreach ($options as $row) {
                $workScheduleID = $row['work_schedule_id'];
                $workScheduleName = $row['work_schedule_name'];

                $filterOptions .= '<div class="form-check py-2 mb-0">
                                <input class="form-check-input p-2" type="radio" name="filter-work-schedule" id="filter-work-schedule-'. $workScheduleID .'" value="'. $workScheduleID .'">
                                <label class="form-check-label d-flex align-items-center ps-2" for="filter-work-schedule-'. $workScheduleID .'">'. $workScheduleName .'</label>
                            </div>';
            }

            $response[] = [
                'filterOptions' => $filterOptions
            ];

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>