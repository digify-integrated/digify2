<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">File Extension Form</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button type="submit" form="file-extension-form" class="btn btn-success mb-0" id="submit-data">Save</button>
                    <button type="button" id="discard-create" class="btn btn-outline-danger mb-0">Discard</button>
                </div>
            </div>
            <div class="card-body">
                <form id="file-extension-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="file_extension_name">Display Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="file_extension_name" name="file_extension_name" maxlength="100" autocomplete="off">
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="mb-3">
                                <label class="form-label" for="file_extension">File Extension <span class="text-danger">*</span></label>
                                <input type="text" class="form-control maxlength" id="file_extension" name="file_extension" maxlength="10" autocomplete="off">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <label class="form-label" for="file_type">File Type <span class="text-danger">*</span></label>
                            <div class="mb-3">
                                <select id="file_type" name="file_type" class="select2 form-control"></select>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>