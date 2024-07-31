<div class="row">
    <div class="col-12">
        <div class="card mb-0">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Company Form</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="company-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
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
        </div>
    </div>
</div>