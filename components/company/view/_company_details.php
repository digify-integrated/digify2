<div class="row">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Company</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Company</a></li>' : '';
                            echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-company">Delete Company</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                        <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#company-modal" id="edit-details">Edit</button>
                                                    </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Display Name:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="company_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Legal Name:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="legal_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Address:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="address_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">City:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="city_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Currency:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="currency_name_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Tax ID:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="tax_id_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Phone:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="phone_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Mobile:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="mobile_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Email:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="email_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group row">
                            <label class="form-label col-md-4">Website:</label>
                            <div class="col-md-8">
                                <p class="form-control-static" id="website_summary">--</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Change Company Logo</h5>
            </div>
            <div class="card-body p-4">
                <div class="text-center">
                    <img src="./assets/images/default/default-company-logo.png" alt="" id="company_logo" class="rounded-circle" width="100" height="100">
                    <?php
                        echo $writeAccess['total'] > 0 ? 
                        '<div class="d-flex align-items-center justify-content-center my-4 gap-6">
                            <button class="btn btn-primary" data-bs-toggle="modal" id="update-company-logo" data-bs-target="#company-logo-modal">Upload</button>
                        </div>' : '';
                    ?>
                    <p class="mb-0 mt-2">Allowed JPG, JPEG or PNG. Max size of 500kb</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="company-modal" class="modal fade" tabindex="-1" aria-labelledby="company-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Company Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="company-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="company_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="company_name" name="company_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="legal_name">Legal Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="legal_name" name="legal_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="address">Address <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="address" name="address" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="city_id">City <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="city_id" name="city_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="currency_id">Currency <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="currency_id" name="currency_id" class="select2 form-control"></select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="tax_id">Tax ID</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="tax_id" name="tax_id" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="phone">Phone</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="phone" name="phone" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="mobile">Mobile</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="mobile" name="mobile" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">        
                        <div class="col-lg-6">
                            <label class="form-label" for="email">Email</label>
                            <div class="mb-3">
                                <input type="email" class="form-control maxlength" id="email" name="email" maxlength="500" autocomplete="off">
                            </div>
                        </div>            
                        <div class="col-lg-6">
                            <label class="form-label" for="website">Website</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="website" name="website" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="company-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="company-logo-modal" class="modal fade" tabindex="-1" aria-labelledby="company-logo-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Company Logo</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="company-logo-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <input type="file" class="form-control" id="company_logo" name="company_logo">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="company-logo-form" class="btn btn-success" id="submit-company-logo">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_log_notes.php'); ?>