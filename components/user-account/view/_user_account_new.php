<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">User Account Form</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="user-account-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
                <form id="user-account-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="file_as">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="file_as" name="file_as" maxlength="300" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="email">Email Address <span class="text-danger">*</span></label>
                                <input type="email" class="form-control maxlength" id="email" name="email" maxlength="250" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="col-sm-4 form-label" for="file_as">Password <span class="text-danger">*</span></label>
                                <div class="input-group mb-3">
                                    <input type="password" class="form-control" id="password" name="password">
                                    <button class="btn bg-info-subtle text-info  rounded-end d-flex align-items-center password-addon" type="button">
                                        <i class="ti ti-eye"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>