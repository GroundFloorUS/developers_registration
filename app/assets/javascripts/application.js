// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_self

function validate_developer_profile() {
	$("#developer_profile_total_debt_plus_equity").val($("#input-total-debt > button.active").val());
	$("#developer_profile_experience").val($("#input-experience > button.active").val());
	$("#developer_profile_employment").val($("#input-employment > button.active").val());
	$("#developer_profile_yearly_projects").val($("#input-yearly-projects > button.active").val());
	return true;
}

function validate_project() {
	$("#project_amount_to_raise").val($("#input-amount-to-raise > button.active").val());
	$("#project_capital_type").val($("#input-captial-type > button.active").val());
	$("#project_loan_to_value").val($("#input-loan-to-value > button.active").val());
	$("#project_close_timeline").val($("#input-close-timeline > button.active").val());
	return true;
}