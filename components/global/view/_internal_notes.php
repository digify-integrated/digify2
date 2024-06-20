<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex align-items-center">
                <h5 class="card-title mb-0">Internal Notes</h5>
                <div class="card-actions cursor-pointer ms-auto d-flex button-group">
                    <button class="btn btn-warning d-flex align-items-center mb-0" data-bs-toggle="modal" data-bs-target="#internal-notes-modal" id="internal-notes-button">Internal Notes</button>
                </div>
            </div>
            <div class="card-body">
                <div class="position-relative" style="max-height: 500px; overflow: auto;" id="internal-notes"></div>
            </div>
        </div>
    </div>
</div>

<div id="internal-notes-modal" class="modal fade" tabindex="-1" aria-labelledby="internal-notes-modal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-8">Internal Notes</h5>
                <button type="button" class="btn-close fs-2" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="internal-notes-form" method="post" action="#">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="internal_note">Attachment</label>
                                <input type="file" class="form-control" name="internal_notes_files[]" multiple>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="mb-3">
                                <label class="form-label" for="internal_note">Internal Note <span class="text-danger">*</span></label>
                                <textarea class="form-control maxlength" id="internal_note" name="internal_note" maxlength="5000" rows="3"></textarea>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-danger" data-bs-dismiss="modal">Close</button>
                <button type="submit" form="internal-notes-form" class="btn btn-success" id="submit-internal-notes">Save changes</button>
            </div>
        </div>
    </div>
</div>