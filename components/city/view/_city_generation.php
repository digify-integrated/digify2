<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../city/model/city-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$cityModel = new CityModel($databaseModel);
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
        # Type: city table
        # Description:
        # Generates the city table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'city table':
            $filterByState = isset($_POST['filter_by_state']) ? htmlspecialchars($_POST['filter_by_state'], ENT_QUOTES, 'UTF-8') : null;
            $filterByCountry = isset($_POST['filter_by_country']) ? htmlspecialchars($_POST['filter_by_country'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCityTable(:filterByState, :filterByCountry)');
            $sql->bindValue(':filterByState', $filterByState, PDO::PARAM_INT);
            $sql->bindValue(':filterByCountry', $filterByCountry, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $cityDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $cityID = $row['city_id'];
                $cityName = $row['city_name'];
                $stateName = $row['state_name'];
                $countryName = $row['country_name'];

                $cityIDEncrypted = $securityModel->encryptData($cityID);

                $deleteButton = '';
                if($cityDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-city" data-city-id="' . $cityID . '" title="Delete City">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $cityID .'">',
                    'CITY_NAME' => $cityName,
                    'STATE_NAME' => $stateName,
                    'COUNTRY_NAME' => $countryName,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $cityIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: city options
        # Description:
        # Generates the city options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'city options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateCityOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['city_id'],
                    'text' => $row['city_name'] . ', ' . $row['state_name'] . ', ' . $row['country_name'] 
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: city radio filter
        # Description:
        # Generates the city options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'city radio filter':
            $sql = $databaseModel->getConnection()->prepare('CALL generateCityOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $filterOptions = '<div class="form-check py-2 mb-0">
                            <input class="form-check-input p-2" type="radio" name="filter-city" id="filter-city-all" value="" checked>
                            <label class="form-check-label d-flex align-items-center ps-2" for="filter-city-all">All</label>
                        </div>';

            foreach ($options as $row) {
                $cityID = $row['city_id'];
                $cityName = $row['city_name'];

                $filterOptions .= '<div class="form-check py-2 mb-0">
                                <input class="form-check-input p-2" type="radio" name="filter-city" id="filter-city-'. $cityID .'" value="'. $cityID .'">
                                <label class="form-check-label d-flex align-items-center ps-2" for="filter-city-'. $cityID .'">'. $cityName .'</label>
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