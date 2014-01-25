<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@ page import='com.eos.b2c.ui.*,
				 com.eos.accounts.UserManagerFilter,
				 com.eos.accounts.data.User,
				 com.eos.gds.util.FareCalendar,
				 com.eos.b2c.ui.B2cContext,
				 java.text.SimpleDateFormat,
				 java.text.NumberFormat,
                 java.util.List,
                 java.util.Set,
                 java.util.Map,
                 java.util.TreeMap,
                 java.util.Date'
%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.poc.server.secondary.database.model.Review"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page session="true" %>
<%	
	String title = "Expert Reviews";
	String keywords = "";
	String description = "";
    long destId = RequestUtil.getLongRequestParameter(request, "destId", -1L);
	Map<Long, Map<Long, Review>> reviewsMap = (Map<Long, Map<Long, Review>>) request.getAttribute(Attributes.REVIEWS_WRAPPER.toString());
%>
<html>
<head>
<TITLE><%=title%></TITLE>
<!--  featured_search_results, /hotel/includes/featured_hotel_details -->
<meta name="keywords" content="<%=keywords%>" />
<meta name="description" content="<%=description%>" />
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body class="home page">
<div class="body-outer-wrapper">
	<div class="body-wrapper">
		<jsp:include page="/common/includes/viacom/header_new.jsp" />
		
		
		
		
		
		
		
		
		<div class="row-fluid">
  <div class="span12">
   <div class="container wrapper">
     <div class="span3 margin_left0">
      <div class="row-fluid header1">
    <div class="span12">
    <h1 style="color:#0088CC !important">Travel Tips  <a href="http://hammockholidays.com/main/package/World" data-hint="World" class="pull-right hint--top"><span class="globe_icon pull-right"></span></a> <a href="http://hammockholidays.com/main/package/Special" data-hint="Specials" class="pull-right hint--top"><span class="special_icon pull-right"></span></a></h1>    </div>
    </div>
    <div class="row-fluid">
              <div class="span12">
                <div class="caret"></div>
              </div>
            </div>
       
        
  <br><div class="row-fluid ui-accordion ui-widget ui-helper-reset" id="menu" role="tablist">
                          <div class="span12">
                          
                          
			

					<% 
							if(reviewsMap != null && !reviewsMap.isEmpty()) {
								for (Long dest : reviewsMap.keySet()) {	
									if(destId == -1L) {
										destId = dest;
									}								
					%>
						<a class="package_link ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-accordion-icons" href="/tours/reviews?destId=<%=dest%>" role="tab" id="ui-accordion-menu-header-0" aria-controls="ui-accordion-menu-panel-0"  tabindex="0"><span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
						<div><%=DestinationContentManager.getDestinationFromId(dest).getName()%></div><span class="menu_arrow"></span> </a>
						   <div class="collapse_scroller_holder ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom" id="ui-accordion-menu-panel-0" aria-labelledby="ui-accordion-menu-header-0" role="tabpanel" aria-expanded="false" aria-hidden="true" style="display: none;"> <div class="caret" style="margin-left:20px;"></div>
							<div id="content_3" class="sub_pakage_scroll content_3 mCustomScrollbar _mCS_1" style="overflow: hidden;"><div class="mCustomScrollBox mCS-light" id="mCSB_1" style="position: relative; height: 100%; overflow: hidden; max-width: 100%; max-height: 230px;"><div class="mCSB_container mCS_no_scrollbar" style="position: relative; top: 0px;"> <div class="media margin_left20">
										<a class="pull-left" href="http://hammockholidays.com/#" id="pack" data-role="Andamans" data-src-p="India" data-src-s="Andaman &amp; Nicobar Islands" data-id="20"><img src="./Hammock Holidays_packages_files/20_0_Havelock_Island-001_b.jpg" width="50" height="50"></a>
										
										 <div class="media-body margin_top15">
										 <h4 class="media-heading"><a href="http://hammockholidays.com/main/packages/20/India/Andamans/Andaman___Nicobar_Islands" id="pack" data-role="Andamans" data-src-p="India" data-src-s="Andaman &amp; Nicobar Islands" data-id="20">Andaman &amp; Nicobar Islands</a></h4>
										</div>
								   </div></div><div class="mCSB_scrollTools" style="position: absolute; display: none;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position:relative;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>
							 </div>
					<%			}
							}
					%>




      </div>
      </div>
			
          
      </div>
      <!-------------- span6 ----------------->
    
       <div class="span9">
      <div class="row-fluid header1">
      <div class="span12">
      
      				<% if(destId > 0) { %>
   				       <h1 id="heading"><%=DestinationContentManager.getDestinationNameFromId(destId)%></h1>
					<% } else { %>
						<h1 id="heading">All Destinations</h1>
					<% } %>

      
      
      
      </div>

      </div>   
      <div class="row-fluid">
              <div class="span12">
                <div class="caret"></div>
               
              </div>
      </div>
 
      <div id="content_1" class="content content_1  mCustomScrollbar _mCS_11"><div class="mCustomScrollBox mCS-light" id="mCSB_11" style="position:relative; height:100%; overflow:hidden; max-width:100%;"><div class="mCSB_container" style="position: relative; top: 0px;">
        <div class="row-fluid">
            
          <div class="span12 pack_night" id="sel_pack">
          
          <!-- package holder -->
        
          <div class="package_holder_par" id="colaps_20">
			  <div class="package_holder gradient_holder2 adtowl_holder" data-height="543" style="height: 543px;">
			 <div class="package_hold">
			 <div class="package_img adtowlholder">
			 
                             <% 
								if(reviewsMap != null && !reviewsMap.isEmpty()) {
									Map<Long, Review> reviewsSubMap = reviewsMap.get(destId);
									if(reviewsSubMap != null) { %>
										<div class="span9">
							<%
								for(long id : reviewsSubMap.keySet()) {
									Review review = reviewsSubMap.get(id);
									Destination dest = DestinationContentManager.getDestinationFromId(id);
									String text = review.getExpertContent() + " - Posted on " + ThreadSafeUtil.getDDMMMMMyyyyDateFormat(false, false).format(review.getReviewTime());
									request.setAttribute(Attributes.DESTINATION.toString(), dest);
							%>
							<jsp:include page="place_short_view.jsp">
								<jsp:param name="expertReview" value="<%=text%>" />
							</jsp:include>
							<% 	} %>
							</div>
							<%	}
							}
							%>
							
				</div></div></div>

       </div>
       
       
       
      <!-------------- span6 -----------------> 
      
      <div class="row-fluid">
              <div class="span12">
                <div class="caret"></div>
              </div>
       </div>
       <div id="content_2" class="content content_2 mCustomScrollbar _mCS_12"><div class="mCustomScrollBox mCS-light" id="mCSB_12" style="position:relative; height:100%; overflow:hidden; max-width:100%;"><div class="mCSB_container mCS_no_scrollbar" style="position: relative; top: 0px;">
          <div class="span12 rel_travel">
         
            </div>
        </div><div class="mCSB_scrollTools" style="position: absolute; display: none;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position:relative;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>
      </div>
    </div>
    </div>  
    </div>
     <script>
          $("#content_6").mCustomScrollbar({
                        scrollButtons:{
                                enable:true
                        },
                        advanced:{
                            updateOnContentResize: true
                        }
	   });
    

          
       </script>   
   

 <div id="fb-root" class=" fb_reset"><div style="position: absolute; top: -10000px; height: 0px; width: 0px;"><div><iframe name="fb_xdm_frame_http" frameborder="0" allowtransparency="true" scrolling="no" id="fb_xdm_frame_http" aria-hidden="true" title="Facebook Cross Domain Communication Frame" tab-index="-1" src="/static/css/themes/touroperator4/images/xd_arbiter.html" style="border: none;"></iframe><iframe name="fb_xdm_frame_https" frameborder="0" allowtransparency="true" scrolling="no" id="fb_xdm_frame_https" aria-hidden="true" title="Facebook Cross Domain Communication Frame" tab-index="-1" src="/static/css/themes/touroperator4/images/xd_arbiter(1).html" style="border: none;"></iframe></div></div><div style="position: absolute; top: -10000px; height: 0px; width: 0px;"><div></div></div></div>

<div class="light"></div>
		
		
		
		
		
		
		
		
	</div>
</div>

<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
