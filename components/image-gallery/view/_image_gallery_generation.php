<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../image-gallery/model/image-gallery-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$imageGalleryModel = new ImageGalleryModel($databaseModel);
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
        # Type: image gallery table
        # Description:
        # Generates the image gallery table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'image gallery table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateImageGalleryTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $imageGalleryDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $imageGalleryID = $row['image_gallery_id'];
                $imageGalleryName = $row['image_gallery_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $imageGalleryIDEncrypted = $securityModel->encryptData($imageGalleryID);

                $deleteButton = '';
                if($imageGalleryDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-image-gallery" data-image-gallery-id="' . $imageGalleryID . '" title="Delete Image Gallery">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $imageGalleryID .'">',
                    'IMAGE_GALLERY_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $imageGalleryName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $imageGalleryIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: image gallery item table
        # Description:
        # Generates the image gallery item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'image gallery item table':
            $imageGalleryID = isset($_POST['image_gallery_id']) ? htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateImageGalleryItemTable(:imageGalleryID)');
            $sql->bindValue(':imageGalleryID', $imageGalleryID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $imageGalleryWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $imageGalleryDetails = $imageGalleryModel->getImageGallery($imageGalleryID, null);
            $publishStatus = $imageGalleryDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $imageGalleryItemID = $row['image_gallery_item_id'];
                $imageGalleryTitle = $row['image_gallery_title'];
                $imageGalleryImage = $row['image_gallery_image'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $imageGalleryWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-image-gallery-item" data-bs-toggle="modal" data-bs-target="#image-gallery-item-modal" data-image-gallery-item-id="' . $imageGalleryItemID . '" title="Edit Image Gallery Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-image-gallery-item" data-image-gallery-item-id="' . $imageGalleryItemID . '" title="Delete Image Gallery Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'IMAGE_GALLERY_TITLE' => $imageGalleryTitle,
                    'IMAGE_GALLERY_IMAGE' => '<a href="'. $imageGalleryImage .'" target="_blank"><img src="'. $imageGalleryImage .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-image-gallery-item-log-notes" data-image-gallery-item-id="' . $imageGalleryItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: image gallery options
        # Description:
        # Generates the image gallery options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'image gallery options':
            $imageGalleryID = isset($_POST['image_gallery_id']) ? htmlspecialchars($_POST['image_gallery_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateImageGalleryOptions(:imageGalleryID)');
            $sql->bindValue(':imageGalleryID', $imageGalleryID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['image_gallery_id'],
                    'text' => $row['image_gallery_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>