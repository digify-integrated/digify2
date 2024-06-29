<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../work-locations/model/work-locations-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$workLocationsModel = new WorkLocationsModel($databaseModel);
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
        # Type: work locations table
        # Description:
        # Generates the work locations table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'work locations table':
            $filterByCity = isset($_POST['filter_by_city']) ? htmlspecialchars($_POST['filter_by_city'], ENT_QUOTES, 'UTF-8') : null;
            $filterByState = isset($_POST['filter_by_state']) ? htmlspecialchars($_POST['filter_by_state'], ENT_QUOTES, 'UTF-8') : null;
            $filterByCountry = isset($_POST['filter_by_country']) ? htmlspecialchars($_POST['filter_by_country'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateWorkLocationsTable(:filterByCity, :filterByState, :filterByCountry)');
            $sql->bindValue(':filterByCity', $filterByCity, PDO::PARAM_INT);
            $sql->bindValue(':filterByState', $filterByState, PDO::PARAM_INT);
            $sql->bindValue(':filterByCountry', $filterByCountry, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $workLocationsDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $workLocationsID = $row['work_locations_id'];
                $workLocationsName = $row['work_locations_name'];
                $address = $row['address'];
                $cityName = $row['city_name'];
                $stateName = $row['state_name'];
                $countryName = $row['country_name'];

                $workLocationsAddress = $address . ', ' . $cityName . ', ' . $stateName . ', ' . $countryName;

                $workLocationsIDEncrypted = $securityModel->encryptData($workLocationsID);

                $deleteButton = '';
                if($workLocationsDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-work-locations" data-work-locations-id="' . $workLocationsID . '" title="Delete Work Locations">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $workLocationsID .'">',
                    'WORK_LOCATION_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $workLocationsName .'</h6>
                                                        <small>'. $workLocationsAddress .'</small>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>',
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $workLocationsIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: work locations options
        # Description:
        # Generates the work locations options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'work locations options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateWorkLocationsOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['work_locations_id'],
                    'text' => $row['work_locations_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: work locations radio filter
        # Description:
        # Generates the work locations options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'work locations radio filter':
            $sql = $databaseModel->getConnection()->prepare('CALL generateWorkLocationsOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $filterOptions = '<div class="form-check py-2 mb-0">
                            <input class="form-check-input p-2" type="radio" name="filter-work-locations" id="filter-work-locations-all" value="" checked>
                            <label class="form-check-label d-flex align-items-center ps-2" for="filter-work-locations-all">All</label>
                        </div>';

            foreach ($options as $row) {
                $workLocationsID = $row['work_locations_id'];
                $workLocationsName = $row['work_locations_name'];

                $filterOptions .= '<div class="form-check py-2 mb-0">
                                <input class="form-check-input p-2" type="radio" name="filter-work-locations" id="filter-work-locations-'. $workLocationsID .'" value="'. $workLocationsID .'">
                                <label class="form-check-label d-flex align-items-center ps-2" for="filter-work-locations-'. $workLocationsID .'">'. $workLocationsName .'</label>
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