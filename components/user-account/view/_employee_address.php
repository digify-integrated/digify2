<div class="card mb-0">
  <div class="form-horizontal">
    <div class="form-body">
      <div class="card-body d-flex align-items-center">
        <h5 class="card-title mb-0">My Addresses</h5>
        <div class="card-actions cursor-pointer ms-auto d-flex button-group">
        <?php
          echo $createAccess['total'] > 0 ? '<a href="javascript:void(0)" class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#address-modal" id="add-address-details"><i class="ti ti-plus fs-3"></i> Add New Address</a>' : '';
        ?>
        </div>
      </div>
      <hr class="m-0" />
      <input type="hidden" id="linked_id" value="<?php echo $_SESSION['linked_id']; ?>">
      <div class="card-body" id="address-container"></div>
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