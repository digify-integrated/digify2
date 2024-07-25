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
                                        <img src="./assets/images/profile/user-1.jpg" alt="matdash-img" class="w-100 h-100">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 order-last my-3 text-center text-lg-start">
                        <h6 class="mb-0">Marielle Angelica Corsino Apuya</h6>
                        <p class="mb-0">SECURITY GUARD / HELPER</p>
                    </div>
                    <div class="col-lg-5 order-last">
                        <ul class="list-unstyled d-flex align-items-center justify-content-center my-3 mx-4 pe-4 gap-3">
                            <li>
                                <button class="btn btn-danger text-nowrap"><i class="ti ti-archive me-1"></i> Archive</button>
                            </li>
                            <li>
                                <button class="btn btn-primary text-nowrap"><i class="ti ti-qrcode me-1"></i> QR Code</button>
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
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil me-1 fs-6" data-bs-toggle="modal" data-bs-target="#about-modal" id="edit-about-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <p class="text-justify aboutscroll">
                            Lorem ipsum dolor sit ametetur adipisicing elit, sed do
                            eiusmod tempor incididunt adipisicing elit, sed do eiusmod
                            tempor incididunLorem ipsum dolor sit ametetur adipisicing
                            elit, sed do eiusmod tempor incididuntt
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Private Information</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil me-1 fs-6" data-bs-toggle="modal" data-bs-target="#private-information-modal" id="edit-private-information-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Nickname</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="nickname_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Civil Status</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="civil_status_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Place of Birth</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="place_of_birth_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Date of Birth</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="date_of_birth_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Blood Type</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="date_of_birth_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Height</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="height_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Weight</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="weight_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Gender</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="gender_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Religion</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="religion_summary">--</p>
                                    </div>
                                </div>
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
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil me-1 fs-6" data-bs-toggle="modal" data-bs-target="#work-information-modal" id="edit-work-information-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Department</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="company_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Job Position</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="job_position_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Manager</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="manager_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Company </label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="company_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-5">Work Location</label>
                                    <div class="col-md-7">
                                        <p class="form-control-static" id="work_location_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Home-Work Distance</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="home_work_distance_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Work Schedule</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="work_schedule_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Time Off</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="time_off_approver_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Experience</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6" data-bs-toggle="modal" data-bs-target="#experience-modal" id="add-experience-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div>
                                    <h5 class="fs-4 fw-semibold">Junior Software Developer</h5>
                                    <p class="mb-0">Micromax Computer System · Full-time</p>
                                    <p class="mb-0">Feb 2018 - Jul 2019 · 1 yr 6 mos</p>
                                    <p class="mb-2">704 Anolid, Mangaldan, Pangasinan · Hybrid</p>
                                    <p class="text-dark">As a software developer, my primary responsibility is to participate in the development and maintenance of software applications. I collaborate with senior software developers to design and enhance software solutions and write clean and efficient code using programming languages such as PHP, JavaScript, and others. I have experience in debugging and troubleshooting software issues and conducting code reviews to ensure code quality and consistency. Additionally, I am responsible for testing software applications to ensure they meet quality standards and contribute to the development of software documentation.</p>
                                </div>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                                <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Education</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6" data-bs-toggle="modal" data-bs-target="#education-modal" id="add-education-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div>
                                    <h5 class="fs-4 fw-semibold">AMA Computer College Cabanatuan</h5>
                                    <p class="mb-0">Micromax Computer System · Full-time</p>
                                    <p class="mb-0">Feb 2018 - Jul 2019 · 1 yr 6 mos</p>
                                </div>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                                <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>        

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Emergency Contact</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6" data-bs-toggle="modal" data-bs-target="#emergency-contact-modal" id="add-emergency-contact-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div>
                                <h6 class="fw-semibold mb-1">Lawrence</h6>
                                <p class="mb-2 fs-2">Brother</p>
                            </div>
                            <div>
                                <ul class="list-unstyled mb-0">
                                    <li class="d-flex align-items-center gap-2 py-2">
                                        <i class="ti ti-mail text-primary fs-4"></i>
                                        <span class="text-dark">test@gmail.com</span>
                                    </li>
                                    <li class="d-flex align-items-center gap-2 py-2">
                                        <i class="ti ti-device-mobile text-primary fs-4"></i>
                                        <span class="text-dark">0951654987</span>
                                    </li>
                                    <li class="d-flex align-items-center gap-2 py-2">
                                        <i class="ti ti-phone text-primary fs-4"></i>
                                        <span class="text-dark">0654987</span>
                                    </li>
                                </ul>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                            <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Address</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <p class="mb-1 fs-2">Home Address</p>
                                <h6 class="fw-semibold mb-2 fs-3">1 Rsr appartment Bantug bulalo Cabanatuan City, City of Cabanatuan, Nueva Ecija, Philippines</h6>
                                <span class="badge bg-info">Alternate</span>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                              <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Contact Information</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div>
                                <p class="mb-1 fs-2">Phone number</p>
                                <h6 class="fw-semibold mb-2">+1 (203) 3458</h6>
                                <span class="badge bg-info">Primary</span>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                              <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">ID Records</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div>
                                <p class="mb-1 fs-2">Government Service Insurance System (GSIS) ID</p>
                                <h6 class="fw-semibold mb-2">1211-554444315</h6>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                              <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Bank Account</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div>
                                <p class="mb-1 fs-2">Checking Account</p>
                                <h6 class="fw-semibold mb-2">RCBC (Rizal Commercial Banking Corporation)</h6>
                                <p class="mb-1 fs-2">test</p>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                              <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Licenses</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div>
                                    <h5 class="fs-4 fw-semibold">Profession</h5>
                                    <p class="mb-0">Jurisdiction</p>
                                    <p class="mb-0">License Number: 165+1584</p>
                                    <p class="mb-0">Issued on: Jul 19, 2024</p>
                                    <p class="mb-0">Expires on: Jul 24, 2024</p>
                                </div>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                                <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Languages</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div>
                                    <h5 class="fs-4 fw-semibold">English </h5>
                                    <p class="mb-0">Conversational</p>
                                </div>
                            </div>
                            <a href="javascript:void(0);" class="text-dark fs-6 d-flex align-items-center justify-content-center bg-transparent p-2 fs-4 rounded-circle">
                                <i class="ti ti-pencil"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">HR Settings</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">PIN Code</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="pin_code_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Badge ID</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="badge_id_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Employment Type</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="employment_type_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">On-Board Date</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="onboard_date_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Work Permit</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-pencil me-1 fs-6"></i></a>
                </div>
            </div>
            <hr class="m-0" />
            <div class="card-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Visa No.</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="visa_number_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Visa Expiration Date</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="visa_expiration_date_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Work Permit No.</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="work_permit_number_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group row">
                                    <label class="form-label col-md-7">Work Permit Expiration Date</label>
                                    <div class="col-md-5">
                                        <p class="form-control-static" id="work_permit_expiration_date_summary">--</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

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
                                <label class="form-label" for="about_name">About <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="about" name="about" maxlength="500"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="about-form" class="btn btn-success" id="submit-data">Save changes</button>
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
                            <div class="mb-3 row align-items-center">
                                <label for="first_name" class="form-label col-lg-4 col-form-label">First Name <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="middle_name" class="form-label col-lg-4 col-form-label">Middle Name</label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="middle_name" name="middle_name" maxlength="200" autocomplete="off">
                                </div>
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
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3 row align-items-center">
                                <label for="last_name" class="form-label col-lg-4 col-form-label">Last Name <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="200" autocomplete="off">
                                </div>
                            </div>
                            <div class="mb-3 row align-items-center">
                                <label for="suffix" class="form-label col-lg-4 col-form-label">Suffix</label>
                                <div class="col-lg-8">
                                    <input type="text" class="form-control maxlength" id="suffix" name="suffix" maxlength="10" autocomplete="off">
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
                    </div>                   
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="private-information-form" class="btn btn-success" id="submit-data">Save changes</button>
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
                            <div class="mb-3 row align-items-center">
                                <label for="department_id" class="form-label col-lg-5 col-form-label">Department <span class="text-danger">*</span></label>
                                <div class="col-lg-7">
                                    <select id="department_id" name="department_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label for="manager_id" class="form-label col-lg-5 col-form-label">Manager</label>
                                <div class="col-lg-7">
                                    <select id="manager_id" name="manager_id" class="select2 form-control"></select>
                                </div>
                            </div>
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
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Schedule</label>
                            </div>
                            <div class="row align-items-center">
                                <label for="work_schedule_id" class="form-label col-lg-5 col-form-label">Work Schedule</label>
                                <div class="col-lg-7">
                                    <select id="work_schedule_id" name="work_schedule_id" class="select2 form-control"></select>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="row align-items-center">
                                <label for="job_position_id" class="form-label col-lg-4 col-form-label">Job Position <span class="text-danger">*</span></label>
                                <div class="col-lg-8">
                                    <select id="job_position_id" name="job_position_id" class="select2 form-control"></select>
                                </div>
                            </div>
                            <div class="row align-items-center">
                                <label class="form-label col-lg-12 col-form-label fs-4">Approvers</label>
                            </div>
                            <div class="row align-items-center">
                                <label for="time_off_approver_id" class="form-label col-lg-4 col-form-label">Time Off <span class="ti text-info ti-info-circle cursor-pointer fs-2" data-bs-toggle="tooltip" title="Select the user responsible for approving &quot;Time Off&quot; of this employee."></span></label>
                                <div class="col-lg-8">
                                    <select id="time_off_approver_id" name="time_off_approver_id" class="select2 form-control"></select>
                                </div>
                            </div>
                        </div>
                    </div>                  
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="work-information-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="experience-modal" class="modal fade" tabindex="-1" aria-labelledby="experience-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="experience-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="experience-form" method="post" action="#">
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
                            <div class="mb-3">
                                <label for="experience_employment_type_id" class="form-label">Employment Type</label>
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
                            <div class="mb-3">
                                <label for="employment_location_type_id" class="form-label">Location Type</label>
                                <select id="employment_location_type_id" name="employment_location_type_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                      <div class="col-sm-12 col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Start Month <span class="text-danger">*</span></label>
                            <select id="start_experience_date_month" name="start_experience_date_month" class="select2 form-control"></select>
                        </div>
                      </div>
                      <div class="col-sm-12 col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Start Year <span class="text-danger">*</span></label>
                            <select id="start_experience_date_year" name="start_experience_date_year" class="select2 form-control"></select>
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-sm-12 col-md-6">
                        <div class="mb-3">
                            <label class="form-label">End Month</label>
                            <select id="end_experience_date_month" name="end_experience_date_month" class="select2 form-control"></select>
                        </div>
                      </div>
                      <div class="col-sm-12 col-md-6">
                        <div class="mb-3">
                            <label class="form-label">End Year</label>
                            <select id="end_experience_date_year" name="end_experience_date_year" class="select2 form-control"></select>
                        </div>
                      </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label for="job_description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="job_description" name="job_description" maxlength="1000"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="experience-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="education-modal" class="modal fade" tabindex="-1" aria-labelledby="education-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="education-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="education-form" method="post" action="#">
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
                        <div class="mb-3">
                            <label class="form-label">Start Month <span class="text-danger">*</span></label>
                            <select id="start_education_date_month" name="start_education_date_month" class="select2 form-control"></select>
                        </div>
                      </div>
                      <div class="col-sm-12 col-md-6">
                        <div class="mb-3">
                            <label class="form-label">Start Year <span class="text-danger">*</span></label>
                            <select id="start_education_date_year" name="start_education_date_year" class="select2 form-control"></select>
                        </div>
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-sm-12 col-md-6">
                        <div class="mb-3">
                            <label class="form-label">End Month</label>
                            <select id="end_education_date_month" name="end_education_date_month" class="select2 form-control"></select>
                        </div>
                      </div>
                      <div class="col-sm-12 col-md-6">
                        <div class="mb-3">
                            <label class="form-label">End Year</label>
                            <select id="end_education_date_year" name="end_education_date_year" class="select2 form-control"></select>
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
                <button type="submit" form="education-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="emergency-contact-modal" class="modal fade" tabindex="-1" aria-labelledby="emergency-contact-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="emergency-contact-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="emergency-contact-form" method="post" action="#">
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
                            <div class="mb-3">
                                <label for="emergency_contact_relation_id" class="form-label">Relation <span class="text-danger">*</span></label>
                                <select id="emergency_contact_relation_id" name="emergency_contact_relation_id" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="emergency-contact-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>