<div class="card card-body">
    <div class="row">
        <div class="col-md-4 col-xl-3">
            <div class="position-relative">
                <input type="text" class="form-control product-search ps-5" id="datatable-search" placeholder="Search..." />
                <i class="ti ti-search position-absolute top-50 start-0 translate-middle-y fs-6 text-dark ms-3"></i>
            </div>
        </div>
        <div class="col-md-8 col-xl-9 text-end d-flex justify-content-md-end justify-content-center mt-3 mt-md-0">
            <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                <?php
                    echo $deleteAccess['total'] > 0 ? '<button type="button" class="btn btn-dark dropdown-toggle action-dropdown mb-0 d-none" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                                                        <ul class="dropdown-menu dropdown-menu-end">
                                                            <li><button class="dropdown-item" type="button" id="delete-booking">Delete Booking</button></li>
                                                        </ul>' : '';
                    
                    echo $createAccess['total'] > 0 ? '<a href="'. $pageLink .'&new" class="btn btn-success d-flex align-items-center mb-0">Create</a>' : '';
                ?>
                <button type="button" class="btn btn-warning mb-0 px-4" data-bs-toggle="offcanvas" data-bs-target="#filter-offcanvas" aria-controls="filter-offcanvas">Filter</a>
            </div>
        </div>
    </div>
</div>

<div class="datatables">
    <div class="row">
        <div class="col-12">
            <div class="card mb-0">
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="booking-table" class="table align-middle text-nowrap w-100 mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th class="all">
                                        <div class="form-check">
                                            <input class="form-check-input" id="datatable-checkbox" type="checkbox">
                                        </div>
                                    </th>
                                    <th>Customer</th>
                                    <th>Message</th>
                                    <th>Inquiry Date</th>
                                    <th>Inquiry Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="offcanvas offcanvas-start" tabindex="-1" id="filter-offcanvas" aria-labelledby="filter-offcanvas-label">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="filter-offcanvas-label">Filter</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body p-0">
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Company</h6>
            <div class="pb-4 px-4 text-dark" id="company-filter">
                <select id="company_filter" name="company_filter" class="select2 form-control"></select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Department</h6>
            <div class="pb-4 px-4 text-dark" id="department-filter">
                <select id="department_filter" name="department_filter" class="select2 form-control"></select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Job Position</h6>
            <div class="pb-4 px-4 text-dark" id="job-position-filter">
                <select id="job_position_filter" name="job_position_filter" class="select2 form-control"></select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Employee Status</h6>
            <div class="pb-4 px-4 text-dark" id="employee-status-filter">
                <select id="employee_status_filter" name="employee_status_filter" class="select2 form-control"></select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Employment Type</h6>
            <div class="pb-4 px-4 text-dark" id="employment-type-filter">
                <select id="employment_type_filter" name="employment_type_filter" class="select2 form-control"></select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Gender</h6>
            <div class="pb-4 px-4 text-dark" id="gender-filter">
                <select id="gender_filter" name="gender_filter" class="select2 form-control"></select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Civil Status</h6>
            <div class="pb-4 px-4 text-dark" id="civil-status-filter">
                <select id="civil_status_filter" name="civil_status_filter" class="select2 form-control"></select>
            </div>
        </div>
        <div class="p-4">
            <button type="button" class="btn btn-warning w-100" id="apply-filter">Apply Filter</button>
        </div>
    </div>
</div>