<div class="row">
    <div class="col-12">
        <form id="customer-form" method="post" action="#">
            <div class="card mb-0">
                <div class="card-body d-flex align-items-center">
                    <h5 class="card-title mb-0">Customer Information</h5>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <button type="submit" form="customer-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                        <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                    </div>
                </div>
                <hr class="m-0" />
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3 row align-items-center">
                                <label for="first_name" class="form-label col-lg-3 col-form-label">First Name <span class="text-danger">*</span></label>
                                <div class="col-lg-9">
                                    <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="middle_name" class="form-label col-lg-3 col-form-label">Middle Name</label>
                                <div class="col-lg-9">
                                    <input type="text" class="form-control maxlength" id="middle_name" name="middle_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3 row align-items-center">
                                <label for="last_name" class="form-label col-lg-3 col-form-label">Last Name <span class="text-danger">*</span></label>
                                <div class="col-lg-9">
                                    <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="suffix" class="form-label col-lg-3 col-form-label">Suffix</label>
                                <div class="col-lg-9">
                                    <input type="text" class="form-control maxlength" id="suffix" name="suffix" maxlength="10" autocomplete="off">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <hr class="m-0" />
                <div class="card-body">
                    <h5 class="card-title mb-0">Private Information</h5>
                </div>
                <hr class="m-0" />
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3 row align-items-center">
                                <label for="nickname" class="form-label col-lg-4 col-form-label">Nickname</label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="nickname" name="nickname" maxlength="100" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="birthday" class="form-label col-lg-4 col-form-label">Date of Birth <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <div class="input-group">
                                        <input type="text" class="form-control regular-datepicker" id="birthday" name="birthday" autocomplete="off"/>
                                        <span class="input-group-text">
                                            <i class="ti ti-calendar fs-5"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="birth_place" class="form-label col-lg-4 col-form-label">Place of Birth <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="birth_place" name="birth_place" maxlength="1000" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="gender_id" class="form-label col-lg-4 col-form-label">Gender <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <select id="gender_id" name="gender_id" class="select2 form-control"></select>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3 row align-items-center">
                                <label for="civil_status_id" class="form-label col-lg-4 col-form-label">Civil Status <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <select id="civil_status_id" name="civil_status_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="height" class="form-label col-lg-4 col-form-label">Height</label>
                                <div class="col-lg-8">
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="height" name="height" min="0" value="0" step="0.01">
                                        <span class="input-group-text">
                                            cm
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="weight" class="form-label col-lg-4 col-form-label">Weight</label>
                                <div class="col-lg-8">
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="weight" name="weight" min="0" value="0" step="0.01">
                                        <span class="input-group-text">
                                            kg
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>