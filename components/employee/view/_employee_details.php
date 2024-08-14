<?php
    require('components/employee/model/employee-model.php');

    $employeeModel = new EmployeeModel($databaseModel);

    $employeeDetails = $employeeModel->getEmployee($detailID);
    $employmentStatus = $employeeDetails['employment_status'];

    $archiveEmployee  = $globalModel->checkSystemActionAccessRights($userID, 20);
    $unarchiveEmployee  = $globalModel->checkSystemActionAccessRights($userID, 21);

    if($employmentStatus == 'Archived' && $unarchiveEmployee['total'] > 0){
        $archiveButton = ' <li>
                                <a class="dropdown-item" href="javascript:void(0)" id="unarchive-employee">Unarchive Employee</a>
                            </li>';
    }

    if($employmentStatus == 'Active' && $archiveEmployee['total'] > 0){
        $archiveButton = ' <li>
                            <a class="dropdown-item" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#archive-employee-modal" id="archive-employee">Archive Employee</a>
                        </li>';
    }
?>
<div class="row">
    <div class="col-lg-8">
        <div class="card overflow-hidden">
            <div class="card-body p-0">
                <img src="./assets/images/backgrounds/profilebg.jpg" alt="matdash-img" class="img-fluid">
                <div class="row align-items-center">
                    <div class="col-lg-3 mt-n3 order-lg-2 order-1">
                        <div class="mt-n5">
                            <div class="d-flex align-items-center justify-content-center mb-2">
                                <div class="d-flex align-items-center justify-content-center round-110">
                                    <div class="border border-4 border-white d-flex align-items-center justify-content-center rounded-circle overflow-hidden round-100">
                                        <label for="employee_image" class="cursor-pointer bg-light">
                                            <img src="./assets/images/default/upload-placeholder.png" alt="employee-image" id="employee-image" class="img-fluid" width="100" height="100">
                                            <input type="file" class="form-control d-none" id="employee_image" name="employee_image">
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 order-2 my-3 text-center text-lg-start">
                        <h6 class="mb-0" id="employee_full_name_summary">--</h6>
                        <p class="mb-0" id="employee_job_position_summary">--</p>
                    </div>
                    <div class="col-lg-3 order-3">
                        <button class="btn btn-info dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                            Action
                        </button>
                        <ul class="dropdown-menu dropdown-menu-start" aria-labelledby="dropdownMenuButton" style="">
                            <?php echo $archiveButton; ?>
                            <li>
                                <a class="dropdown-item" href="javascript:void(0)">QR Code</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">About</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil fs-6" data-bs-toggle="modal" data-bs-target="#about-modal" id="edit-about-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <p class="text-justify aboutscroll mb-0" id="about_summary">
                            No about found.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Private Information</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil fs-6" data-bs-toggle="modal" data-bs-target="#private-information-modal" id="edit-private-information-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Nickname</p>
                                <h6 class="fw-semibold mb-0" id="nickname_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Civil Status</p>
                                <h6 class="fw-semibold mb-0" id="civil_status_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Place of Birth</p>
                                <h6 class="fw-semibold mb-0" id="place_of_birth_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Date of Birth</p>
                                <h6 class="fw-semibold mb-0" id="date_of_birth_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Blood Type</p>
                                <h6 class="fw-semibold mb-0" id="blood_type_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Gender</p>
                                <h6 class="fw-semibold mb-0" id="gender_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Height</p>
                                <h6 class="fw-semibold mb-0" id="height_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Weight</p>
                                <h6 class="fw-semibold mb-0" id="weight_summary">--</h6>
                            </div>
                            <div class="col-lg-4 mb-3">
                                <p class="mb-1 fs-2">Religion</p>
                                <h6 class="fw-semibold mb-0" id="religion_summary">--</h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Work Information</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil fs-6" data-bs-toggle="modal" data-bs-target="#work-information-modal" id="edit-work-information-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-4 mb-3">
                        <p class="mb-1 fs-2">Department</p>
                        <h6 class="fw-semibold mb-0" id="department_summary">--</h6>
                    </div>
                    <div class="col-lg-4 mb-3">
                        <p class="mb-1 fs-2">Job Position</p>
                        <h6 class="fw-semibold mb-0" id="job_position_summary">--</h6>
                    </div>
                    <div class="col-lg-4 mb-3">
                        <p class="mb-1 fs-2">Manager</p>
                        <h6 class="fw-semibold mb-0" id="manager_summary">--</h6>
                    </div>
                    <div class="col-lg-4 mb-3">
                        <p class="mb-1 fs-2">Company</p>
                        <h6 class="fw-semibold mb-0" id="company_summary">--</h6>
                    </div>
                    <div class="col-lg-4 mb-3">
                        <p class="mb-1 fs-2">Work Location</p>
                        <h6 class="fw-semibold mb-0" id="work_location_summary">--</h6>
                    </div>
                    <div class="col-lg-4 mb-3">
                        <p class="mb-1 fs-2">Home-Work Distance</p>
                        <h6 class="fw-semibold mb-0" id="home_work_distance_summary">--</h6>
                    </div>
                    <div class="col-lg-4 mb-3">
                        <p class="mb-1 fs-2">Work Schedule</p>
                        <h6 class="fw-semibold mb-0" id="work_schedule_summary">--</h6>
                    </div>
                    <div class="col-lg-4 mb-0">
                        <p class="mb-1 fs-2">Time Off</p>
                        <h6 class="fw-semibold mb-0" id="time_off_approver_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Address</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#address-modal" id="add-address-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="address-container"></div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Experience</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto" data-bs-toggle="modal" data-bs-target="#experience-modal" id="add-experience-details"><i class="ti ti-plus fs-6"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="experience-container"></div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Education</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#education-modal" id="add-education-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="education-container"></div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">HR Settings</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil fs-6" data-bs-toggle="modal" data-bs-target="#hr-settings-modal" id="edit-hr-settings-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">PIN Code</p>
                        <h6 class="fw-semibold mb-0" id="pin_code_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Badge ID</p>
                        <h6 class="fw-semibold mb-0" id="badge_id_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Employment Type</p>
                        <h6 class="fw-semibold mb-0" id="employment_type_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">On-Board Date</p>
                        <h6 class="fw-semibold mb-0" id="onboard_date_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Offboard Date</p>
                        <h6 class="fw-semibold mb-0" id="offboard_date_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Departure Reason</p>
                        <h6 class="fw-semibold mb-0" id="departure_reason_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-0">
                        <p class="mb-1 fs-2">Detailed Departure Reason</p>
                        <h6 class="fw-semibold mb-0" id="detailed_departure_reason_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Work Permit</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil fs-6" data-bs-toggle="modal" data-bs-target="#work-permit-modal" id="edit-work-permit-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Visa No.</p>
                        <h6 class="fw-semibold mb-0" id="visa_number_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Visa Expiration Date</p>
                        <h6 class="fw-semibold mb-0" id="visa_expiration_date_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Work Permit No.</p>
                        <h6 class="fw-semibold mb-0" id="work_permit_number_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-0">
                        <p class="mb-1 fs-2">Work Permit Expiration Date</p>
                        <h6 class="fw-semibold mb-0" id="work_permit_expiration_date_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">ID Records</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#id-record-modal" id="add-id-record-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="id-record-container"></div>
            <input type="file" class="form-control d-none" id="id_image" name="id_image">
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Licenses</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#license-modal" id="add-license-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="license-container"></div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Emergency Contact</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#emergency-contact-modal" id="add-emergency-contact-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="emergency-contact-container"></div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Bank Account</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#bank-account-modal" id="add-bank-account-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="bank-account-container"></div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Languages</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#language-modal" id="add-language-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="language-container"></div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_log_notes_offcanvas.php'); ?>
<?php require_once('components/global/view/_internal_log_notes.php'); ?>

<div id="about-modal" class="modal fade" tabindex="-1" aria-labelledby="about-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit About</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="about-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="about">About <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="about" name="about" maxlength="500"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="about-form" class="btn btn-success" id="submit-about-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="private-information-modal" class="modal fade" tabindex="-1" aria-labelledby="private-information-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Private Information</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="private-information-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="first_name" class="form-label">First Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="200" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="middle_name" class="form-label">Middle Name</label>
                                        <input type="text" class="form-control maxlength" id="middle_name" name="middle_name" maxlength="200" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="nickname" class="form-label">Nickname</label>
                                        <input type="text" class="form-control maxlength" id="nickname" name="nickname" maxlength="100" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="gender_id" class="form-label">Gender <span class="text-danger">*</span></label>
                                    <div class="mb-3">
                                        <select id="gender_id" name="gender_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="civil_status_id" class="form-label">Civil Status <span class="text-danger">*</span></label>
                                    <div class="mb-3">
                                        <select id="civil_status_id" name="civil_status_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="birthday" class="form-label">Date of Birth <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <input type="text" class="form-control regular-datepicker" id="birthday" name="birthday" autocomplete="off"/>
                                            <span class="input-group-text">
                                                <i class="ti ti-calendar fs-5"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="birth_place" class="form-label">Place of Birth <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control maxlength" id="birth_place" name="birth_place" maxlength="1000" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="last_name" class="form-label">Last Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="200" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="suffix" class="form-label">Suffix</label>
                                        <input type="text" class="form-control maxlength" id="suffix" name="suffix" maxlength="10" autocomplete="off">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="blood_type_id" class="form-label">Blood Type</label>
                                    <div class="mb-3">
                                        <select id="blood_type_id" name="blood_type_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="religion_id" class="form-label">Religion</label>
                                    <div class="mb-3">
                                        <select id="religion_id" name="religion_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="height" class="form-label">Height</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="height" name="height" min="0" value="0" step="0.01">
                                            <span class="input-group-text">
                                                cm
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="weight" class="form-label">Weight</label>
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
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="private-information-form" class="btn btn-success" id="submit-private-information-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="work-information-modal" class="modal fade" tabindex="-1" aria-labelledby="work-information-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Work Information</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="work-information-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="department_id" class="form-label">Department <span class="text-danger">*</span></label>
                                    <div class="mb-3">
                                        <select id="department_id" name="department_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="manager_id" class="form-label">Manager</label>
                                    <div class="mb-3">
                                        <select id="manager_id" name="manager_id" class="select2 form-control">
                                            <option value="0">--</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="company_id" class="form-label">Company <span class="text-danger">*</span></label>
                                    <div class="mb-3">
                                        <select id="company_id" name="company_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="work_location_id" class="form-label">Work Location</label>
                                    <div class="mb-3">
                                        <select id="work_location_id" name="work_location_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="mb-3">
                                        <label for="home_work_distance" class="form-label">Home-Work Distance</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control" id="home_work_distance" name="home_work_distance" min="0">
                                            <span class="input-group-text">km</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="work_schedule_id" class="form-label">Work Schedule</label>
                                    <div class="mb-3">
                                        <select id="work_schedule_id" name="work_schedule_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="job_position_id" class="form-label">Job Position <span class="text-danger">*</span></label>
                                    <div class="mb-3">
                                        <select id="job_position_id" name="job_position_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <label for="time_off_approver_id" class="form-label">Time Off <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="Select the user responsible for approving &quot;Time Off&quot; of this employee."></span></label>
                                    <div class="mb-3">
                                        <select id="time_off_approver_id" name="time_off_approver_id" class="select2 form-control"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                  
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="work-information-form" class="btn btn-success" id="submit-work-information-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="experience-modal" class="modal fade" tabindex="-1" aria-labelledby="experience-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="experience-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="experience-form" method="post" action="#">
                    <input type="hidden" id="employee_experience_id" name="employee_experience_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="job_title" class="form-label">Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="job_title" name="job_title" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="experience_employment_type_id" class="form-label">Employment Type</label>
                            <div class="mb-3">
                                <select id="experience_employment_type_id" name="experience_employment_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="company_name" class="form-label">Company Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="company_name" name="company_name" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="location" class="form-label">Location</label>
                                <input type="text" class="form-control maxlength" id="location" name="location" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="employment_location_type_id" class="form-label">Location Type</label>
                            <div class="mb-3">
                                <select id="employment_location_type_id" name="employment_location_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">Start Month <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="start_experience_date_month" name="start_experience_date_month" class="select2 select2-month form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateMonthOptions(); ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">Start Year <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="start_experience_date_year" name="start_experience_date_year" class="select2 select2-year form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateYearOptions(date('Y', strtotime('-100 years')), date('Y')); ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">End Month</label>
                            <div class="mb-3">
                                <select id="end_experience_date_month" name="end_experience_date_month" class="select2 select2-month form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateMonthOptions(); ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">End Year</label>
                            <div class="mb-3">
                                <select id="end_experience_date_year" name="end_experience_date_year" class="select2 select2-year form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateYearOptions(date('Y', strtotime('-100 years')), date('Y')); ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label for="job_description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="job_description" name="job_description" maxlength="5000"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="experience-form" class="btn btn-success" id="submit-experience-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="education-modal" class="modal fade" tabindex="-1" aria-labelledby="education-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="education-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="education-form" method="post" action="#">
                    <input type="hidden" id="employee_education_id" name="employee_education_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="school" class="form-label">School <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="school" name="school" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="degree" class="form-label">Degree</label>
                                <input type="text" class="form-control maxlength" id="degree" name="degree" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="field_of_study" class="form-label">Field of Study</label>
                                <input type="text" class="form-control maxlength" id="field_of_study" name="field_of_study" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">Start Month <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="start_education_date_month" name="start_education_date_month" class="select2 select2-month form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateMonthOptions(); ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">Start Year <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="start_education_date_year" name="start_education_date_year" class="select2 select2-year form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateYearOptions(date('Y', strtotime('-100 years')), date('Y')); ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">End Month</label>
                            <div class="mb-3">
                                <select id="end_education_date_month" name="end_education_date_month" class="select2 select2-month form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateMonthOptions(); ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-6">
                            <label class="form-label">End Year</label>
                            <div class="mb-3">
                                <select id="end_education_date_year" name="end_education_date_year" class="select2 select2-year form-control">
                                    <option value="">--</option>
                                    <?php echo $systemModel->generateYearOptions(date('Y', strtotime('-100 years')), date('Y')); ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="activities_societies" class="form-label">Activities and Societies</label>
                                <textarea class="form-control" id="activities_societies" name="activities_societies" maxlength="1000"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label for="education_description" class="form-label">Description</label>
                                <textarea class="form-control" id="education_description" name="education_description" maxlength="1000"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="education-form" class="btn btn-success" id="submit-education-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="hr-settings-modal" class="modal fade" tabindex="-1" aria-labelledby="hr-settings-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit HR Settings</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="hr-settings-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="pin_code" class="form-label">PIN Code <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="PIN used to Check In/Out in the Kiosk Mode of the Attendance application and to change the cashier in the Point of Sale application."></span></label>
                                <input type="text" class="form-control maxlength" id="pin_code" name="pin_code" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="badge_id" class="form-label">Badge ID <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="ID used for employee identification."></span></label>
                                <input type="text" class="form-control maxlength" id="badge_id" name="badge_id" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="employment_type_id" class="form-label">Employment Type</label>
                            <div class="mb-3">
                                <select id="employment_type_id" name="employment_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="onboard_date" class="form-label">On-Board Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="onboard_date" name="onboard_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>             
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="hr-settings-form" class="btn btn-success" id="submit-hr-settings-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="work-permit-modal" class="modal fade" tabindex="-1" aria-labelledby="work-permit-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Work Permit</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="work-permit-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="visa_number" class="form-label">Visa No.</label>
                                <input type="text" class="form-control maxlength" id="visa_number" name="visa_number" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="visa_expiration_date" class="form-label">Visa Expiration Date</label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="visa_expiration_date" name="visa_expiration_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="work_permit_number" class="form-label">Work Permit No.</label>
                                <input type="text" class="form-control maxlength" id="work_permit_number" name="work_permit_number" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="work_permit_expiration_date" class="form-label">Work Permit Expiration Date</label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="work_permit_expiration_date" name="work_permit_expiration_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                     </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="work-permit-form" class="btn btn-success" id="submit-work-permit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="address-modal" class="modal fade" tabindex="-1" aria-labelledby="address-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="address-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="address-form" method="post" action="#">
                    <input type="hidden" id="employee_address_id" name="employee_address_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="address_type_id" class="form-label">Address Type <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="address_type_id" name="address_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="city_id" class="form-label">City <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="city_id" name="city_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="address" class="form-label">Address <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="address" name="address" maxlength="1000"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="employee_address_mobile">Mobile <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="employee_address_mobile" name="employee_address_mobile" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="employee_address_telephone">Telephone</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="employee_address_telephone" name="employee_address_telephone" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">        
                        <div class="col-lg-12">
                            <label class="form-label" for="contact_information_email">Email</label>
                            <div class="mb-3">
                                <input type="email" class="form-control maxlength" id="contact_information_email" name="contact_information_email" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="address-form" class="btn btn-success" id="submit-address-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="id-record-modal" class="modal fade" tabindex="-1" aria-labelledby="id-record-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="id-record-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="id-record-form" method="post" action="#">
                    <input type="hidden" id="employee_id_record_id" name="employee_id_record_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="id_type_id" class="form-label">ID Type <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="id_type_id" name="id_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="id_number">ID Number <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="id_number" name="id_number" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label for="id_issue_date" class="form-label">Issue Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="id_issue_date" name="id_issue_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label for="id_expiration_date" class="form-label">Expiration Date</label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="id_expiration_date" name="id_expiration_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="issuing_authority">Issuing Authority</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="issuing_authority" name="issuing_authority" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="id-record-form" class="btn btn-success" id="submit-id-record-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="bank-account-modal" class="modal fade" tabindex="-1" aria-labelledby="bank-account-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="bank-account-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="bank-account-form" method="post" action="#">
                    <input type="hidden" id="employee_bank_account_id" name="employee_bank_account_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="bank_id" class="form-label">Bank <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="bank_id" name="bank_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="bank_account_type_id" class="form-label">Bank Account Type <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="bank_account_type_id" name="bank_account_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="account_number">Account Number <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="account_number" name="account_number" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="bank-account-form" class="btn btn-success" id="submit-bank-account-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="license-modal" class="modal fade" tabindex="-1" aria-labelledby="license-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-md">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="license-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="license-form" method="post" action="#">
                    <input type="hidden" id="employee_license_id" name="employee_license_id">
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="licensed_profession">Licensed Profession <span class="text-danger">*</span> <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="Enter the official professional title as recognized in the field. Examples include 'Attorney at Law,' 'Licensed Physician,' 'Registered Nurse,' etc. This should reflect the qualified status in the profession."></span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="licensed_profession" name="licensed_profession" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="licensing_body">Licensing Body  <span class="text-danger">*</span> <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="Specify the licensing body or jurisdiction that granted the professional license. This could be a state board, a national association, or a regulatory council. Examples include 'Philippine Bar Association,' 'Philippine Board of Medicine,' etc."></span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="licensing_body" name="licensing_body" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="license_number">Licensed Number <span class="text-danger">*</span> <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="Enter the license number and include all characters listed on the license. If the permit does not have a license number, just enter N/A."></span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="license_number" name="license_number" maxlength="200" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label for="license_issue_date" class="form-label">Issue Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="license_issue_date" name="license_issue_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label for="license_expiration_date" class="form-label">Expiration Date</label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="license_expiration_date" name="license_expiration_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="license-form" class="btn btn-success" id="submit-license-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="emergency-contact-modal" class="modal fade" tabindex="-1" aria-labelledby="emergency-contact-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="emergency-contact-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="emergency-contact-form" method="post" action="#">
                    <input type="hidden" id="employee_emergency_contact_id" name="employee_emergency_contact_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="emergency_contact_name" class="form-label">Emergency Contact Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="emergency_contact_name" name="emergency_contact_name" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="emergency_contact_relation_id" class="form-label">Relation <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="emergency_contact_relation_id" name="emergency_contact_relation_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="emergency_contact_telephone">Telephone</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="emergency_contact_telephone" name="emergency_contact_telephone" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="emergency_contact_mobile">Mobile <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="emergency_contact_mobile" name="emergency_contact_mobile" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">        
                        <div class="col-lg-12">
                            <label class="form-label" for="emergency_contact_email">Email</label>
                            <div class="mb-3">
                                <input type="email" class="form-control maxlength" id="emergency_contact_email" name="emergency_contact_email" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="emergency-contact-form" class="btn btn-success" id="submit-emergency-contact-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="language-modal" class="modal fade" tabindex="-1" aria-labelledby="language-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="language-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="language-form" method="post" action="#">
                    <input type="hidden" id="employee_language_id" name="employee_language_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="language_id" class="form-label">Language <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="language_id" name="language_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="language_proficiency_id" class="form-label">Language Proficiency <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="language_proficiency_id" name="language_proficiency_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="language-form" class="btn btn-success" id="submit-language-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="archive-employee-modal" class="modal fade" tabindex="-1" aria-labelledby="archive-employee-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Archive Employee</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="archive-employee-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label for="offboard_date" class="form-label">Offboard Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="offboard_date" name="offboard_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="departure_reason_id" class="form-label">Departure Reason <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="departure_reason_id" name="departure_reason_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <label for="detailed_departure_reason" class="form-label">Detailed Reason <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <textarea class="form-control" id="detailed_departure_reason" name="detailed_departure_reason" maxlength="5000"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="archive-employee-form" class="btn btn-success" id="submit-archive-employee-data">Save changes</button>
            </div>
        </div>
    </div>
</div>