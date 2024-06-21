<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../company/model/company-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$companyModel = new CompanyModel($databaseModel);
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
        # Type: company table
        # Description:
        # Generates the company table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'company table':
            $filterByCity = isset($_POST['filter_by_city']) ? htmlspecialchars($_POST['filter_by_city'], ENT_QUOTES, 'UTF-8') : null;
            $filterByState = isset($_POST['filter_by_state']) ? htmlspecialchars($_POST['filter_by_state'], ENT_QUOTES, 'UTF-8') : null;
            $filterByCountry = isset($_POST['filter_by_country']) ? htmlspecialchars($_POST['filter_by_country'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateCompanyTable(:filterByCity, :filterByState, :filterByCountry)');
            $sql->bindValue(':filterByCity', $filterByCity, PDO::PARAM_INT);
            $sql->bindValue(':filterByState', $filterByState, PDO::PARAM_INT);
            $sql->bindValue(':filterByCountry', $filterByCountry, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $companyDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $companyID = $row['company_id'];
                $companyName = $row['company_name'];
                $address = $row['address'];
                $cityName = $row['city_name'];
                $stateName = $row['state_name'];
                $countryName = $row['country_name'];
                $companyLogo = $systemModel->checkImage($row['company_logo'], 'company logo');

                $companyAddress = $address . ', ' . $cityName . ', ' . $stateName . ', ' . $countryName;

                $companyIDEncrypted = $securityModel->encryptData($companyID);

                $deleteButton = '';
                if($companyDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-company" data-company-id="' . $companyID . '" title="Delete Company">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $companyID .'">',
                    'COMPANY_NAME' => '<div class="d-flex align-items-center">
                                                <img src="'. $companyLogo .'" alt="avatar" class="rounded-circle" width="35" height="35" />
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $companyName .'</h6>
                                                        <small>'. $companyAddress .'</small>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>',
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $companyIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: company options
        # Description:
        # Generates the company options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'company options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateCompanyOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['company_id'],
                    'text' => $row['company_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: company radio filter
        # Description:
        # Generates the company options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'company radio filter':
            $sql = $databaseModel->getConnection()->prepare('CALL generateCompanyOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $filterOptions = '<div class="form-check py-2 mb-0">
                            <input class="form-check-input p-2" type="radio" name="filter-company" id="filter-company-all" value="" checked>
                            <label class="form-check-label d-flex align-items-center ps-2" for="filter-company-all">All</label>
                        </div>';

            foreach ($options as $row) {
                $companyID = $row['company_id'];
                $companyName = $row['company_name'];

                $filterOptions .= '<div class="form-check py-2 mb-0">
                                <input class="form-check-input p-2" type="radio" name="filter-company" id="filter-company-'. $companyID .'" value="'. $companyID .'">
                                <label class="form-check-label d-flex align-items-center ps-2" for="filter-company-'. $companyID .'">'. $companyName .'</label>
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