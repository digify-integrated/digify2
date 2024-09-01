<?php
    require('components/image-gallery/model/image-gallery-model.php');

    $imageGalleryModel = new ImageGalleryModel($databaseModel);

    $publishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 28);
    $unpublishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 29);

    if(isset($_GET['id'])){
        $imageGalleryDetails = $imageGalleryModel->getImageGallery($detailID, null);
        $publishStatus = $imageGalleryDetails['publish_status'] ?? 'No';
    }
?>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Image Gallery</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Image Gallery</a></li>' : '';

                            if($publishStatus == 'No' && $publishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="publish-image-gallery">Publish Image Gallery</button></li>';
                            }

                            if($publishStatus == 'Yes' && $unpublishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="unpublish-image-gallery">Unpublish Image Gallery</button></li>';
                            }

                            echo $deleteAccess['total'] > 0 && $publishStatus == 'No' ? '<li><button class="dropdown-item" type="button" id="delete-image-gallery">Delete Image Gallery</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 && $publishStatus == 'No' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#image-gallery-modal" id="edit-details">Edit</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Display Name</p>
                        <h6 class="fw-semibold mb-0" id="image_gallery_name_summary">--</h6>
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
                <h5 class="card-title mb-0">Image Gallery Item</h5>
                <?php
                    echo $writeAccess['total'] > 0 && $publishStatus == 'No' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-success mb-0 px-4" data-bs-toggle="modal" data-bs-target="#image-gallery-item-modal" id="add-image-gallery-item">Create</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="image-gallery-item-table" class="table align-middle text-nowrap w-100 mb-0">
                        <thead class="text-dark">
                            <tr>
                                <th>Image Gallery Item</th>
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

<div id="image-gallery-modal" class="modal fade" tabindex="-1" aria-labelledby="image-gallery-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Image Gallery Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="image-gallery-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="image_gallery_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="image_gallery_name" name="image_gallery_name" maxlength="100" autocomplete="off">
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
                <button type="submit" form="image-gallery-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="image-gallery-item-modal" class="modal fade" tabindex="-1" aria-labelledby="image-gallery-item-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="image-gallery-item-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="image-gallery-item-form" method="post" action="#">
                    <input type="hidden" id="image_gallery_item_id" name="image_gallery_item_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="image_gallery_title">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="image_gallery_title" name="image_gallery_title" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="image_gallery_image">Image Gallery Image</label>
                                <input type="file" class="form-control" id="image_gallery_image" name="image_gallery_image">
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
                <button type="submit" form="image-gallery-item-form" class="btn btn-success" id="submit-image-gallery-item-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<?php require_once('components/global/view/_internal_log_notes.php'); ?>