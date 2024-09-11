<div class="row">
    <div class="col-12">
        <form id="booking-form" method="post" action="#">
            <div class="card mb-0">
                <div class="form-horizontal">
                    <div class="card-body d-flex align-items-center">
                        <h5 class="card-title mb-0">Customer Details</h5>
                        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                            <button type="submit" form="booking-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                            <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                        </div>
                    </div>
                    <hr class="m-0" />
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="first_name">First Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control maxlength" id="first_name" name="first_name" maxlength="500" autocomplete="off">
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="last_name">Last Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control maxlength" id="last_name" name="last_name" maxlength="500" autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="mb-3">
                                    <label class="form-label" for="address">Address <span class="text-danger">*</span></label>
                                    <textarea class="form-control maxlength" id="address" name="address" maxlength="5000" rows="5"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="phone">Phone <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control maxlength" id="phone" name="phone" maxlength="50" autocomplete="off">
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="mb-3">
                                    <label class="form-label" for="email_address">Email Address <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control maxlength" id="email_address" name="email_address" maxlength="500" autocomplete="off">
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
                                    <select class="form-control" id="source_of_booking" name="source_of_booking">
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
                                    <select class="form-control" id="service" name="service">
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
                                    <select class="form-control" id="frequency" name="frequency">
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
                                    <select class="form-control" id="duration" name="duration">
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
                                    <input class="form-control" name="number_of_seats" id="number_of_seats" type="number" min="1" step="1">
                                </div>
                            </div>
                        </div>
                        <div class="row d-none" id="sevices-group-3">
                            <div class="col-lg-12">
                                <div class="mb-3">
                                    <label class="form-label" for="meters">Meters <span class="text-danger">*</span></label>
                                    <input class="form-control" name="meters" id="meters" type="number" min="1" step="1">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="cleaning_materials">Need cleaning materials? <span class="text-danger">*</span></label>
                                    <select class="form-control" id="cleaning_materials" name="cleaning_materials">
                                        <option value="No">No</option>
                                        <option value="Yes">Yes</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="booking_date">Date <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <input type="text" class="form-control current-datepicker" id="booking_date" name="booking_date" autocomplete="off"/>
                                        <span class="input-group-text">
                                            <i class="ti ti-calendar fs-5"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="booking_time">Time <span class="text-danger">*</span></label>
                                    <select class="form-control" id="booking_time" name="booking_time">
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
                                    <select class="form-control" id="number_of_professionals" name="number_of_professionals">
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
                                    <select class="form-control" id="number_of_hours" name="number_of_hours">
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
                                    <select class="form-control" id="nationality" name="nationality">
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
                                    <label class="form-label" for="special_instructions">Do you have any special instructions <span class="text-danger">*</span></label>
                                    <textarea class="form-control maxlength" id="special_instructions" name="special_instructions" maxlength="5000" rows="5"></textarea>
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
                                    <select class="form-control" id="mode_of_payment" name="mode_of_payment">
                                        <option value="">--</option>
                                        <option value="Online Banking">Online Banking</option>
                                        <option value="Cash">Cash</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="discount_type">Discount Type</label>
                                    <select id="discount_type" name="discount_type" class="select2 form-control">
                                        <option value="">--</option>
                                        <option value="By Percentage">By Percentage</option>
                                        <option value="Fix Amount">Fix Amount</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="mb-3">
                                    <label class="form-label" for="discount_amount">Discount Amount</label>
                                    <input type="number" class="form-control" id="discount_amount" name="discount_amount" min="0" value="0" step="0.1">
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