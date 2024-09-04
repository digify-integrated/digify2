<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Voucher</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="voucher-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
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
                </form>
            </div>
        </div>
    </div>
</div>