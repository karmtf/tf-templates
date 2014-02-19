<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageInventory"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%
	Map<Date, PackageInventory> inventoryDateMap = (Map<Date, PackageInventory>) request.getAttribute(Attributes.PACKAGE_INVENTORY.toString());
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	List<Date> calendarMonths = PackageDataManager.getCalendarMonthsForInventory(inventoryDateMap);

	Date today = DateUtility.getDateForToday(true, false, false);
	Date currentMonth = DateUtility.setFieldValue(today, Calendar.DATE, 1);
%>
<style type="text/css">
.tab-content table td {height:45px;padding:0;background:#e1e1e1;}
.tab-content table td.available {background:#acdba8;}
.calTb div {font-size:12px;padding:0 5px}
</style>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.holiday.data.PackageDataManager"%>
<div class="mrgnT">
	<div class="yui-gb" style="margin-bottom:1em;">
		<div class="yui-u first">
			<div class="u_floatL"><a href="#" onclick="INVCAL.changeMonth(-1); return false;" id="invMonthPrv" class="grBtn1 gsSmBtn1">&laquo; Previous Month</a>&nbsp;</div>
			<div class="u_floatR"><a href="#" onclick="INVCAL.changeMonth(1); return false;" id="invMonthNxt" class="grBtn1 gsSmBtn1">Next Month &raquo;</a></div>			
			<div class="clearfix"></div>
		</div>
		<div class="yui-u"><div class="u_alignC dkC" style="font-size:13px"><b><span id="invMonthDisplay"><%=ThreadSafeUtil.getMMMMMYYYYDateFormat(false, false).format(today)%></span></b></div></div>
	</div>
	<%
		boolean firstMonth = true;
		for (Date calendarMonth: calendarMonths) {
		    Calendar startCal = Calendar.getInstance();
		    startCal.setTime(calendarMonth);
	%>
	<div id="invCalMth<%=startCal.get(Calendar.MONTH)%><%=startCal.get(Calendar.YEAR)%>" style="<%=firstMonth ? "": "display:none;"%>">
		<table width="100%" class="calTb">
			<tr>
				<th align=center width="14%"><B>Sun</B></th>
				<th align=center width="14%"><B>Mon</B></th>
				<th align=center width="14%"><B>Tue</B></th>
				<th align=center width="14%"><B>Wed</B></th>
				<th align=center width="14%"><B>Thu</B></th>
				<th align=center width="14%"><B>Fri</B></th>
				<th align=center width="14%"><B>Sat</B></th>
			</tr>
			<%
				Integer[][] calendarWeekwise = DateUtility.getWeekwiseCalendar(startCal.getTime());
				for (int i=0; i<calendarWeekwise.length; i++) {
			%>
			<tr>
			<%
				for (int j=0; j<calendarWeekwise[i].length; j++) {
					Integer day = calendarWeekwise[i][j];
			%>
				<%
					if (day != null) { 
						startCal.set(Calendar.DATE, day);
						PackageInventory pkgInventory = inventoryDateMap.get(startCal.getTime());
						boolean isToday = DateUtils.isSameDay(today, startCal.getTime());
						int avail = -1;
						if(pkgInventory != null) {
							avail = pkgInventory.getAllocated() - pkgInventory.getBooked();
						}
				%>
					<td class="<%=(pkgInventory != null && avail > 0) ? "available": ""%>">
						<div class="dayN"><%=ThreadSafeUtil.getDDEEEDateFormat(false, false).format(startCal.getTime())%></div>
						<% if (pkgInventory != null && avail > 0) { %>
							<div><b><%=avail%> available</b></div>
						<% } else if (pkgInventory != null && avail == 0) { %>
							<div style="color:red;font-size:11px"><b>Sold out</b></div>
						<% } %>
					</td>
				<% } else { if (i > 0 && j == 0) {break;} %>
					<td></td>
				<% } %>
				<% } %>
				</tr>
			<% } %>
		</table>
	</div>
	<% firstMonth = false;} %>
</div>
<script type="text/javascript">
function selectDate(date) {
	$jQ('#optionalsClk').click();	
	$jQ('#travelDate').val(date);
}
$jQ(document).ready(function() {
	INVCAL.togglePrvNxt();
});
var INVCAL = new function() {
	var selMonth = new Date(<%=currentMonth.getTime()%>);
	this.changeMonth = function(mthDf) {
		$jQ('#invCalMth' + getMonthKey(selMonth)).hide();
		selMonth.setMonth(selMonth.getMonth() + mthDf);
		$jQ('#invMonthDisplay').html(getMonthDisplay(selMonth));
		$jQ('#invCalMth' + getMonthKey(selMonth)).show();
		this.togglePrvNxt();
	}
	this.togglePrvNxt = function() {
		var nxtM = new Date(selMonth); var prvM = new Date(selMonth);
		nxtM.setMonth(nxtM.getMonth() + 1); prvM.setMonth(prvM.getMonth() - 1);
		$jQ('#invMonthNxt').toggle(($jQ('#invCalMth' + getMonthKey(nxtM)).length > 0));
		$jQ('#invMonthPrv').toggle(($jQ('#invCalMth' + getMonthKey(prvM)).length > 0));
	}
	var getMonthKey = function(mth) {
		return mth.getMonth() + "" + mth.getFullYear();
	}
	var getMonthDisplay = function(mth) {
		return DATE_CONSTANTS.MONTHS_LONG[mth.getMonth()] + ", " + mth.getFullYear();
	}
}
</script>