<div class="row">
    <div class="col-12">
        <form id="employee-form" method="post" action="#">
            <div class="card mb-0">
                <div class="card-body d-flex align-items-center">
                    <h5 class="card-title mb-0">Employee Information</h5>
                    <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                        <button type="submit" form="employee-form" class="btn btn-success mb-0" id="submit-data">Save</button>
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
                            <div class="mb-3 row align-items-center">
                                <label for="department_id" class="form-label col-lg-3 col-form-label">Department <span class="text-danger">*</span></label>
                                <div class="col-lg-9">
                                    <select id="department_id" name="department_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="manager_id" class="form-label col-lg-3 col-form-label">Manager</label>
                                <div class="col-lg-9">
                                    <select id="manager_id" name="manager_id" class="select2 form-control"><option value="">--</option></select>
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
                            <div class="row align-items-center">
                                <label for="job_position_id" class="form-label col-lg-3 col-form-label">Job Position <span class="text-danger">*</span></label>
                                <div class="col-lg-9">
                                    <select id="job_position_id" name="job_position_id" class="select2 form-control"></select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <hr class="m-0" />
                <div class="card-body">
                    <h5 class="card-title mb-0">Work Information</h5>
                </div>
                <hr class="m-0" />
                <div class="card-body pt-3">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Location</label>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="company_id" class="form-label col-lg-5 col-form-label">Company <span class="text-danger">*</span></label>
                                <div class="col-lg-7">
                                    <select id="company_id" name="company_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="work_location_id" class="form-label col-lg-5 col-form-label">Work Location</label>
                                <div class="col-lg-7">
                                    <select id="work_location_id" name="work_location_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="home_work_distance" class="form-label col-lg-5 col-form-label">Home-Work Distance</label>
                                <div class="col-lg-7">
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="home_work_distance" name="home_work_distance" min="0">
                                        <span class="input-group-text">km</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Approvers</label>
                            </div>
                            <div class="row align-items-center">
                                <label for="time_off_approver_id" class="form-label col-lg-3 col-form-label">Time Off <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="Select the user responsible for approving &quot;Time Off&quot; of this employee."></span></label>
                                <div class="col-lg-9">
                                    <select id="time_off_approver_id" name="time_off_approver_id" class="select2 form-control"></select>
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
                <div class="card-body pt-3">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Personal Information</label>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="nickname" class="form-label col-lg-4 col-form-label">Nickname</label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="nickname" name="nickname" maxlength="100" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="gender_id" class="form-label col-lg-4 col-form-label">Gender <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <select id="gender_id" name="gender_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="civil_status_id" class="form-label col-lg-4 col-form-label">Civil Status <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <select id="civil_status_id" name="civil_status_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="birthday" class="form-label col-lg-4 col-form-label">Date of Birth <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <div class="input-group">
                                        <input type="text" class="form-control regular-datepicker" id="birthday" name="birthday"/>
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
                                <label for="blood_type_id" class="form-label col-lg-4 col-form-label">Blood Type</label>
                                <div class="col-lg-8">
                                    <select id="blood_type_id" name="blood_type_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="religion_id" class="form-label col-lg-4 col-form-label">Religion</label>
                                <div class="col-lg-8">
                                    <select id="religion_id" name="religion_id" class="select2 form-control"></select>
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
                        <div class="col-lg-6">
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Work Permit</label>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="visa_number" class="form-label col-lg-6 col-form-label">Visa No.</label>
                                <div class="col-lg-6">
                                    <input type="text" class="form-control maxlength" id="visa_number" name="visa_number" maxlength="50" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="visa_expiration_date" class="form-label col-lg-6 col-form-label">Visa Expiration Date</label>
                                <div class="col-lg-6">
                                    <div class="input-group">
                                        <input type="text" class="form-control regular-datepicker" id="visa_expiration_date" name="visa_expiration_date"/>
                                        <span class="input-group-text">
                                            <i class="ti ti-calendar fs-5"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="work_permit_number" class="form-label col-lg-6 col-form-label">Work Permit No.</label>
                                <div class="col-lg-6">
                                    <input type="text" class="form-control maxlength" id="work_permit_number" name="work_permit_number" maxlength="50" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="work_permit_expiration_date" class="form-label col-lg-6 col-form-label">Work Permit Expiration Date</label>
                                <div class="col-lg-6">
                                    <div class="input-group">
                                        <input type="text" class="form-control regular-datepicker" id="work_permit_expiration_date" name="work_permit_expiration_date"/>
                                        <span class="input-group-text">
                                            <i class="ti ti-calendar fs-5"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <hr class="m-0" />
                <div class="card-body">
                    <h5 class="card-title mb-0">HR Settings</h5>
                </div>
                <hr class="m-0" />
                <div class="card-body pt-3">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Attendance/Point Of Sale</label>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="pin_code" class="form-label col-lg-4 col-form-label">PIN Code <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="PIN used to Check In/Out in the Kiosk Mode of the Attendance application and to change the cashier in the Point of Sale application."></span></label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="pin_code" name="pin_code" maxlength="500" autocomplete="off">
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="badge_id" class="form-label col-lg-4 col-form-label">Badge ID <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="ID used for employee identification."></span></label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="badge_id" name="badge_id" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Status</label>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="employment_type_id" class="form-label col-lg-4 col-form-label">Employment Type</label>
                                <div class="col-lg-8">
                                    <select id="employment_type_id" name="employment_type_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="onboard_date" class="form-label col-lg-4 col-form-label">On-Board Date <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <div class="input-group">
                                        <input type="text" class="form-control regular-datepicker" id="onboard_date" name="onboard_date"/>
                                        <span class="input-group-text">
                                            <i class="ti ti-calendar fs-5"></i>
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