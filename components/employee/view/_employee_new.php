<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Employee Form</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="employee-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
                <form id="employee-form" method="post" action="#">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="mb-4 row align-items-center">
                                <label for="first_name" class="form-label col-sm-3 col-form-label">First Name <span class="text-danger">*</span></label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="middle_name" class="form-label col-sm-3 col-form-label">Middle Name</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control maxlength" id="middle_name" name="middle_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="mb-4 row align-items-center">
                                <label for="last_name" class="form-label col-sm-3 col-form-label">Last Name <span class="text-danger">*</span></label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="suffix" class="form-label col-sm-3 col-form-label">Suffix</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control maxlength" id="suffix" name="suffix" maxlength="10" autocomplete="off">
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>