<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.constants.AvailabilityType"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
%>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<style type="text/css">
.row-fluid .span2 {width: 12%;}
</style>
<script>
function initialize() {
	$jQ("ellipse").dblclick(function(e) {
		e.preventDefault();
		var actJ = $jQ(e.currentTarget);
		var dealid = actJ.attr("id");
		var tokens = dealid.split("$");
		var $newCampaign = $jQ($jQ("#modalLoaders").text());
			$newCampaign.appendTo("body");
			$newCampaign.find(".select").select2();
			$newCampaign.find("#krid").val(dealid);
			$newCampaign.find("#ruleid").val(tokens[1]);
			$newCampaign.find(".styled").uniform({ radioClass: 'choice' });
			$newCampaign.find("#myModal").modal({
				backdrop: 'static',
				keyboard: true
			});
			$jQ("body").addClass("noScroll");
			$newCampaign.find("#myModal").on('hidden', function () {
					// do somethingÖ
				$jQ("#newCampaign").remove();
				$jQ("body").removeClass("noScroll");
			})
	});
}
</script>
<script id="modalLoaders" type="text/plain">
<div id="newCampaign">
  <div id="myModal" class="modal hide fade">
    <form id="deleteForm" action="/partner/delete-shoppingflow" class="rel form-horizontal" method="post">
	  <input type=hidden name="hotelid" value="<%=hotel.getId()%>" />
	  <input type=hidden name="id" id="ruleid" value="-1" />
      <div class="widget" style="margin-bottom:0">
			<div class="form-actions align-right">
				<button type="submit" class="btn btn-primary">Delete this node</button>
				<button type="button" data-dismiss="modal" class="btn btn-danger">Cancel</button>
			</div>
	  </div>	  
  	</form>
    <form id="campaignForm" action="/partner/save-newshoppingflow" class="rel form-horizontal" method="post">
	  <input type=hidden name="hotelid" value="<%=hotel.getId()%>" />
	  <input type=hidden name="krid" id="krid" value="" />
      <div class="widget">
			<div class="well">
				<h4 class="statement-title" style="margin-top:15px">What next do you want to recommend:</h4>
				<div class="statement-group" style="margin-bottom:10px">
					<div class="control-group">
						<label class="control-label">Sellable Services:</label>
						<div class="controls">
							<select data-placeholder="Add some freebies" name="freebies" class="select" multiple="multiple" tabindex="9">
								<% 
									for(SupplierPackagePricing retDeal: retDealsList) {
								%>
								<option value="<%=retDeal.getId()%>"><%=retDeal.getOptionTitle()%></option>
								<% } %>
							</select>
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
