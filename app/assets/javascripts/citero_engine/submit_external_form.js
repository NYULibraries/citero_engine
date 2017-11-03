// A simple function to allow us to automatically submit forms for 
// pushing to other services such as EasyBib and RefWorks.
jQuery(document).ready(function($) {
	submit_external_form();
	// Automatically submit the form.
	function submit_external_form() {
		// Hide the page
		$("body").hide();
		$form = $(".external_form");
		$form.trigger("submit");
	}
});