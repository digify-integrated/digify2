<?php
    require('components/content-carousel/model/content-carousel-model.php');

    $contentCarouselModel = new ContentCarouselModel($databaseModel);

    $publishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 28);
    $unpublishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 29);

    if(isset($_GET['id'])){
        $contentCarouselDetails = $contentCarouselModel->getContentCarousel($detailID, null);
        $publishStatus = $contentCarouselDetails['publish_status'] ?? 'No';
    }
?>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Content Carousel</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Content Carousel</a></li>' : '';

                            if($publishStatus == 'No' && $publishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="publish-content-carousel">Publish Content Carousel</button></li>';
                            }

                            if($publishStatus == 'Yes' && $unpublishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="unpublish-content-carousel">Unpublish Content Carousel</button></li>';
                            }

                            echo $deleteAccess['total'] > 0 && $publishStatus == 'No' ? '<li><button class="dropdown-item" type="button" id="delete-content-carousel">Delete Content Carousel</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 && $publishStatus == 'No' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#content-carousel-modal" id="edit-details">Edit</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Display Name</p>
                        <h6 class="fw-semibold mb-0" id="content_carousel_name_summary">--</h6>
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
                <h5 class="card-title mb-0">Content Carousel Item</h5>
                <?php
                    echo $writeAccess['total'] > 0 && $publishStatus == 'No' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-success mb-0 px-4" data-bs-toggle="modal" data-bs-target="#content-carousel-item-modal" id="add-content-carousel-item">Create</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="content-carousel-item-table" class="table align-middle text-nowrap w-100 mb-0">
                        <thead class="text-dark">
                            <tr>
                                <th>Content Carousel Item</th>
                                <th>Call-to-Action Button 1</th>
                                <th>Call-to-Action Button 2</th>
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

<div id="content-carousel-modal" class="modal fade" tabindex="-1" aria-labelledby="content-carousel-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Content Carousel Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="content-carousel-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="content_carousel_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="content_carousel_name" name="content_carousel_name" maxlength="100" autocomplete="off">
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
                <button type="submit" form="content-carousel-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="content-carousel-item-modal" class="modal fade" tabindex="-1" aria-labelledby="content-carousel-item-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="content-carousel-item-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="content-carousel-item-form" method="post" action="#">
                    <input type="hidden" id="content_carousel_item_id" name="content_carousel_item_id">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="content_carousel_title">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="content_carousel_title" name="content_carousel_title" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="content_carousel_heading">Heading <span class="text-danger">*</span></label>
                            <div class="mb-3">
                            <input type="text" class="form-control maxlength" id="content_carousel_heading" name="content_carousel_heading" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="content_carousel_paragraph">Paragraph <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="content_carousel_paragraph" name="content_carousel_paragraph" maxlength="5000" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="call_to_action_button_1_text">Call-to-Acton Button 1 Text</label>
                                <input type="text" class="form-control maxlength" id="call_to_action_button_1_text" name="call_to_action_button_1_text" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="call_to_action_button_1_link">Call-to-Acton Button 1 Link</label>
                            <div class="mb-3">
                            <input type="text" class="form-control maxlength" id="call_to_action_button_1_link" name="call_to_action_button_1_link" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="call_to_action_button_2_text">Call-to-Acton Button 2 Text</label>
                                <input type="text" class="form-control maxlength" id="call_to_action_button_2_text" name="call_to_action_button_2_text" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="call_to_action_button_2_link">Call-to-Acton Button 2 Link</label>
                            <div class="mb-3">
                            <input type="text" class="form-control maxlength" id="call_to_action_button_2_link" name="call_to_action_button_2_link" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="content_carousel_image">Content Carousel Image</label>
                                <input type="file" class="form-control" id="content_carousel_image" name="content_carousel_image">
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
                <button type="submit" form="content-carousel-item-form" class="btn btn-success" id="submit-content-carousel-item-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<?php require_once('components/global/view/_internal_log_notes.php'); ?>