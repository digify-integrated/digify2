<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-body">
              <h4 class="card-title mb-0">Employee Form</h4>
              <h6 class="card-subtitle mb-3"></h6>
              <div id="example-vertical" class="mt-5">
                <h3>Personal Information</h3>
                <section>
                  <p> Try the keyboard navigation by clicking arrow left or right! </p>
                </section>
                <h3>Employment Details</h3>
                <section>
                  <p>Wonderful transition effects.</p>
                </section>
              </div>
            </div>
          </div>
    </div>
</div>
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
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="first_name">First Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="middle_name">Middle Name</label>
                                <input type="text" class="form-control maxlength" id="middle_name" name="middle_name" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="last_name">Last Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="suffix">Suffix</label>
                                <input type="text" class="form-control maxlength" id="suffix" name="suffix" maxlength="10" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="nickname">Nickname</label>
                                <input type="text" class="form-control maxlength" id="nickname" name="nickname" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="civil_status_id">Civil Status <span class="text-danger">*</span></label>
                                <select id="civil_status_id" name="civil_status_id" class="select2 form-control"></select>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="gender_id">Gender <span class="text-danger">*</span></label>
                                <select id="gender_id" name="gender_id" class="select2 form-control"></select>
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="religion_id">Religion</label>
                                <select id="religion_id" name="religion_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="mb-3">
                                <label class="form-label" for="blood_type_id">Blood Type</label>
                                <select id="blood_type_id" name="blood_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="bio">Bio</label>
                                <textarea class="form-control maxlength" id="bio" name="bio" maxlength="1000" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>