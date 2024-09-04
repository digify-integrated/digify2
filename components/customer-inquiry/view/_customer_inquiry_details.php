<?php
    require('components/customer-inquiry/model/customer-inquiry-model.php');

    $customerInquiryModel = new CustomerInquiryModel($databaseModel);

    $tagCustomerInquiryAsInProgress = $globalModel->checkSystemActionAccessRights($userID, 30);
    $tagCustomerInquiryAsResolved = $globalModel->checkSystemActionAccessRights($userID, 31);
    $tagCustomerInquiryAsClosed = $globalModel->checkSystemActionAccessRights($userID, 32);

    if(isset($_GET['id'])){
        $customerInquiryDetails = $customerInquiryModel->getCustomerInquiry($detailID, null);
        $inquiryStatus = $customerInquiryDetails['inquiry_status'];
    }
?>
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Customer Inquiry</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <?php
                            echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Customer Inquiry</a></li>' : '';

                            if($inquiryStatus == 'Pending' && $tagCustomerInquiryAsInProgress['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="tag-as-in-progress">Tag As In-Progress</button></li>';
                            }

                            if($inquiryStatus == 'In-Progress' && $tagCustomerInquiryAsResolved['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="tag-as-resolved">Tag As Resolved</button></li>';
                            }

                            if(($inquiryStatus == 'In-Progress' || $inquiryStatus == 'Resolved') && $tagCustomerInquiryAsClosed['total'] > 0){
                                echo '<li><button class="dropdown-item" type="button" id="tag-as-closed">Tag As Closed</button></li>';
                            }

                            echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-customer-inquiry">Delete Customer Inquiry</button></li>' : '';
                        ?>
                    </ul>
                </div>
                <?php
                    echo $writeAccess['total'] > 0 ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                            <button class="btn btn-info mb-0 px-4" data-bs-toggle="modal" id="edit-details" data-bs-target="#customer-inquiry-modal" id="edit-details">Edit</button>
                                                        </div>' : '';
                ?>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Customer Name</p>
                        <h6 class="fw-semibold mb-0" id="customer_name_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Inquiry Status</p>
                        <div class="fw-semibold mb-0" id="inquiry_status_summary">--</div>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Email</p>
                        <h6 class="fw-semibold mb-0" id="email_summary">--</h6>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <p class="mb-1 fs-2">Phone</p>
                        <h6 class="fw-semibold mb-0" id="phone_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-3">
                        <p class="mb-1 fs-2">Subject</p>
                        <h6 class="fw-semibold mb-0" id="subject_summary">--</h6>
                    </div>
                    <div class="col-lg-12 mb-0">
                        <p class="mb-1 fs-2">Message</p>
                        <h6 class="fw-semibold mb-0" id="message_summary">--</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="customer-inquiry-modal" class="modal fade" tabindex="-1" aria-labelledby="customer-inquiry-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Edit Customer Inquiry Details</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="customer-inquiry-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="customer_name">Customer Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="customer_name" name="customer_name" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="phone">Phone <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="text" class="form-control maxlength" id="phone" name="phone" maxlength="50" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <label class="form-label" for="email">Email <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <input type="email" class="form-control maxlength" id="email" name="email" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="subject">Subject <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="subject" name="subject" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label class="form-label" for="message">Message <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="message" name="message" maxlength="5000" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="customer-inquiry-form" class="btn btn-success" id="submit-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_log_notes.php'); ?>