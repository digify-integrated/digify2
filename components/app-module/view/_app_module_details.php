<div class="row">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">App Module</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                           echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create App Module</a></li>' : '';
                           echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-app-module">Delete App Module</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#app-module-modal">Edit</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Display Name</p>
                        <h6 class="fw-semibold mb-0" id="app_module_name_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Description</p>
                        <h6 class="fw-semibold mb-0" id="app_module_description_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Default Page</p>
                        <h6 class="fw-semibold mb-0" id="menu_item_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">App Version</p>
                        <h6 class="fw-semibold mb-0" id="app_version_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-0">
                        <p class="mb-1 fs-2">Order Sequence</p>
                        <h6 class="fw-semibold mb-0" id="order_sequence_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">App Logo</h5>
            </div>
            <div class="card-body p-4">
                <div class="text-center">
                    <img src="./assets/images/default/app-module-logo.png" alt="" id="app_module_logo" width="100" height="100">
                    <?php
                        echo $writeAccess['total'] > 0 ? '<div class="d-flex align-items-center justify-content-center my-4 gap-6">
                                                                <button class="btn btn-primary" data-bs-toggle="modal" id="update-app-logo" data-bs-target="#app-logo-modal">Upload</button>
                                                            </div>' : '';
                    ?>
                    <p class="mb-0 mt-2">Allowed JPG, JPEG or PNG. Max size of 500kb</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="app-module-modal" tabindex="-1" aria-labelledby="app-module-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit App Module Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="app-module-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="app_module_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="app_module_name" name="app_module_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="app_module_description">Description <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="app_module_description" name="app_module_description" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="form-label" for="menu_item_id">Default Page <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="menu_item_id" name="menu_item_id" class="select2 form-control"></select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="order_sequence">Order Sequence <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="order_sequence" name="order_sequence" min="0">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="app-module-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="app-logo-modal" class="modal fade" tabindex="-1" aria-labelledby="app-logo-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Update App Logo</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="app-logo-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <input type="file" class="form-control" id="app_logo" name="app_logo">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="app-logo-form" class="btn btn-success" id="submit-app-logo">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_log_notes.php'); ?>