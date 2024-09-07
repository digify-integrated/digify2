<?php
    require('components/services-box/model/services-box-model.php');

    $servicesBoxModel = new ServicesBoxModel($databaseModel);

    $publishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 28);
    $unpublishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 29);

    if(isset($_GET['id'])){
        $servicesBoxDetails = $servicesBoxModel->getServicesBox($detailID, null);
        $publishStatus = $servicesBoxDetails['publish_status'] ?? 'No';
    }
?>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Services Box</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Services Box</a></li>' : '';

                            if($publishStatus == 'No' && $publishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="publish-services-box">Publish Services Box</button></li>';
                            }

                            if($publishStatus == 'Yes' && $unpublishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="unpublish-services-box">Unpublish Services Box</button></li>';
                            }

                            echo $deleteAccess['total'] > 0 && $publishStatus == 'No' ? '<li><button class="dropdown-item" type="button" id="delete-services-box">Delete Services Box</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 && $publishStatus == 'No' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#services-box-modal" id="edit-details">Edit</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Display Name</p>
                        <h6 class="fw-semibold mb-0" id="services_box_name_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Block Style</p>
                        <h6 class="fw-semibold mb-0" id="block_style_name_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-0">
                        <p class="mb-1 fs-2">Description</p>
                        <h6 class="fw-semibold mb-0" id="description_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Services Box Item</h5>
                <?php
                    echo $writeAccess['total'] > 0 && $publishStatus == 'No' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-success mb-0 px-4" data-bs-toggle="modal" data-bs-target="#services-box-item-modal" id="add-services-box-item">Create</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="services-box-item-table" class="table align-middle text-nowrap w-100 mb-0">
                        <thead class="text-dark">
                            <tr>
                                <th>Services Box Item</th>
                                <th>Call-to-Action Button </th>
                                <th>Image</th>
                                <th>Order Sequence</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="services-box-modal" class="modal fade" tabindex="-1" aria-labelledby="services-box-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Services Box Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="services-box-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="services_box_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="services_box_name" name="services_box_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="block_style_id">Block Style <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="block_style_id" name="block_style_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="description">Description</label>
                                <textarea class="form-control maxlength" id="description" name="description" maxlength="500" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="services-box-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="services-box-item-modal" class="modal fade" tabindex="-1" aria-labelledby="services-box-item-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="services-box-item-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="services-box-item-form" method="post" action="#">
                    <input type="hidden" id="services_box_item_id" name="services_box_item_id">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="services_box_title">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="services_box_title" name="services_box_title" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="services_box_heading">Heading <span class="text-danger">*</span></label>
                            <div class="mb-3">
                            <input type="text" class="form-control maxlength" id="services_box_heading" name="services_box_heading" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="services_box_paragraph">Paragraph <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="services_box_paragraph" name="services_box_paragraph" maxlength="5000" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="call_to_action_button_text">Call-to-Acton Button Text <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="call_to_action_button_text" name="call_to_action_button_text" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="call_to_action_button_link">Call-to-Acton Button Link <span class="text-danger">*</span></label>
                            <div class="mb-3">
                            <input type="text" class="form-control maxlength" id="call_to_action_button_link" name="call_to_action_button_link" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="services_box_image">Services Box Image</label>
                                <input type="file" class="form-control" id="services_box_image" name="services_box_image">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mb-3">
                                <label class="form-label" for="order_sequence">Order Sequence <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_sequence" name="order_sequence" min="1">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="services-box-item-form" class="btn btn-success" id="submit-services-box-item-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<?php require_once('components/global/view/_internal_log_notes.php'); ?>