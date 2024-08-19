<?php
    require('components/customer/model/customer-model.php');

    $customerModel = new CustomerModel($databaseModel);

    $customerDetails = $customerModel->getCustomer($detailID);
    $customerStatus = $customerDetails['customer_status'];

    $archiveCustomer  = $globalModel->checkSystemActionAccessRights($userID, 20);
    $unarchiveCustomer  = $globalModel->checkSystemActionAccessRights($userID, 21);

    if($customerStatus == 'Archived' && $unarchiveCustomer['total'] > 0){
        $archiveButton = ' <li>
                                <a class="dropdown-item" href="javascript:void(0)" id="unarchive-customer">Unarchive Customer</a>
                            </li>';
    }

    if($customerStatus == 'Active' && $archiveCustomer['total'] > 0){
        $archiveButton = ' <li>
                            <a class="dropdown-item" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#archive-customer-modal" id="archive-customer">Archive Customer</a>
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
                                        <label for="customer_image" class="cursor-pointer bg-light">
                                            <img src="./assets/images/default/upload-placeholder.png" alt="customer-image" id="customer-image" class="img-fluid" width="100" height="100">
                                            <input type="file" class="form-control d-none" id="customer_image" name="customer_image">
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 order-2 my-3 text-center text-lg-start">
                        <h6 class="mb-0" id="customer_full_name_summary">--</h6>
                        <p class="mb-0" id="customer_job_position_summary">--</p>
                    </div>
                    <div class="col-lg-3 order-3">
                        <button class="btn btn-info dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                            Action
                        </button>
                        <ul class="dropdown-menu dropdown-menu-start" aria-labelledby="dropdownMenuButton" style="">
                            <?php
                                echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Customer</a></li>' : ''; 
                                echo $archiveButton;
                            ?>
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
    </div>

    <div class="col-lg-4">

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
                <h5 class="card-title mb-0">Bank Card</h5>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions ms-auto d-flex button-group">
                                                            <a href="javascript:void(0)" class="link text-dark fw-medium py-1 px-2 ms-auto"><i class="ti ti-plus fs-6" data-bs-toggle="modal" data-bs-target="#bank-card-modal" id="add-bank-card-details"></i></a>
                                                        </div>' : '';
                ?>
            </div>
            <hr class="m-0" />
            <div class="card-body" id="bank-card-container"></div>
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

<div id="address-modal" class="modal fade" tabindex="-1" aria-labelledby="address-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="address-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="address-form" method="post" action="#">
                    <input type="hidden" id="customer_address_id" name="customer_address_id">
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
                            <label class="form-label" for="customer_address_mobile">Mobile <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="customer_address_mobile" name="customer_address_mobile" maxlength="20" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="customer_address_telephone">Telephone</label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="customer_address_telephone" name="customer_address_telephone" maxlength="20" autocomplete="off">
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
                    <input type="hidden" id="customer_id_record_id" name="customer_id_record_id">
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

<div id="bank-card-modal" class="modal fade" tabindex="-1" aria-labelledby="bank-card-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8" id="bank-card-title"></h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="bank-card-form" method="post" action="#">
                    <input type="hidden" id="customer_bank_card_id" name="customer_bank_card_id">
                    <div class="row">
                        <div class="col-lg-12">
                            <label class="form-label" for="name_on_card">Name On Card <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="name_on_card" name="name_on_card" maxlength="1000" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <label class="form-label" for="card_number">Card Number <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control cc-inputmask"id="card_number" name="card_number" />
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="expiry_date">Card Expiry Date <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control expiry-inputmask"id="expiry_date" name="expiry_date" />
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="cvv">CVV <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control cvv-inputmask"id="cvv" name="cvv" />
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="bank-card-form" class="btn btn-success" id="submit-bank-card-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="archive-customer-modal" class="modal fade" tabindex="-1" aria-labelledby="archive-customer-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Archive Customer</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="archive-customer-form" method="post" action="#">
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
                <button type="submit" form="archive-customer-form" class="btn btn-success" id="submit-archive-customer-data">Save changes</button>
            </div>
        </div>
    </div>
</div>