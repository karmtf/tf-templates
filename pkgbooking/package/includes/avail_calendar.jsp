<%@page import="java.util.Date"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.poc.server.trip.TripCartBean"%>
<%
	Date startDate = TripCartBean.getRequestStartDate(request);
	Date endDate = TripCartBean.getRequestEndDate(request);
%>
<script type="text/javascript">
var AVAIL_HCAL = new function() {
	this.init = function() {
		this.form = document["hotelSearchForm"];
		var onDtSelect = function(pkr) {
			var fromDate = pkr.getSelectedDates()[0] || null;
			var toDate =  pkr.getSelectedDates(true)[0] || null;
			if (fromDate && (fromDate>toDate || !toDate)) {
				document.hotelSearchForm.hdate2.value = JS_UTIL.getSearchDisplayDate(JS_UTIL.addDaysToDate(fromDate, 1, true));
			}
		};
		var dtPicker = new DatePick({fromInp:this.form.hdate, toInp:this.form.hdate2, fCalO: {onSelectCB: onDtSelect }});
		var dt1 = <% if (startDate != null) { %>'<%=ThreadSafeUtil.getDateFormat(false, false).format(startDate)%>';<% } else { %>JS_UTIL.addDays(getCurrentDate(), 1);<% } %>
		if (!document.hotelSearchForm.hdate.value || document.hotelSearchForm.hdate.value == 'dd/mm/yyyy' || JS_UTIL.compareDates(document.hotelSearchForm.hdate.value, dt1) < 0) {
				document.hotelSearchForm.hdate.value = dt1;
		}
		if (!document.hotelSearchForm.hdate2.value || document.hotelSearchForm.hdate2.value == 'dd/mm/yyyy' || JS_UTIL.compareDates(document.hotelSearchForm.hdate.value, document.hotelSearchForm.hdate2.value) > 0) {
		   document.hotelSearchForm.hdate2.value = <% if (endDate != null) { %>'<%=ThreadSafeUtil.getDateFormat(false, false).format(endDate)%>';<% } else { %>JS_UTIL.addDays(document.hotelSearchForm.hdate.value, 1);<% } %>
		}
	}
};
$jQ(document).ready(function() {
	AVAIL_HCAL.init();
});

function validateHotelForm(action) {
  var date1 = document.hotelSearchForm.hdate.value;
  var date2 = document.hotelSearchForm.hdate2.value;
  if (!date1 || date1 == '') {
    alert('Please select valid Check-In Date (in the format dd/mm/yyyy) before proceeding.');
    document.hotelSearchForm.hdate.focus();
    return;
  }
  if (JS_UTIL.compareDates(date1, getCurrentDate()) < 0) {
    alert('Check-In date has already passed away. Modify Check-In date to proceeding.');
    document.hotelSearchForm.hdate.focus();
    return;
  }
  
  if (!date2 || date2 == '') {
    alert('Please select valid Check-Out Date (in the format dd/mm/yyyy) before proceeding.');
    document.hotelSearchForm.hdate2.focus();
    return;
  }
  if (JS_UTIL.compareDates(date2, date1) < 0) {
    alert('Check-Out date must to be after Check-In date. Modify Dates before proceeding.');
    document.hotelSearchForm.hdate2.focus();
    return;
  }
  // The check in and check out dates cannot be the same
  if (date2 == date1) {
    alert('The check in and check out dates cannot be the same. Modify Dates before proceeding.');
    document.hotelSearchForm.hdate2.focus();
    return;
  }  	  
  $jQ(document.holidaySearchForm.hdate).val($jQ(document.hotelSearchForm.hdate).val());
  $jQ(document.holidaySearchForm.hdate2).val($jQ(document.hotelSearchForm.hdate2).val());
  document.holidaySearchForm.submit();
}
</script>
<form action="" method="GET" class="via_form" name="hotelSearchForm">
<div style="width:100%;margin-bottom:10px;padding-bottom:10px" class="fltrC">
<h3>Check Availability</h3>
<table width="93%" class=defaultText style="padding-left:0;" cellSpacing=2 cellPadding=3 border=0>	
<tr>
	<td width="35%" style="padding:10px;">
		<div>
			<div class='srchLabel u_floatL' style="margin-top:4px">
				Check-in
			</div>
			<div class="u_floatL" style="margin-left:15px">
				<input type="text" name="hdate" readonly="readonly" class="calInput" style="padding:2px;">
			</div>
		</div>
	</td>
</tr>
<tr>
	<td width="35%" style="padding:10px;">
		<div>
			<div class='srchLabel u_floatL' style="margin-top:4px">
				Check-out
			</div>
			<div class="u_floatL" style="margin-left:9px">
				<input type="text" name="hdate2" readonly="readonly" class="calInput" style="padding:2px;">
			</div>
		</div>
	</td>
</tr>
<tr>
	<td style="padding:10px" align="right">
		<div class="u_floatR">
			<a href="#" class="grBtn1" onclick="validateHotelForm('THSRH')" name="searchHotels" type="button">Check Availability</a>
		</div>
		<div style="clear: both;"></div>
	</td>		
</tr>
</table>
</div>
<div id="calContainer" style="position:absolute;z-index:1;width:180px"></div>
</form>
 