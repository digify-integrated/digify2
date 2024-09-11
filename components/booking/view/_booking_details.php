<?php
    require('components/booking/model/booking-model.php');

    $bookingModel = new BookingModel($databaseModel);

    $tagBookingAsInProgress = $globalModel->checkSystemActionAccessRights($userID, 33);
    $tagBookingAsComplete = $globalModel->checkSystemActionAccessRights($userID, 34);
    $tagBookingForCancellation = $globalModel->checkSystemActionAccessRights($userID, 35);
    $tagBookingAsCancelled = $globalModel->checkSystemActionAccessRights($userID, 36);
    $tagBookingPaymentAsPaid = $globalModel->checkSystemActionAccessRights($userID, 37);
    $tagBookingPaymentAsRefunded = $globalModel->checkSystemActionAccessRights($userID, 38);

    if(isset($_GET['id'])){
        $bookingDetails = $bookingModel->getBooking($detailID, null);
        $bookingStatus = $bookingDetails['booking_status'];
        $paymentStatus = $bookingDetails['payment_status'];

        $disabled = '';
        if($bookingStatus != 'Pending'){
            $disabled = 'disabled';
        }
    }
?>
<div class="row">
    <div class="col-12">
        <form id="booking-form" method="post" action="#">
            <div class="card">
                <div class="form-horizontal">
                    <div class="card-body d-flex align-items-center">
                        <h5 class="card-title mb-0">Customer Details</h5>
                        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                            <button type="button" class="btn btn-dark dropdown-toggle mb-0" data-bs-toggle="dropdown" aria-expanded="false">Action</button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <?php
                                    echo $createAccess['total'] > 0 ? '<li><a class="dropdown-item" href="'. $pageLink .'&new">Create Booking</a></li>' : '';

                                    if($bookingStatus == 'Pending' && $tagBookingAsInProgress['total'] > 0){
                                        echo '<li><button class="dropdown-item" type="button" id="tag-as-in-progress">Tag As In-Progress</button></li>';
                                    }

                                    if($bookingStatus == 'In-Progress' && $tagBookingAsComplete['total'] > 0){
                                        echo '<li><button class="dropdown-item" type="button" id="tag-as-completed">Tag As Completed</button></li>';
                                    }

                                    if($bookingStatus == 'Pending' && $tagBookingForCancellation['total'] > 0){
                                        echo '<li><button class="dropdown-item" type="button" data-bs-toggle="modal" data-bs-target="#tag-for-cancellation-modal">Tag For Cancellation</button></li>';
                                    }

                                    if($bookingStatus == 'For Cancellation' && $tagBookingAsCancelled['total'] > 0){
                                        echo '<li><button class="dropdown-item" type="button" id="tag-as-cancelled">Tag As Cancelled</button></li>';
                                    }

                                    if($paymentStatus == 'Pending' && $tagBookingPaymentAsPaid['total'] > 0){
                                        echo '<li><button class="dropdown-item" type="button" data-bs-toggle="modal" data-bs-target="#tag-as-paid-modal">Tag As Paid</button></li>';
                                    }

                                    if($paymentStatus == 'Paid' && $tagBookingPaymentAsRefunded['total'] > 0){
                                        echo '<li><button class="dropdown-item" type="button" data-bs-toggle="modal" data-bs-target="#tag-as-refunded-modal">Tag As Refunded</button></li>';
                                    }

                                    echo $deleteAccess['total'] > 0 ? '<li><button class="dropdown-item" type="button" id="delete-booking">Delete Booking</button></li>' : '';
                                ?>
                            </ul>
                        </div>
                        <?php
                            echo $writeAccess['total'] > 0 && $bookingStatus == 'Pending' ? '<div class="card-actions cursor-pointer ms-auto d-flex button-group">
                                                                    <button type="submit" form="booking-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                                                                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                                                                </div>' : '';
                        ?>
                    </div>
                    <hr class="m-0" />
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="first_name">First Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="500" autocomplete="off" <?php echo $disabled; ?>>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="last_name">Last Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="500" autocomplete="off" <?php echo $disabled; ?>>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="mb-3">
                                    <label class="form-label" for="address">Address <span class="text-danger">*</span></label>
                                    <textarea class="form-control maxlength" id="address" name="address" maxlength="5000" rows="5" <?php echo $disabled; ?>></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="phone">Phone <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control maxlength" id="phone" name="phone" maxlength="50" autocomplete="off" <?php echo $disabled; ?>>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="email_address">Email Address <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control maxlength" id="email_address" name="email_address" maxlength="500" autocomplete="off" <?php echo $disabled; ?>>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr class="m-0" />
                    <div class="card-body d-flex align-items-center">
                        <h5 class="card-title mb-0">Booking Details</h5>
                    </div>
                    <hr class="m-0" />
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="source_of_booking">Source of Booking <span class="text-danger">*</span></label>
                                    <select class="form-control" id="source_of_booking" name="source_of_booking" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <optgroup label="Online Sources">
                                            <option value="Website">Website</option>
                                            <option value="Facebook">Facebook</option>
                                            <option value="Youtube">Youtube</option>
                                            <option value="Instagram">Instagram</option>
                                            <option value="Tiktok">Tiktok</option>
                                            <option value="Whatsapp">Whatsapp</option>
                                            <option value="Email">Email</option>
                                        </optgroup>
                                        <optgroup label="Offline Sources">
                                            <option value="Phone Call">Phone Call</option>
                                            <option value="Walk-in">Walk-in</option>
                                            <option value="Referrals">Referrals</option>
                                            <option value="Word of mouth">Word of mouth</option>
                                        </optgroup>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="service">Service <span class="text-danger">*</span></label>
                                    <select class="form-control" id="service" name="service" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="Deep Cleaning">Deep Cleaning</option>
                                        <option value="Regular Cleaning">Regular Cleaning</option>
                                        <option value="Office Cleaning">Office Cleaning</option>
                                        <option value="Flat Cleaning">Flat Cleaning</option>
                                        <option value="Hospital Cleaning">Hospital Cleaning</option>
                                        <option value="Sofa Cleaning">Sofa Cleaning</option>
                                        <option value="Mattress Cleaning">Mattress Cleaning</option>
                                        <option value="Curtain Cleaning">Curtain Cleaning</option>
                                        <option value="Carpet Cleaning">Carpet Cleaning</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row d-none" id="sevices-group-1">
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="frequency">Frequency <span class="text-danger">*</span></label>
                                    <select class="form-control" id="frequency" name="frequency" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="One Time">One Time</option>
                                        <option value="Weekly">Weekly</option>
                                        <option value="Monthly">Monthly</option>
                                        <option value="Yearly">Yearly</option>
                                        <option value="Every Other Week">Every Other Week</option>
                                        <option value="Every 4 Weeks">Every 4 Weeks</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="duration">Duration <span class="text-danger">*</span></label>
                                    <select class="form-control" id="duration" name="duration" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="1">1 Hour</option>
                                        <option value="2">2 Hours</option>
                                        <option value="3">3 Hours</option>
                                        <option value="4">4 Hours</option>
                                        <option value="5">5 Hours</option>
                                        <option value="6">6 Hours</option>
                                        <option value="7">7 Hours</option>
                                        <option value="8">8 Hours</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row d-none" id="sevices-group-2">
                            <div class="col-lg-12">
                                <div class="mb-3">
                                    <label class="form-label" for="number_of_seats">Number of Seats <span class="text-danger">*</span></label>
                                    <input class="form-control" name="number_of_seats" id="number_of_seats" type="number" min="1" step="1" <?php echo $disabled; ?>>
                                </div>
                            </div>
                        </div>
                        <div class="row d-none" id="sevices-group-3">
                            <div class="col-lg-12">
                                <div class="mb-3">
                                    <label class="form-label" for="meters">Meters <span class="text-danger">*</span></label>
                                    <input class="form-control" name="meters" id="meters" type="number" min="1" step="1" <?php echo $disabled; ?>>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="cleaning_materials">Need cleaning materials? <span class="text-danger">*</span></label>
                                    <select class="form-control" id="cleaning_materials" name="cleaning_materials" <?php echo $disabled; ?>>
                                        <option value="No">No</option>
                                        <option value="Yes">Yes</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="booking_date">Date <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="text" class="form-control current-datepicker" id="booking_date" name="booking_date" autocomplete="off" <?php echo $disabled; ?>/>
                                        <span class="input-group-text">
                                            <i class="ti ti-calendar fs-5"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="booking_time">Time <span class="text-danger">*</span></label>
                                    <select class="form-control" id="booking_time" name="booking_time" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="9:00 AM">9:00 AM</option>
                                        <option value="10:00 AM">10:00 AM</option>
                                        <option value="12:00 PM">12:00 PM</option>
                                        <option value="1:00 PM">1:00 PM</option>
                                        <option value="2:00 PM">2:00 PM</option>
                                        <option value="3:00 PM">3:00 PM</option>
                                        <option value="4:00 PM">4:00 PM</option>
                                        <option value="5:00 PM">5:00 PM</option>
                                        <option value="6:00 PM">6:00 PM</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="number_of_professionals">How many professionals do you need? <span class="text-danger">*</span></label>
                                    <select class="form-control" id="number_of_professionals" name="number_of_professionals" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                        <option value="6">6</option>
                                        <option value="7">7</option>
                                        <option value="8">8</option>
                                        <option value="9">9</option>
                                        <option value="10">10</option>
                                        <option value="11">11</option>
                                        <option value="12">12</option>
                                        <option value="13">13</option>
                                        <option value="14">14</option>
                                        <option value="15">15</option>
                                        <option value="16">16</option>
                                        <option value="17">17</option>
                                        <option value="18">18</option>
                                        <option value="19">19</option>
                                        <option value="20">20</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="number_of_hours">How many hours should they stay? <span class="text-danger">*</span></label>
                                    <select class="form-control" id="number_of_hours" name="number_of_hours" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="1">1 Hour</option>
                                        <option value="2">2 Hours</option>
                                        <option value="3">3 Hours</option>
                                        <option value="4">4 Hours</option>
                                        <option value="5">5 Hours</option>
                                        <option value="6">6 Hours</option>
                                        <option value="7">7 Hours</option>
                                        <option value="8">8 Hours</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="nationality">Choose your professional nationality <span class="text-danger">*</span></label>
                                    <select class="form-control" id="nationality" name="nationality" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="African">African</option>
                                        <option value="Filipino">Filipino</option>
                                        <option value="Nepali">Nepali</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="mb-0">
                                    <label class="form-label" for="special_instructions">Do you have any special instructions</label>
                                    <textarea class="form-control maxlength" id="special_instructions" name="special_instructions" maxlength="5000" rows="5" <?php echo $disabled; ?>></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr class="m-0" />
                    <div class="card-body d-flex align-items-center">
                        <h5 class="card-title mb-0">Payment Details</h5>
                    </div>
                    <hr class="m-0" />
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="mode_of_payment">Mode of Payment <span class="text-danger">*</span></label>
                                    <select class="form-control" id="mode_of_payment" name="mode_of_payment" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="Online Banking">Online Banking</option>
                                        <option value="Stripe">Stripe</option>
                                        <option value="Cash">Cash</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="discount_type">Discount Type</label>
                                    <select id="discount_type" name="discount_type" class="select2 form-control" <?php echo $disabled; ?>>
                                        <option value="">--</option>
                                        <option value="By Percentage">By Percentage</option>
                                        <option value="Fix Amount">Fix Amount</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="discount_amount">Discount Amount</label>
                                    <input type="number" class="form-control" id="discount_amount" name="discount_amount" min="0" value="0" step="0.1" <?php echo $disabled; ?>>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr class="m-0" />
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-9">
                                <div class="mb-3">
                                    <p class="mb-0 fs-4 text-end">Booking Subtotal</p>
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <div class="mb-3">
                                    <input type="hidden" id="booking_subtotal" name="booking_subtotal">
                                    <h6 class="mb-0 fs-4 fw-semibold text-end" id="booking-subtotal-summary">AED 0.00</h6>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-9">
                                <div class="mb-3">
                                    <p class="mb-0 fs-4 text-end">Discount Subtotal</p>
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <div class="mb-3">
                                    <input type="hidden" id="total_discount_amount" name="total_discount_amount">
                                    <h6 class="mb-0 fs-4 fw-semibold text-end" id="discount-subtotal-summary">AED 0.00</h6>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-9">
                                <div class="mb-3">
                                    <p class="mb-0 fs-4 text-end">Total</p>
                                </div>
                            </div>
                            <div class="col-lg-3">
                                <div class="mb-3">
                                <input type="hidden" id="booking_total" name="booking_total">
                                    <h6 class="mb-0 fs-4 fw-semibold text-end" id="booking-total-summary">AED 0.00</h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>        
    </div>
</div>

<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="form-horizontal">
                <hr class="m-0" />
                    <div class="card-body d-flex align-items-center">
                        <h5 class="card-title mb-0">Other Booking Details</h5>
                    </div>
                <hr class="m-0" />
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Booking Reference Number</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="booking-reference-number-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Payment Status</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="payment-status-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Booking Status</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="booking-status-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Transaction Date</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="transaction-date-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Payment Reference Number</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="payment-reference-number-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Payment Date</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="payment-date-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Discount Code</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="discount-code-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">In-Progress Date</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="in-progress-date-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Completed Date</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="completed-date-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Refund Amount</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="refund-amount-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Refund Date</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="refund-date-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Refund Reason</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="refund-reason-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Cancellation Window</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="cancellation-window-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Cancellation Request Date</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="cancellation-request-date-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Cancellation Date</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="cancellation-date-summary">--</h6>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="mb-3">
                                        <p class="mb-0 fs-3">Cancellation Reason</p>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="mb-3">
                                        <h6 class="mb-0 fs-3 fw-semibold" id="cancellation-reason-summary">--</h6>
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

<div id="tag-for-cancellation-modal" class="modal fade" tabindex="-1" aria-labelledby="tag-for-cancellation-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Tag For Cancellation</h5>
                <button type="button" class="btn-close fs-3" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="tag-for-cancellation-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label class="form-label" for="cancellation_reason">Cancellation Reason <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="cancellation_reason" name="cancellation_reason" maxlength="5000" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="tag-for-cancellation-form" class="btn btn-success" id="submit-tag-for-cancellation-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="tag-as-paid-modal" class="modal fade" tabindex="-1" aria-labelledby="tag-as-paid-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Tag As Paid</h5>
                <button type="button" class="btn-close fs-3" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="tag-as-paid-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="payment_date">Payment Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="payment_date" name="payment_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label class="form-label" for="payment_reference_number">Payment Reference Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="payment_reference_number" name="payment_reference_number" maxlength="500" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="tag-as-paid-form" class="btn btn-success" id="submit-tag-as-paid-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<div id="tag-as-refunded-modal" class="modal fade" tabindex="-1" aria-labelledby="tag-as-refunded-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-r">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Tag As Refunded</h5>
                <button type="button" class="btn-close fs-3" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="tag-as-refunded-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="refund_amount">Refund Amount <span class="text-danger">*</span></label>
                                <input class="form-control" name="refund_amount" id="refund_amount" type="number" min="0.01" step="0.01">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="refund_date">Refund Date <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" class="form-control regular-datepicker" id="refund_date" name="refund_date" autocomplete="off"/>
                                    <span class="input-group-text">
                                        <i class="ti ti-calendar fs-5"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-0">
                                <label class="form-label" for="refund_reason">Refund Reason <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="refund_reason" name="refund_reason" maxlength="5000" rows="5"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="tag-as-refunded-form" class="btn btn-success" id="submit-tag-as-refunded-data">Save changes</button>
            </div>
        </div>
    </div>
</div>

<?php require_once('components/global/view/_internal_log_notes.php'); ?>