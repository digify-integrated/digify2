<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../file-extension/model/file-extension-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$fileExtensionModel = new FileExtensionModel($databaseModel);
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
        # Type: file extension table
        # Description:
        # Generates the file extension table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'file extension table':
            $filterByFileType = isset($_POST['filter_by_file_type']) ? htmlspecialchars($_POST['filter_by_file_type'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateFileExtensionTable(:filterByFileType)');
            $sql->bindValue(':filterByFileType', $filterByFileType, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $fileExtensionDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $fileExtensionID = $row['file_extension_id'];
                $fileExtensionName = $row['file_extension_name'];
                $fileExtension = $row['file_extension'];
                $fileTypeName = $row['file_type_name'];

                $fileExtensionIDEncrypted = $securityModel->encryptData($fileExtensionID);

                $deleteButton = '';
                if($fileExtensionDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-file-extension" data-file-extension-id="' . $fileExtensionID . '" title="Delete File Extension">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $fileExtensionID .'">',
                    'FILE_EXTENSION_NAME' => $fileExtensionName . ' (.' . $fileExtension . ')',
                    'FILE_TYPE_NAME' => $fileTypeName,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $fileExtensionIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: assigned file extension table
        # Description:
        # Generates the assigned file extension table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned file extension table':
            $uploadSettingID = isset($_POST['upload_setting_id']) ? htmlspecialchars($_POST['upload_setting_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateUploadSettingFileExtensionTable(:uploadSettingID)');
            $sql->bindValue(':uploadSettingID', $uploadSettingID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $deleteFileExtensionAccess = $globalModel->checkSystemActionAccessRights($userID, 14);

            foreach ($options as $row) {
                $uploadSettingFileExtensionID = $row['upload_setting_file_extension_id'];
                $fileExtensionName = $row['file_extension_name'];
                $fileExtension = $row['file_extension'];

                $deleteButton = '';
                if($deleteFileExtensionAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-file-extension" data-upload-setting-file-extension-id="' . $uploadSettingFileExtensionID . '" title="Delete File Extension">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'FILE_EXTENSION' => $fileExtensionName . ' (.' . $fileExtension . ')',
                    'ACTION' => '<div class="action-btn">
                                    <a href="javascript:void(0);" class="text-info view-file-extension-log-notes" data-upload-setting-file-extension-id="' . $uploadSettingFileExtensionID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: role file extension dual listbox options
        # Description:
        # Generates the role file extension dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'file extension upload setting dual listbox options':
            if(isset($_POST['upload_setting_id']) && !empty($_POST['upload_setting_id'])){
                $uploadSettingID = htmlspecialchars($_POST['upload_setting_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateFileExtensionDualListBoxOptions(:uploadSettingID)');
                $sql->bindValue(':uploadSettingID', $uploadSettingID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['file_extension_id'],
                        'text' => $row['file_extension_name'] . ' (' . $row['file_extension'] . ')'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>