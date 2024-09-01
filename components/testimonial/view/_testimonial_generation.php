<?php
require_once '../../global/config/session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../testimonial/model/testimonial-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$testimonialModel = new TestimonialModel($databaseModel);
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
        # Type: testimonial table
        # Description:
        # Generates the testimonial table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'testimonial table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateTestimonialTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $testimonialDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $testimonialID = $row['testimonial_id'];
                $testimonialName = $row['testimonial_name'];
                $description = $row['description'];
                $publishStatus = $row['publish_status'];

                $publishStatusBadge = $publishStatus == 'Yes' ? '<span class="badge rounded-pill text-bg-success">Yes</span>' : '<span class=" badge rounded-pill text-bg-danger">No</span>';

                $testimonialIDEncrypted = $securityModel->encryptData($testimonialID);

                $deleteButton = '';
                if($testimonialDeleteAccess['total'] > 0 && $publishStatus == 'No'){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-testimonial" data-testimonial-id="' . $testimonialID . '" title="Delete Testimonial">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $testimonialID .'">',
                    'TESTIMONIAL_NAME' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $testimonialName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </div>',
                    'PUBLISH_STATUS' => $publishStatusBadge,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $testimonialIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: testimonial item table
        # Description:
        # Generates the testimonial item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'testimonial item table':
            $testimonialID = isset($_POST['testimonial_id']) ? htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateTestimonialItemTable(:testimonialID)');
            $sql->bindValue(':testimonialID', $testimonialID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $testimonialWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');

            $testimonialDetails = $testimonialModel->getTestimonial($testimonialID, null);
            $publishStatus = $testimonialDetails['publish_status'] ?? 'No';

            foreach ($options as $row) {
                $testimonialItemID = $row['testimonial_item_id'];
                $testimonialTitle = $row['testimonial_title'];
                $testimonialClient = $row['testimonial_client'];
                $testimonialParagraph = $row['testimonial_paragraph'];
                $rating = $row['rating'];
                $testimonialImage = $row['testimonial_image'];
                $orderSequence = $row['order_sequence'];

                $updateButton = '';
                $deleteButton = '';
                if($publishStatus == 'No' && $testimonialWriteAccess['total'] > 0){
                    $updateButton = '<a href="javascript:void(0);" class="text-info ms-3 edit-testimonial-item" data-bs-toggle="modal" data-bs-target="#testimonial-item-modal" data-testimonial-item-id="' . $testimonialItemID . '" title="Edit Testimonial Item">
                                            <i class="ti ti-pencil fs-5"></i>
                                        </a>';
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-testimonial-item" data-testimonial-item-id="' . $testimonialItemID . '" title="Delete Testimonial Item">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>';
                }

                $response[] = [
                    'TESTIMONIAL_ITEM' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $testimonialTitle .'</h6>
                                                        <p>'. $testimonialClient .'</p>
                                                        <p>'. $testimonialParagraph .'</p>
                                                    </div>
                                                </div>
                                            </div>',
                    'RATING' => $rating,
                    'TESTIMONIAL_IMAGE' => '<a href="'. $testimonialImage .'" target="_blank"><img src="'. $testimonialImage .'" alt="modernize-img" class="rounded-1 img-fluid mb-9"></a>',
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="action-btn">
                                    '. $updateButton .'
                                   <a href="javascript:void(0);" class="text-warning ms-3 view-testimonial-item-log-notes" data-testimonial-item-id="' . $testimonialItemID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
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
        # Type: testimonial options
        # Description:
        # Generates the testimonial options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'testimonial options':
            $testimonialID = isset($_POST['testimonial_id']) ? htmlspecialchars($_POST['testimonial_id'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateTestimonialOptions(:testimonialID)');
            $sql->bindValue(':testimonialID', $testimonialID, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $response[] = [
                    'id' => $row['testimonial_id'],
                    'text' => $row['testimonial_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>