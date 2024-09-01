<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../content-carousel/model/content-carousel-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$contentCarouselModel = new ContentCarouselModel($databaseModel);
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
        # Type: content carousel table
        # Description:
        # Generates the content carousel table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'content carousel table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateContentCarouselTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $contentCarouselDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $contentCarouselID = $row['content_carousel_id'];
                $contentCarouselName = $row['content_carousel_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $contentCarouselIDEncrypted = $securityModel->encryptData($contentCarouselID);

                $deleteButton = '';
                if($contentCarouselDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-content-carousel" data-content-carousel-id="' . $contentCarouselID . '" title="Delete Content Carousel">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $contentCarouselID .'">',
                    'CONTENT_CAROUSEL_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $contentCarouselName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $contentCarouselIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: content carousel item table
        # Description:
        # Generates the content carousel item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'content carousel item table':
            $contentCarouselID = isset($_POST['content_carousel_id']) ? htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateContentCarouselItemTable(:contentCarouselID)');
            $sql->bindValue(':contentCarouselID', $contentCarouselID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $contentCarouselWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $contentCarouselDetails = $contentCarouselModel->getContentCarousel($contentCarouselID, null);
            $publishStatus = $contentCarouselDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $contentCarouselItemID = $row['content_carousel_item_id'];
                $contentCarouselTitle = $row['content_carousel_title'];
                $contentCarouselHeading = $row['content_carousel_heading'];
                $contentCarouselParagraph = $row['content_carousel_paragraph'];
                $callToActionButton1Text = $row['call_to_action_button_1_text'];
                $callToActionButton1Link = $row['call_to_action_button_1_link'];
                $callToActionButton2Text = $row['call_to_action_button_2_text'];
                $callToActionButton2Link = $row['call_to_action_button_2_link'];
                $contentCarouselImage = $row['content_carousel_image'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $contentCarouselWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-content-carousel-item" data-bs-toggle="modal" data-bs-target="#content-carousel-item-modal" data-content-carousel-item-id="' . $contentCarouselItemID . '" title="Edit Content Carousel Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-content-carousel-item" data-content-carousel-item-id="' . $contentCarouselItemID . '" title="Delete Content Carousel Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'CAROUSEL_ITEM' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $contentCarouselTitle .'</h6>
                                                        <p>'. $contentCarouselHeading .'</p>
                                                        <p>'. $contentCarouselParagraph .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'CALL_TO_ACTION_1' => '<a href="'. $callToActionButton1Link .'" target="_blank">'. $callToActionButton1Text .'</a>',
                    'CALL_TO_ACTION_2' => '<a href="'. $callToActionButton2Link .'" target="_blank">'. $callToActionButton2Text .'</a>',
                    'CAROUSEL_IMAGE' => '<a href="'. $contentCarouselImage .'" target="_blank"><img src="'. $contentCarouselImage .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-content-carousel-item-log-notes" data-content-carousel-item-id="' . $contentCarouselItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: content carousel options
        # Description:
        # Generates the content carousel options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'content carousel options':
            $contentCarouselID = isset($_POST['content_carousel_id']) ? htmlspecialchars($_POST['content_carousel_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateContentCarouselOptions(:contentCarouselID)');
            $sql->bindValue(':contentCarouselID', $contentCarouselID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['content_carousel_id'],
                    'text' => $row['content_carousel_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>