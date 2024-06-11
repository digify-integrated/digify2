<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../file-type/model/file-type-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$fileTypeModel = new FileTypeModel($databaseModel);
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
        # Type: file type table
        # Description:
        # Generates the file type table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'file type table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateFileTypeTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $fileTypeDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $fileTypeID = $row['file_type_id'];
                $fileTypeName = $row['file_type_name'];

                $fileTypeIDEncrypted = $securityModel->encryptData($fileTypeID);

                $deleteButton = '';
                if($fileTypeDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-file-type" data-file-type-id="' . $fileTypeID . '" title="Delete File Type">
                                    <i class="ti ti-trash fs-5"></i>
                                </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $fileTypeID .'">',
                    'FILE_TYPE_NAME' => $fileTypeName,
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="'. $pageLink .'&id='. $fileTypeIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: file type options
        # Description:
        # Generates the file type options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'file type options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateFileTypeOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['file_type_id'],
                    'text' => $row['file_type_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: file type radio filter
        # Description:
        # Generates the file type options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'file type radio filter':
            $sql = $databaseModel->getConnection()->prepare('CALL generateFileTypeOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $filterOptions = '<div class="form-check py-2 mb-0">
                            <input class="form-check-input p-2" type="radio" name="filter-file-type" id="filter-file-type-all" value="" checked>
                            <label class="form-check-label d-flex align-items-center ps-2" for="filter-file-type-all">All</label>
                        </div>';

            foreach ($options as $row) {
                $fileTypeID = $row['file_type_id'];
                $fileTypeName = $row['file_type_name'];

                $filterOptions .= '<div class="form-check py-2 mb-0">
                                <input class="form-check-input p-2" type="radio" name="filter-file-type" id="filter-file-type-'. $fileTypeID .'" value="'. $fileTypeID .'">
                                <label class="form-check-label d-flex align-items-center ps-2" for="filter-file-type-'. $fileTypeID .'">'. $fileTypeName .'</label>
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