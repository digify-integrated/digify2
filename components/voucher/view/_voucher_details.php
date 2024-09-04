<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Voucher</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Voucher</a></li>' : '';

                            echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-voucher">Delete Voucher</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#voucher-modal" id="edit-details">Edit</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Display Name</p>
                        <h6 class="fw-semibold mb-0" id="voucher_name_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Voucher Code</p>
                        <h6 class="fw-semibold mb-0 text-uppercase" id="voucher_code_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Voucher Usage Start Date</p>
                        <h6 class="fw-semibold mb-0" id="voucher_usage_start_date_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Voucher Usage End Date</p>
                        <h6 class="fw-semibold mb-0" id="voucher_usage_end_date_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Discount Type</p>
                        <h6 class="fw-semibold mb-0" id="discount_type_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Discount Amount</p>
                        <h6 class="fw-semibold mb-0" id="discount_amount_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Minimum Booking Amount</p>
                        <h6 class="fw-semibold mb-0" id="minimum_booking_amount_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Voucher Quantity</p>
                        <h6 class="fw-semibold mb-0" id="voucher_quantity_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-0">
                        <p class="mb-1 fs-2">Available Voucher</p>
                        <h6 class="fw-semibold mb-0" id="available_voucher_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="voucher-modal" class="modal fade" tabindex="-1" aria-labelledby="voucher-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Voucher Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="voucher-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="voucher_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="voucher_name" name="voucher_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="voucher_code">Voucher Code <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength text-uppercase" id="voucher_code" name="voucher_code" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="voucher_usage_start_date">Voucher Usage Start Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="voucher_usage_start_date" name="voucher_usage_start_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="voucher_usage_end_date">Voucher Usage End Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="voucher_usage_end_date" name="voucher_usage_end_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="discount_type">Discount Type <span class="text-danger">*</span></label>
                                <select id="discount_type" name="discount_type" class="select2 form-control">
                                    <option value="">--</option>
                                    <option value="By Percentage">By Percentage</option>
                                    <option value="Fix Amount">Fix Amount</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="discount_amount">Discount Amount <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="discount_amount" name="discount_amount" min="0.1" value="0" step="0.1">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="minimum_booking_amount">Minimum Booking Amount <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="minimum_booking_amount" name="minimum_booking_amount" min="0" value="0" step="0.1">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="voucher_quantity">Voucher Quantity <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="voucher_quantity" name="voucher_quantity" min="1" value="0" step="1">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="available_voucher">Available Voucer <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="available_voucher" name="available_voucher" min="0" value="0" step="1">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="voucher-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_log_notes.php'); ?>