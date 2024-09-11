/* System Action Table */

CREATE TABLE system_action(
	system_action_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	system_action_name VARCHAR(100) NOT NULL,
	system_action_description VARCHAR(200) NOT NULL,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX system_action_index_system_action_id ON system_action(system_action_id);

INSERT INTO system_action (system_action_id, system_action_name, system_action_description, last_log_by) VALUES
(1, 'Update System Settings', 'Access to update the system settings.', 1),
(2, 'Update Security Settings', 'Access to update the security settings.', 1),
(3, 'Activate User Account', 'Access to activate the user account.', 1),
(4, 'Deactivate User Account', 'Access to deactivate the user account.', 1),
(5, 'Lock User Account', 'Access to lock the user account.', 1),
(6, 'Unlock User Account', 'Access to unlock the user account.', 1),
(7, 'Add Role User Account', 'Access to assign roles to user account.', 1),
(8, 'Delete Role User Account', 'Access to delete roles to user account.', 1),
(9, 'Add Role Access', 'Access to add role access.', 1),
(10, 'Update Role Access', 'Access to update role access.', 1),
(11, 'Delete Role Access', 'Access to delete role access.', 1),
(12, 'Add Role System Action Access', 'Access to add the role system action access.', 1),
(13, 'Update Role System Action Access', 'Access to update the role system action access.', 1),
(14, 'Delete Role System Action Access', 'Access to delete the role system action access.', 1),
(15, 'Add File Extension Access', 'Access to assign the file extension to the upload setting.', 1),
(16, 'Delete File Extension Access', 'Access to delete the file extension to the upload setting.', 1),
(17, 'Add Work Hours', 'Access to add the work hours.', 1),
(18, 'Update Work Hours', 'Access to update the work hours.', 1),
(19, 'Delete Work Hours', 'Access to delete the work hours.', 1),
(20, 'Archive Employee', 'Access to archive the employee.', 1),
(21, 'Unarchive Employee', 'Access to unarchive the employee.', 1),
(22, 'Archive Customer', 'Access to archive the customer.', 1),
(23, 'Unarchive Customer', 'Access to unarchive the customer.', 1),
(24, 'Send Registration Verification Link', 'Access to send the registration verification link to unverified users.', 1),
(25, 'Verify User Registration', 'Access to verify unverified users registration.', 1),
(26, 'Link User Account', 'Access to link the user account to an employee or customer.', 1),
(27, 'Unlink User Account', 'Access to unlink the user account to an employee or customer.', 1),
(28, 'Publish Website Element', 'Access to publish the website element.', 1),
(29, 'Unpublish Website Element', 'Access to unpublish the website element.', 1),
(30, 'Tag Customer Inquiry As In-Progress', 'Access to tag the customer inquiry as in-progress.', 1),
(31, 'Tag Customer Inquiry As Resolved', 'Access to tag the customer inquiry as resolved.', 1),
(32, 'Tag Customer Inquiry As Closed', 'Access to tag the customer inquiry as closed.', 1),
(33, 'Tag Booking As In-Progress', 'Access to tag the booking as in-progress.', 1),
(34, 'Tag Booking As Complete', 'Access to tag the booking as complete.', 1),
(35, 'Tag Booking As For Cancellation', 'Access to tag the booking for cancellation.', 1),
(36, 'Tag Booking As Cancelled', 'Access to tag the booking as cancelled.', 1),
(37, 'Tag Booking Payment As Paid', 'Access to tag the booking payment as paid.', 1),
(38, 'Tag Booking Payment As Refunded', 'Access to tag the booking payment as refunded.', 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */