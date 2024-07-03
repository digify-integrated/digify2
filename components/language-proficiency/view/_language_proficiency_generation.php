<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../language-proficiency/model/language-proficiency-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$languageProficiencyModel = new LanguageProficiencyModel($databaseModel);
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
        # Type: language proficiency table
        # Description:
        # Generates the language proficiency table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'language proficiency table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateLanguageProficiencyTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $languageProficiencyDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $languageProficiencyID = $row['language_proficiency_id'];
                $languageProficiencyName = $row['language_proficiency_name'];
                $languageProficiencyDescription = $row['language_proficiency_description'];

                $languageProficiencyIDEncrypted = $securityModel->encryptData($languageProficiencyID);

                $deleteButton = '';
                if($languageProficiencyDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-language-proficiency" data-language-proficiency-id="' . $languageProficiencyID . '" title="Delete Language Proficiency">
                                    <i class="ti ti-trash fs-5"></i>
                                </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $languageProficiencyID .'">',
                    'LANGUAGE_PROFICIENCY_NAME' => '<div class="ms-3">
                                                        <div class="user-meta-info">
                                                            <h6 class="user-name mb-0">'. $languageProficiencyName .'</h6>
                                                            <small>'. $languageProficiencyDescription .'</small>
                                                        </div>
                                                    </div>',
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="'. $pageLink .'&id='. $languageProficiencyIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: language proficiency options
        # Description:
        # Generates the language proficiency options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'language proficiency options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateLanguageProficiencyOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['language_proficiency_id'],
                    'text' => $row['language_proficiency_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>