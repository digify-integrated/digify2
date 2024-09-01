<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../slider/model/slider-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$sliderModel = new SliderModel($databaseModel);
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
        # Type: slider table
        # Description:
        # Generates the slider table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'slider table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateSliderTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $sliderDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $sliderID = $row['slider_id'];
                $sliderName = $row['slider_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $sliderIDEncrypted = $securityModel->encryptData($sliderID);

                $deleteButton = '';
                if($sliderDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-slider" data-slider-id="' . $sliderID . '" title="Delete Slider">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $sliderID .'">',
                    'SLIDER_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $sliderName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $sliderIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: slider item table
        # Description:
        # Generates the slider item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'slider item table':
            $sliderID = isset($_POST['slider_id']) ? htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateSliderItemTable(:sliderID)');
            $sql->bindValue(':sliderID', $sliderID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $sliderWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $sliderDetails = $sliderModel->getSlider($sliderID, null);
            $publishStatus = $sliderDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $sliderItemID = $row['slider_item_id'];
                $sliderTitle = $row['slider_title'];
                $sliderHeading = $row['slider_heading'];
                $sliderParagraph = $row['slider_paragraph'];
                $callToActionButton1Text = $row['call_to_action_button_1_text'];
                $callToActionButton1Link = $row['call_to_action_button_1_link'];
                $callToActionButton2Text = $row['call_to_action_button_2_text'];
                $callToActionButton2Link = $row['call_to_action_button_2_link'];
                $sliderImage = $row['slider_image'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $sliderWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-slider-item" data-bs-toggle="modal" data-bs-target="#slider-item-modal" data-slider-item-id="' . $sliderItemID . '" title="Edit Slider Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-slider-item" data-slider-item-id="' . $sliderItemID . '" title="Delete Slider Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'SLIDER_ITEM' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $sliderTitle .'</h6>
                                                        <p>'. $sliderHeading .'</p>
                                                        <p>'. $sliderParagraph .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'CALL_TO_ACTION_1' => '<a href="'. $callToActionButton1Link .'" target="_blank">'. $callToActionButton1Text .'</a>',
                    'CALL_TO_ACTION_2' => '<a href="'. $callToActionButton2Link .'" target="_blank">'. $callToActionButton2Text .'</a>',
                    'SLIDER_IMAGE' => '<a href="'. $sliderImage .'" target="_blank"><img src="'. $sliderImage .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-slider-item-log-notes" data-slider-item-id="' . $sliderItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: slider options
        # Description:
        # Generates the slider options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'slider options':
            $sliderID = isset($_POST['slider_id']) ? htmlspecialchars($_POST['slider_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateSliderOptions(:sliderID)');
            $sql->bindValue(':sliderID', $sliderID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['slider_id'],
                    'text' => $row['slider_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>