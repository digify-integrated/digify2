<?php
    require('components/page-title/model/page-title-model.php');

    $pageTitleModel = new PageTitleModel($databaseModel);

    $publishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 28);
    $unpublishWebsiteElement = $globalModel->checkSystemActionAccessRights($userID, 29);

    if(isset($_GET['id'])){
        $pageTitleDetails = $pageTitleModel->getPageTitle($detailID, null);
        $publishStatus = $pageTitleDetails['publish_status'] ?? 'No';
    }
?>
<div class="row">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Page Title</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Page Title</a></li>' : '';

                            if($publishStatus == 'No' && $publishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="publish-page-title">Publish Page Title</button></li>';
                            }

                            if($publishStatus == 'Yes' && $unpublishWebsiteElement['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="unpublish-page-title">Unpublish Page Title</button></li>';
                            }

                            echo $deleteAccess['total'] > 0 && $publishStatus == 'No' ? '<li><button class="dropdown-item" type="button" id="delete-page-title">Delete Page Title</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 && $publishStatus == 'No' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#page-title-modal" id="edit-details">Edit</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Display Name</p>
                        <h6 class="fw-semibold mb-0" id="page_title_name_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Block Style</p>
                        <h6 class="fw-semibold mb-0" id="block_style_name_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Description</p>
                        <h6 class="fw-semibold mb-0" id="description_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Page Title</p>
                        <h6 class="fw-semibold mb-0" id="page_title_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Page Heading</p>
                        <h6 class="fw-semibold mb-0" id="page_heading_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Page Title Image</h5>
            </div>
            <div class="card-body p-4">
                <div class="text-center">
                    <img src="./assets/images/profile/user-1.jpg" alt="" class="mb-2" id="page_title_image_summary" height="150">
                    <p class="mb-0 mt-2">Allowed JPG, JPEG or PNG. Max size of 500kb</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="page-title-modal" class="modal fade" tabindex="-1" aria-labelledby="page-title-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Page Title Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="page-title-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="page_title_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="page_title_name" name="page_title_name" maxlength="100" autocomplete="off">
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
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="page_title">Page Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="page_title" name="page_title" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="page_heading">Page Heading <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="page_heading" name="page_heading" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="page_title_image">Page Title Image</label>
                                <input type="file" class="form-control" id="page_title_image" name="page_title_image">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="description">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="description" name="description" maxlength="500" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="page-title-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<?php require_once('components/global/view/_internal_log_notes.php'); ?>