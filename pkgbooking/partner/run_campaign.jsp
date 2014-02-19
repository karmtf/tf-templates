<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.constants.AvailabilityType"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<Destination> countries = DestinationContentManager.getAllDestinations(DestinationType.COUNTRY);
	List<PackageTag> tags = PackageTag.getImportantList();
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	CurrencyType currencyType = CurrencyType.AMERICAN_DOLLAR;
%>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<style type="text/css">
.row-fluid .span2 {width: 12%;}
</style>
<script>
function initialize() {
	$jQ(".promotion-btn button").click(function(e) {
		e.preventDefault();
//		var $newCampaign = $jQ("<div />").load('loader.html #newCampaign', function(){
		var $newCampaign = $jQ($jQ("#modalLoaders").text());
			$newCampaign.appendTo("body");
			$newCampaign.find(".select").select2();
			$newCampaign.find(".styled").uniform({ radioClass: 'choice' });
			$newCampaign.find(".datepicker").datepicker({
				defaultDate: +7,
				showOtherMonths:true,
				autoSize: true,
				appendText:'',
				dateFormat:'dd-mm-yy'
			});
			$newCampaign.find("#myModal").modal({
				backdrop: 'static',
				keyboard: true
			});
			$jQ("body").addClass("noScroll");
/*
			$newCampaign.find("#myModal").on('show', function () {
					// do something…
				$jQ("div.modal-backdrop").click(function(){
    			$jQ("#myModal").modal('hide');
				});
			})
*/
			$newCampaign.find("#myModal").on('hidden', function () {
					// do something…
				$jQ("#newCampaign").remove();
				$jQ("body").removeClass("noScroll");
			})
//		});
	});
}
</script>
<script id="modalLoaders" type="text/plain">
<div id="newCampaign">
  <div id="myModal" class="modal hide fade">
    <form id="campaignForm" action="/partner/save-recommendation" class="rel form-horizontal" method="post">
	  <input type=hidden name="hotelid" value="<%=hotel.getId()%>" />
      <div class="widget">
				<div class="navbar">
					<div class="navbar-inner">
						<h6>Target New Customers</h6>
					</div>
				</div>
		        <div class="well">
					<h4 class="statement-title" style="margin-top:15px">When the customer is:</h4>
					<div class="statement-group" style="margin-bottom:10px">	
						<div class="control-group">
							<label class="control-label">From:</label>
							<div class="controls">
								<select data-placeholder="Any of these regions" name="regions" class="select" id="form-from" multiple="multiple" tabindex="0">
									<%
										for(Destination dest : countries) { 
									%>
									<option value="<%=dest.getId()%>"><%=dest.getName()%></option>
									<% } %>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Traveling Dates:</label>
							<div class="controls">
								<ul class="dates-range">
									<li><input type="text" placeholder="Start Travel Date" id="date" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"></span></li>
									<li class="sep">-</li>
									<li><input type="text" placeholder="End Travel Date" id="date2" name="toDate" class="datepicker" size="10"><span class="ui-datepicker-append"></li>
								</ul>
							</div>
						</div>						
						<div class="control-group">
							<label class="control-label">Visiting For:</label>
							<div class="controls">
								<select data-placeholder="Any of these purposes" name="purpose"  class="select" multiple="multiple" tabindex="0">
									<% for(PackageTag tag : tags) { %>
									<option value="<%=tag.name()%>"><%=tag.getDisplayName()%></option>
									<% } %>
								</select>
							</div>
						</div>	
						<div class="control-group">
							<div class="u_floatL">
								<label class="control-label">Minimum stay:</label>
								<div class="controls">
										<select id="duration" name="duration" class="styled" tabindex="3">
											<option value="1">One Night</option>
											<option value="2">Two Nights</option>
											<option value="3">Three Nights</option>
											<option value="4">Four Nights</option>
											<option value="5">Five Nights</option>
											<option value="6">Six Nights</option>
											<option value="7">One Week</option>
											<option value="14">Two Weeks</option>
										</select>
								</div>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<label class="control-label">Looking for:</label>
								<div class="controls">
									<select id="rateType" name="rateType" class="styled" tabindex="4">
										<option value="<%=AvailabilityType.AVAILABLE.name()%>">Hotel Only</option>
										<option value="<%=AvailabilityType.PACKAGED.name()%>">Packages</option>
										<option value="<%=AvailabilityType.AVAILABLE.name()%>">Both</option>
									</select>
								</div>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<label class="control-label">Traveling on:</label>
								<div class="controls">
									<select id="applicableDays" name="applicableDays" class="styled" tabindex="5">
										<option value="F|S|S">Weekends</option>
										<option value="M|T|W|T">Weekdays</option>
										<option value="M|T|W|T|F|S|S">Any day</option>
									</select>
								</div>
							</div>
							<div class="u_clear"></div>
						</div>
						<div class="control-group">
							<div class="u_floatL">
								<label class="control-label">Booking within:</label>
								<div class="controls">
									<select id="bookingWithin" name="bookingWithin" class="styled" tabindex="6">
										<option value="-1">Any time</option>
										<option value="1">One day</option>
										<option value="2">Two days</option>
										<option value="3">Three days</option>
										<option value="4">Four days</option>
										<option value="5">Five days</option>
										<option value="7">One Week</option>
										<option value="14">Two Weeks</option>
										<option value="21">Three Weeks</option>
										<option value="28">Four Weeks</option>
									</select>
								</div>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<label class="control-label">Booking before:</label>
								<div class="controls">
									<select id="advanceDays" name="advanceDays" class="styled" tabindex="7">
										<option value="-1">Any time</option>
										<option value="1">One day</option>
										<option value="2">Two days</option>
										<option value="3">Three days</option>
										<option value="4">Four days</option>
										<option value="5">Five days</option>
										<option value="7">One Week</option>
										<option value="14">Two Weeks</option>
										<option value="21">Three Weeks</option>
										<option value="28">Four Weeks</option>
									</select>
								</div>
							</div>
							<div class="u_floatL" style="margin-left:10px">
								<label class="control-label">Check-in time:</label>
								<div class="controls">
									<select id="checkin" name="checkin" class="styled" tabindex="7">
										<option value="-1">Any time</option>
										<option value="MORNING">Morning</option>
										<option value="AFTERNOON">Afternoon</option>
										<option value="EVENING">Evening</option>
										<option value="NIGHT">Night</option>											
									</select>
								</div>
							</div>
							<div class="u_clear"></div>
						</div>
					</div>
					<h4 class="statement-title" style="margin-top:15px">Then recommend:</h4>
					<div class="statement-group">	
						<div class="control-group">
							<label class="control-label">Package:</label>
							<div class="controls">
									<select id="packageType" name="packageType" class="styled" tabindex="8">
										<% 
											for(SupplierPackage pkg : packages.values()) { 
												if(pkg.getName() == null || pkg.getName().equals("null")) {
													continue;
												}
										%>
										<option value="<%=pkg.getId()%>"><%=pkg.getName()%></option>
										<% } %>
									</select>
									<a href="/partner/room-packages?hotelid=<%=hotel.getId()%>" target="_blank" class="btn btn-success select-adjacent" style="margin-left:6px;">Add a New Package</a>
							</div>
						</div>																			
						<div class="control-group">
							<label class="control-label">Add Ancillaries:</label>
							<div class="controls">
								<select data-placeholder="Add some freebies" name="freebies" class="select" multiple="multiple" tabindex="9">
									<% 
										for (SellableUnitType  unitType: SellableUnitType.HOTEL_DEAL_OPTIONS)  { 
									%>
									<option value="<%=unitType.getDesc()%>">Free <%=unitType.getDesc()%></option>
									<% } %>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Offer Price:</label>
							<div class="controls">
								<div class="row-fluid">
									<div class="span2">
									  <select name="currency" id="currency" class="styled" tabindex="4" style="opacity: 0;">
											<% for (CurrencyType curr: CurrencyType.values()) { %>
												<option <%=curr == currencyType ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
											<% } %>
									  </select>
									</div>
									<div class="span2" style="margin-left:85px">
										<input type="text" class="spinner-currency span12" name="singleAdult" value="0" /><span class="help-block">Single Adult</span>
									</div>
									<div class="span2">
										<input type="text" class="spinner-currency span12" name="twinSharing" value="0" /><span class="help-block">Twin Sharing</span>
									</div>
									<div class="span2">
										<input type="text" class="spinner-currency span12" name="extraAdult" value="0" /><span class="help-block">Extra Adult</span>
									</div>
									<div class="span2">
										<input type="text" class="spinner-currency span12" name="cwb" value="0" /><span class="help-block">Child with Bed</span>
									</div>
									<div class="span2">
										<input type="text" class="spinner-currency span12" name="cob" value="0" /><span class="help-block">Child no Bed</span>
									</div>
								</div>
							</div>
						</div>
						<div class="form-actions align-right">
							<button type="submit" class="btn btn-primary">Submit</button>
							<button type="button" data-dismiss="modal" class="btn btn-danger">Cancel</button>
						</div>
					</div>
	        </div>
      </div>
    </form>
  </div>
</div>
</script>
