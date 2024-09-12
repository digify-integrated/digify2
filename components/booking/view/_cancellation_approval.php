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
                        <table id="cancellation-approval-table" class="table align-middle text-nowrap w-100 mb-0">
                            <thead class="text-dark">
                                <tr>
                                    <th class="all">
                                        <div class="form-check">
                                            <input class="form-check-input" id="datatable-checkbox" type="checkbox">
                                        </div>
                                    </th>
                                    <th>Booking Reference Number</th>
                                    <th>Client</th>
                                    <th>Service</th>
                                    <th>Booking Schedule</th>
                                    <th>Payment Status</th>
                                    <th>Booking Status</th>
                                    <th>Source of Booking</th>
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
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Service</h6>
            <div class="pb-4 px-4 text-dark" id="service-filter">
                <select class="form-control" id="filter_by_service" name="filter_by_service">
                    <option value="">All Service</option>
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
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Payment Status</h6>
            <div class="pb-4 px-4 text-dark" id="payment-status-filter">
                <select class="form-control" id="filter_by_payment_status" name="filter_by_payment_status">
                    <option value="">All Payment Status</option>
                    <option value="Pending">Pending</option>
                    <option value="Paid">Paid</option>
                    <option value="Refunded">Refunded</option>
                </select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Mode of Payment</h6>
            <div class="pb-4 px-4 text-dark" id="mode-of-payment-filter">
                <select class="form-control" id="filter_by_mode_of_payment" name="filter_by_mode_of_payment">
                    <option value="">All Mode of Payment</option>
                    <option value="Online Banking">Online Banking</option>
                    <option value="Stripe">Stripe</option>
                    <option value="Cash">Cash</option>
                </select>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Source of Booking</h6>
            <div class="pb-4 px-4 text-dark" id="source-of-booking-filter">
                <select class="form-control" id="filter_by_source_of_booking" name="filter_by_source_of_booking">
                <option value="">All Source of Booking</option>
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
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Booking Date</h6>
            <div class="pb-4 px-4 text-dark" id="booking-start-date-filter">
                <div class="input-group">
                    <input type="text" class="form-control regular-datepicker" id="booking_start_date" name="booking_start_date" placeholder="Start Date" autocomplete="off"/>
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
            <div class="pb-4 px-4 text-dark" id="booking-end-date-filter">
                <div class="input-group">
                    <input type="text" class="form-control regular-datepicker" id="booking_end_date" name="booking_end_date" placeholder="End Date" autocomplete="off"/>
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Transaction Date</h6>
            <div class="pb-4 px-4 text-dark" id="transaction-start-date-filter">
                <div class="input-group">
                    <input type="text" class="form-control regular-datepicker" id="transaction_start_date" name="transaction_start_date" placeholder="Start Date" autocomplete="off"/>
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
            <div class="pb-4 px-4 text-dark" id="transaction-end-date-filter">
                <div class="input-group">
                    <input type="text" class="form-control regular-datepicker" id="transaction_end_date" name="transaction_end_date" placeholder="End Date" autocomplete="off"/>
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
        </div>
        <div class="border-bottom rounded-0">
            <h6 class="mt-4 mb-3 mx-4 fw-semibold">By Payment Date</h6>
            <div class="pb-4 px-4 text-dark" id="payment-start-date-filter">
                <div class="input-group">
                    <input type="text" class="form-control regular-datepicker" id="payment_start_date" name="payment_start_date" placeholder="Start Date" autocomplete="off"/>
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
            <div class="pb-4 px-4 text-dark" id="payment-end-date-filter">
                <div class="input-group">
                    <input type="text" class="form-control regular-datepicker" id="payment_end_date" name="payment_end_date" placeholder="End Date" autocomplete="off"/>
                    <span class="input-group-text">
                        <i class="ti ti-calendar fs-5"></i>
                    </span>
                </div>
            </div>
        </div>
        <div class="p-4">
            <button type="button" class="btn btn-warning w-100" id="apply-filter">Apply Filter</button>
        </div>
    </div>
</div>