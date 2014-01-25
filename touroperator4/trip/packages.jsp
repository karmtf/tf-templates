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
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
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
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page session="true" %>
<%	
	String title = "Browse our best vacation package deals";
	String keywords = "";
	String description = "";
    long destId = RequestUtil.getLongRequestParameter(request, "destId", -1L);
	List<PackageConfigData> packages = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	Map<Long, List<Long>> regions = (Map<Long, List<Long>>) request.getAttribute(Attributes.DESTINATION_LIST.toString());
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
    <h1 style="color:#0088CC !important">Explore India  <a href="http://hammockholidays.com/main/package/World" data-hint="World" class="pull-right hint--top"><span class="globe_icon pull-right"></span></a> <a href="http://hammockholidays.com/main/package/Special" data-hint="Specials" class="pull-right hint--top"><span class="special_icon pull-right"></span></a></h1>    </div>
    </div>
    <div class="row-fluid">
              <div class="span12">
                <div class="caret"></div>
              </div>
            </div>
       
        
  <br><div class="row-fluid ui-accordion ui-widget ui-helper-reset" id="menu" role="tablist">
                          <div class="span12">
                          
                          
			

					<% 
						if(regions != null) {
							for (Long country : regions.keySet()) {
					%>
						<a class="package_link ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-accordion-icons" href="/tours/packages?destId=<%=country%>" role="tab" id="ui-accordion-menu-header-0" aria-controls="ui-accordion-menu-panel-0"  tabindex="0"><span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
						<div><%=DestinationContentManager.getDestinationNameFromId(country)%></div><span class="menu_arrow"></span> </a>
						   <div class="collapse_scroller_holder ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom" id="ui-accordion-menu-panel-0" aria-labelledby="ui-accordion-menu-header-0" role="tabpanel" aria-expanded="false" aria-hidden="true" style="display: none;"> <div class="caret" style="margin-left:20px;"></div>
							<div id="content_3" class="sub_pakage_scroll content_3 mCustomScrollbar _mCS_1" style="overflow: hidden;"><div class="mCustomScrollBox mCS-light" id="mCSB_1" style="position: relative; height: 100%; overflow: hidden; max-width: 100%; max-height: 230px;"><div class="mCSB_container mCS_no_scrollbar" style="position: relative; top: 0px;"> <div class="media margin_left20">
										<a class="pull-left" href="http://hammockholidays.com/#" id="pack" data-role="Andamans" data-src-p="India" data-src-s="Andaman &amp; Nicobar Islands" data-id="20"><img src="./Hammock Holidays_packages_files/20_0_Havelock_Island-001_b.jpg" width="50" height="50"></a>
										
										 <div class="media-body margin_top15">
										 <h4 class="media-heading"><a href="http://hammockholidays.com/main/packages/20/India/Andamans/Andaman___Nicobar_Islands" id="pack" data-role="Andamans" data-src-p="India" data-src-s="Andaman &amp; Nicobar Islands" data-id="20">Andaman &amp; Nicobar Islands</a></h4>
										</div>
								   </div></div><div class="mCSB_scrollTools" style="position: absolute; display: none;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position:relative;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>
							 </div>
					<%
						List<Long> states = regions.get(country);
						if(!states.isEmpty()) {
							for(Long stateId : states) {
					%>
						<a class="package_link ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-accordion-icons" href="/tours/packages?destId=<%=stateId%>" role="tab" id="ui-accordion-menu-header-0" aria-controls="ui-accordion-menu-panel-0" aria-selected="false" tabindex="0"><span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
						<div>Andamans</div><span class="menu_arrow"></span> </a>
						   <div class="collapse_scroller_holder ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom" id="ui-accordion-menu-panel-0" aria-labelledby="ui-accordion-menu-header-0" role="tabpanel" aria-expanded="false" aria-hidden="true" style="display: none;"> <div class="caret" style="margin-left:20px;"></div>
							<div id="content_3" class="sub_pakage_scroll content_3 mCustomScrollbar _mCS_1" style="overflow: hidden;"><div class="mCustomScrollBox mCS-light" id="mCSB_1" style="position: relative; height: 100%; overflow: hidden; max-width: 100%; max-height: 230px;"><div class="mCSB_container mCS_no_scrollbar" style="position: relative; top: 0px;"> <div class="media margin_left20">
										<a class="pull-left" href="http://hammockholidays.com/#" id="pack" data-role="Andamans" data-src-p="India" data-src-s="Andaman &amp; Nicobar Islands" data-id="20"><img src="./Hammock Holidays_packages_files/20_0_Havelock_Island-001_b.jpg" width="50" height="50"></a>
										
										 <div class="media-body margin_top15">
										 <h4 class="media-heading"><a href="http://hammockholidays.com/main/packages/20/India/Andamans/Andaman___Nicobar_Islands" id="pack" data-role="Andamans" data-src-p="India" data-src-s="Andaman &amp; Nicobar Islands" data-id="20">Andaman &amp; Nicobar Islands</a></h4>
										</div>
								   </div></div><div class="mCSB_scrollTools" style="position: absolute; display: none;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position:relative;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>
							 </div>
					<% 		} 
						} 
					%>
					<% 		} 
						}
					%>




      </div>
      </div>
			
          
      </div>
      <!-------------- span6 ----------------->
    
       <div class="span6">
      <div class="row-fluid header1">
      <div class="span12">
      
      				<% if(destId > 0) { %>
   				       <h1 id="heading"><%=DestinationContentManager.getDestinationNameFromId(destId)%> Packages</h1>
					<% } else { %>
						<h1 id="heading">Showing All Packages</h1>
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
                             <div class="package_hold"><div class="package_img adtowlholder"><img class="lazy" src="/static/css/themes/touroperator4/images/20_0_Havelock_Island-001_b.jpg" data-original="package_images/20_0_Havelock_Island-001_b.jpg" style="display: inline;">
                                  <div class="gradient"></div>
                                 <div class="tourimg_content3 offset1">
                                 <span class="tourimg_text_style3">Andaman &amp; Nicobar Islands</span><br>
                                 <span class="tourimg_text_style4">A shimmering jewel in the Bay of Bengal</span>
                              <div class="view"><img src="/static/css/themes/touroperator4/images/eye.png"><span class="view_number">5144</span> people have seen this</div>
                             </div>
                                 <div class="package_img_hover_arr">
                                         <div class="package_img_hover">
                                         <a href="http://hammockholidays.com/#" data-id="20" class="travelouges">Read related travelouges</a>
                                         <span class="package_img_hover_arrow"><img src="/static/css/themes/touroperator4/images/white_arrow_left.png"></span>
                                         </div>
                                 </div>

                                   <a href="http://hammockholidays.com/#" data-pid="20" class="adtowl"></a>

                            </div>
                               
                              <p class="margin_top15 margin_bottom0"></p><p>Andaman &amp; Nicobar islands is an exotic destination with a lot of interesting sights. The natural beauty of the sea and the coast and the rarity of living mangrove swamps (fast disappearing from the face of the earth) , a historic background where India’s freedom fighters were jailed ( a backdrop of many Bollywood movies like Kaalapaani), and add to this, the options of water sports , snorkeling and scuba diving and island hopping and you have all the makings of a must –see destination.</p><p></p><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/20_0_22_b.JPG" data-original="package_images/20_0_22_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>We would suggest a 5 night trip, combining the capital city of Port Blair and Havelock Island . On the first day, arrive into Port Blair as the airport is here.. If there is time, do some fun things like taking a Banana boat ride, jet ski, speed boat ride or any other water sports activities available at Corbyn’s Cove – the only beach in Port Blair. In the evening, visit the Cellular jail, and be on time to watch the enthralling Sound and Light show which brings alive the heroic saga of the Indian freedom struggle.</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/20_1_31_b.jpg" data-original="package_images/20_1_31_b.jpg" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>The next day, take a Makruzz (a high speed Catamaran passenger ferry with better stability and space) transfer to Havelock Island (about 1 ½ hours) . Check in at the resort and enjoy a leisurely time. Later walk down to Beach No 7 (Radhanagar Beach) ) rated as the ‘Best Beach in Asia’ by Time Magazine.. Enjoy an unforgettable time unwinding on the beach and enjoy the enchanting scenery and the blue waters of this magical coast.</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/20_2_42_b.jpg" data-original="package_images/20_2_42_b.jpg" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>On day 3 take an excursion to Elephant Beach to enjoy the breathtaking ride in a Glass bottomed boat. You can also go snorkeling. This beach is safe for beginners to go snorkeling also and one gets to see colorful coral and plenty of marine life including sea turtles and exotic fishes of all shapes and hues.</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/20_3_52_b.jpg" data-original="package_images/20_3_52_b.jpg" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>It is simply divine to just sit back and enjoy the white beaches and the blue seas.. Yet, for those who want more from an island holiday, there are options. A rustic island experience can be had by hiring a Kayak and going through the Mangrove Creek for an hour and a half. Viewing the mangroves with their roots high above the water mark, forming an intricate mesh is an unique experience. This kayaking can be followed by a local village lunch.</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/20_4_62_b.jpg" data-original="package_images/20_4_62_b.jpg" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Currently – there is also an exciting prospect of swimming with Havelock’s main swimmer – Rajan, the elephant! Or the not so adventurous can have a stroll with him on the beach!</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/20_6_Port_Blair_5-001_b.jpg" data-original="package_images/20_6_Port_Blair_5-001_b.jpg" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>On the last day of your vacation, enjoy the beach in the morning and then after saying your farewells, get a Makruzz transfer back to Port Blair. Do a city tour covering the important places in town and the varied museums giving an insight into island life and the evolution through the ages. Don’t miss out going to the Cottage Industries Emporium (Sagarika) to pick up some lovely souvenirs to commemorate this beautiful holiday.</p>
<p>The next morning, it will be time to catch that flight back home - the memories of this colorful and romantic island will always remain as an imprint that will never fade.</p><p></p></div><div class="well-small margin_bottom25">
                             <div class="enquiry"> 
                                <div style="width:110px; margin-top: 1px;" class="pull-left"> <a class="btn6" href="http://hammockholidays.com/#">Enquire Now</a>
                                <div class="pack_enquire" id="pack_enquire1" style="display:none;background-color: #FFF; z-index: 10000;">
                                    <div class="pack_enquire_close"><a href="http://hammockholidays.com/#" data-hint="Close" onclick="return close_pack_enq_1(1)" data-wishid="39" data-placement="top" class="icon-remove btn-link pull-right hint--top"></a></div>
                                    <form class="pack_enq" name="form" method="post" action="http://hammockholidays.com/main/package_enquiry">
                                         <span></span>
                                         <input type="hidden" name="main_cat" value="India">
                                         <input type="hidden" name="sub_cat" value="Andamans">
                                         <input type="hidden" name="pack_name" value="Andaman" &="" nicobar="" islands="">
                                         <input type="text" placeholder="*Name" name="name" style="margin-right:10px" pattern="[a-zA-Z ]+" title="Please Enter only letters of the alphabet" value="" required="">
                                         <p class="err-msg"></p>
                                        <input type="email" placeholder="*Email" name="email" required="" title="Please Enter Valid Email ID" value="">
                                         <p class="err-msg"></p>
                                        <input type="text" placeholder="*Mobile (Enter Only Numbers)" name="mobile" style="margin-right:10px" value="" pattern="[0-9]+" required="" title="Please Enter only numbers">
                                         <p class="err-msg"></p>
                                        <textarea name="message" placeholder="Query"></textarea>
                                        <input class="btn2 margin_left0" value="Enqire Now" type="submit">
                         
                                  </form>
                            </div>
                            </div>
                          </div> 
                     <div style="width:90px; float:right" class="pull-right"><iframe id="twitter-widget-20" scrolling="no" frameborder="0" allowtransparency="true" src="/static/css/themes/touroperator4/images/tweet_button.1389999802(20).html" class="twitter-share-button twitter-tweet-button twitter-count-horizontal" title="Twitter Tweet Button" data-twttr-rendered="true" style="width: 107px; height: 20px;"></iframe>
                    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?"http":"https";if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document, "script", "twitter-wjs");</script></div>
                    <div style="width:73px; float:right" class="pull-right"><div class="fb-like fb_edge_widget_with_comment fb_iframe_widget" data-href="/tours/packages/90/India/Kerala/Munnar" data-send="false" data-layout="button_count" data-width="450" data-show-faces="false" fb-xfbml-state="rendered"><span style="height: 20px; width: 76px;"><iframe id="f1e96250fc" name="f37e5a1288" scrolling="no" title="Like this content on Facebook." class="fb_ltr" src="/static/css/themes/touroperator4/images/like(10).html" style="border: none; overflow: hidden; height: 20px; width: 76px;"></iframe></span></div></div>
                    <div style="width:73px; float:right" class="pull-right"><div id="___plusone_20" style="text-indent: 0px; margin: 0px; padding: 0px; background-color: transparent; border-style: none; float: none; line-height: normal; font-size: 1px; vertical-align: baseline; display: inline-block; width: 90px; height: 20px; background-position: initial initial; background-repeat: initial initial;"><iframe frameborder="0" hspace="0" marginheight="0" marginwidth="0" scrolling="no" style="position: static; top: 0px; width: 90px; margin: 0px; border-style: none; left: 0px; visibility: visible; height: 20px;" tabindex="0" vspace="0" width="100%" id="I20_1390627134810" name="I20_1390627134810" src="/static/css/themes/touroperator4/images/fastbutton(20).html" data-gapiattached="true" title="+1"></iframe></div></div>
                  
                        </div><br> <div class="fb-comments fb_iframe_widget" data-href="/tours/packages/90/India/Kerala/Munnar" data-width="520" data-num-posts="8" fb-xfbml-state="rendered"><span style="height: 160px; width: 520px;"><iframe id="f3c5c86ba4" name="f1bc0ff10c" scrolling="no" title="Facebook Social Plugin" class="fb_ltr" src="/static/css/themes/touroperator4/images/comments(22).html" style="border: none; overflow: hidden; height: 160px; width: 520px;"></iframe></span></div></div></div> <a href="http://hammockholidays.com/#" class="read_more" data-href="main/packages/90/India/Kerala/Munnar" data-view="90" data-pack_name="Munnar" data-collapse-id="colaps_90">Read More</a><br><br></div><div class="package_holder_par" id="colaps_91">
                              <div class="package_holder gradient_holder2 adtowl_holder" data-height="579" style="height: 579px;">
                             <div class="package_hold"><div class="package_img adtowlholder"><img class="lazy" src="/static/css/themes/touroperator4/images/91_128_b.jpg" data-original="package_images/91_128_b.jpg" style="display: inline;">
                                  <div class="gradient"></div>
                                 <div class="tourimg_content3 offset1">
                                 <span class="tourimg_text_style3">Matheran</span><br>
                                 <span class="tourimg_text_style4">Matheran Magic</span>
                              <div class="view"><img src="/static/css/themes/touroperator4/images/eye.png"><span class="view_number">3551</span> people have seen this</div>
                             </div>
                                 <div class="package_img_hover_arr">
                                         <div class="package_img_hover">
                                         <a href="http://hammockholidays.com/#" data-id="91" class="travelouges">Read related travelouges</a>
                                         <span class="package_img_hover_arrow"><img src="/static/css/themes/touroperator4/images/white_arrow_left.png"></span>
                                         </div>
                                 </div>

                                   <a href="http://hammockholidays.com/#" data-pid="91" class="adtowl"></a>

                            </div>
                               
                              <p class="margin_top15 margin_bottom0"></p><p>
                              <!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:"Table Normal";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-priority:99;
	mso-style-parent:"";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin-top:0cm;
	mso-para-margin-right:0cm;
	mso-para-margin-bottom:8.0pt;
	mso-para-margin-left:0cm;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-fareast-language:EN-US;}
</style>
<![endif]--></p>
<p class="MsoNormal" style="text-align: justify;">The next day after our breakfast, we head to the North most point of Matheran – Panoramic Point. The 360 degree view of surrounding areas was just fantastic. <span style="mso-spacerun: yes;">&nbsp;</span></p>
<p class="MsoNormal" style="text-align: justify;">If you are staying at Matheran for some more time, the other points that you could visit are Heart point, Monkey Point, Echo point and Sunset point (though you may not get to see the sunset). However, it takes an entire day to cover these destinations.</p>
<p><span style="font-size: 11.0pt; line-height: 107%; font-family: &#39;Calibri&#39;,&#39;sans-serif&#39;; mso-ascii-theme-font: minor-latin; mso-fareast-font-family: Calibri; mso-fareast-theme-font: minor-latin; mso-hansi-theme-font: minor-latin; mso-bidi-font-family: &#39;Times New Roman&#39;; mso-bidi-theme-font: minor-bidi; mso-ansi-language: EN-IN; mso-fareast-language: EN-US; mso-bidi-language: AR-SA;">We decided to skip these and proceeded to our resort to have our lunch and leave by the evening train to Mumbai. I personally feel that Matheran is a one or maximum two night’s destination and will be enjoyed mainly by those who are looking for a quiet and peaceful place with a lot of scenic beauty.</span></p><p></p></div><div class="well-small margin_bottom25">
                             <div class="enquiry"> 
                                <div style="width:110px; margin-top: 1px;" class="pull-left"> <a class="btn6" href="http://hammockholidays.com/#">Enquire Now</a>
                                <div class="pack_enquire" id="pack_enquire22" style="display:none;background-color: #FFF; z-index: 10000;">
                                    <div class="pack_enquire_close"><a href="http://hammockholidays.com/#" data-hint="Close" onclick="return close_pack_enq_1(22)" data-wishid="546" data-placement="top" class="icon-remove btn-link pull-right hint--top"></a></div>
                                    <form class="pack_enq" name="form" method="post" action="http://hammockholidays.com/main/package_enquiry">
                                         <span></span>
                                         <input type="hidden" name="main_cat" value="India">
                                         <input type="hidden" name="sub_cat" value="Maharastra">
                                         <input type="hidden" name="pack_name" value="Matheran">
                                         <input type="text" placeholder="*Name" name="name" style="margin-right:10px" pattern="[a-zA-Z ]+" title="Please Enter only letters of the alphabet" value="" required="">
                                         <p class="err-msg"></p>
                                        <input type="email" placeholder="*Email" name="email" required="" title="Please Enter Valid Email ID" value="">
                                         <p class="err-msg"></p>
                                        <input type="text" placeholder="*Mobile (Enter Only Numbers)" name="mobile" style="margin-right:10px" value="" pattern="[0-9]+" required="" title="Please Enter only numbers">
                                         <p class="err-msg"></p>
                                        <textarea name="message" placeholder="Query"></textarea>
                                        <input class="btn2 margin_left0" value="Enqire Now" type="submit">
                         
                                  </form>
                            </div>
                            </div>
                          </div> 
                     <div style="width:90px; float:right" class="pull-right"><iframe id="twitter-widget-21" scrolling="no" frameborder="0" allowtransparency="true" src="/static/css/themes/touroperator4/images/tweet_button.1389999802(21).html" class="twitter-share-button twitter-tweet-button twitter-count-horizontal" title="Twitter Tweet Button" data-twttr-rendered="true" style="width: 107px; height: 20px;"></iframe>
                    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?"http":"https";if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document, "script", "twitter-wjs");</script></div>
                    <div style="width:73px; float:right" class="pull-right"><div class="fb-like fb_edge_widget_with_comment fb_iframe_widget" data-href="/tours/packages/91/India/Maharastra/Matheran" data-send="false" data-layout="button_count" data-width="450" data-show-faces="false" fb-xfbml-state="rendered"><span style="height: 20px; width: 76px;"><iframe id="f3cf4fa588" name="f24ac2d87c" scrolling="no" title="Like this content on Facebook." class="fb_ltr" src="/static/css/themes/touroperator4/images/like(12).html" style="border: none; overflow: hidden; height: 20px; width: 76px;"></iframe></span></div></div>
                    <div style="width:73px; float:right" class="pull-right"><div id="___plusone_21" style="text-indent: 0px; margin: 0px; padding: 0px; background-color: transparent; border-style: none; float: none; line-height: normal; font-size: 1px; vertical-align: baseline; display: inline-block; width: 90px; height: 20px; background-position: initial initial; background-repeat: initial initial;"><iframe frameborder="0" hspace="0" marginheight="0" marginwidth="0" scrolling="no" style="position: static; top: 0px; width: 90px; margin: 0px; border-style: none; left: 0px; visibility: visible; height: 20px;" tabindex="0" vspace="0" width="100%" id="I21_1390627134817" name="I21_1390627134817" src="/static/css/themes/touroperator4/images/fastbutton(21).html" data-gapiattached="true" title="+1"></iframe></div></div>
                  
                        </div><br> <div class="fb-comments fb_iframe_widget" data-href="/tours/packages/91/India/Maharastra/Matheran" data-width="520" data-num-posts="8" fb-xfbml-state="rendered"><span style="height: 160px; width: 520px;"><iframe id="f22d7515a8" name="f13d7c7678" scrolling="no" title="Facebook Social Plugin" class="fb_ltr" src="/static/css/themes/touroperator4/images/comments(12).html" style="border: none; overflow: hidden; height: 160px; width: 520px;"></iframe></span></div></div></div> <a href="http://hammockholidays.com/#" class="read_more" data-href="main/packages/91/India/Maharastra/Matheran" data-view="91" data-pack_name="Matheran" data-collapse-id="colaps_91">Read More</a><br><br></div><div class="package_holder_par" id="colaps_92">
                              <div class="package_holder gradient_holder2 adtowl_holder" data-height="571" style="height: 571px;">
                             <div class="package_hold"><div class="package_img adtowlholder"><img class="lazy" src="/static/css/themes/touroperator4/images/92_1-00114_b.jpg" data-original="package_images/92_1-00114_b.jpg" style="display: inline;">
                                  <div class="gradient"></div>
                                 <div class="tourimg_content3 offset1">
                                 <span class="tourimg_text_style3">Nainital</span><br>
                                 <span class="tourimg_text_style4">The Kumaon Himalayas</span>
                              <div class="view"><img src="/static/css/themes/touroperator4/images/eye.png"><span class="view_number">3725</span> people have seen this</div>
                             </div>
                                 <div class="package_img_hover_arr">
                                         <div class="package_img_hover">
                                         <a href="http://hammockholidays.com/#" data-id="92" class="travelouges">Read related travelouges</a>
                                         <span class="package_img_hover_arrow"><img src="/static/css/themes/touroperator4/images/white_arrow_left.png"></span>
                                         </div>
                                 </div>

                                   <a href="http://hammockholidays.com/#" data-pid="92" class="adtowl"></a>

                            </div>
                               
                              <p class="margin_top15 margin_bottom0"></p><p>It was a bright and clear day in June that our train rolled into Kathgodam the closest rail station to Nainital. &nbsp;Our holiday to the Kumaon Himalayas starts from here. The taxi to Nainital took all of 45 mins…. Climbing up the winding mountain roads and then into the valley of Nainital.</p>
<p>One can also do a 6 – 7 hrs drive from Delhi to Nainital, but we opted for the train as I was travelling with my aged in-laws and the overnight train gave them a chance to catch some good sleep.</p><p></p><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_0_2-0013_b.JPG" data-original="package_images/92_0_2-0013_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Our hotel was at an elevation and had great views of the Naini Lake. &nbsp;Well tendered gardens and crisscrossing, cobbled walkways.. The rooms were quite large and comfortable but there were a lot many stairs within the resort, connecting common areas and the restaurant that my in-laws found cumbersome. Stairways are the curse of any hill station, I suppose?</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_1_3-00113_b.jpg" data-original="package_images/92_1_3-00113_b.jpg" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Legends say that Goddess Naini Devi shed a tear drop which became the Naini lake. I wonder if she was so sad to have shed that tear or was it triggered by extreme joy? That portion of the story never got written?&nbsp;</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_2_4-0011_b.JPG" data-original="package_images/92_2_4-0011_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>The Mal road is quite a lively place. &nbsp;It can get crowded in the evenings, though. &nbsp;There are many mid-range hotels along the Mall area. &nbsp;We had particularly opted for a hotel away from the Mall area as vehicular traffic is restricted for most part of the day.</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_3_5-0014_b.JPG" data-original="package_images/92_3_5-0014_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Midday is a good time to enjoy a leisurely paddleboat ride on the lake.. &nbsp;I would recommend the option of a sailboat.. It is faster and very nimble. &nbsp;Remember to carry peak caps and your sunglasses as it can get quite hot during the day.</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_4_6-00114_b.jpg" data-original="package_images/92_4_6-00114_b.jpg" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>A post office on a bridge? &nbsp;Yes, probably the only one in the world. Wonder why anyone would build a post office right smack in the middle of a bridge? A poke from P &amp; T to PWD?</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_5_7-0011_b.JPG" data-original="package_images/92_5_7-0011_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Naukuchiyatal is a location that I would not mind visiting again.. It was the second day of our vacation and we moved into this lovely resort by the Naukuchiyatal lake front. &nbsp;I shot this photo right outside the restaurant.. a very private, serene and quiet location.</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_6_8-0013_b.JPG" data-original="package_images/92_6_8-0013_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Karpuyatal, another lovely lake is a short drive from Nainital. &nbsp;Un-crowded and pristine..&nbsp;</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_7_9-001_b.JPG" data-original="package_images/92_7_9-001_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Our drive up from Naini to Ramgarh was lovely, a picture postcard countryside.. Hammock had already booked our accommodation at a lovely standalone heritage cottage called ‘The Writers Bungalow’. &nbsp;</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_8_10-001_b.JPG" data-original="package_images/92_8_10-001_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>A Neemrana group heritage property, completely refurbished and restored to its original. &nbsp;</p><p></p></div><div class="package_img margin_top15"><img class="lazy" src="/static/css/themes/touroperator4/images/92_9_11-001_b.JPG" data-original="package_images/92_9_11-001_b.JPG" style="display: inline;">

                                <p class="margin_top15 margin_bottom5"></p><p>Three bedrooms with wonderful views of the Himalayas.. &nbsp;Breakfast served on the lawns… surrounded by fruit orchards with lovely walking trails, this was the best recommendation from Hammock. &nbsp;Thanks again.</p>
<p>Tomorrow we continue our holiday higher up into the hills of Almora &amp; then on to Binsar :)</p>
<p>&nbsp;</p><p></p></div><div class="well-small margin_bottom25">
                             <div class="enquiry"> 
                                <div style="width:110px; margin-top: 1px;" class="pull-left"> <a class="btn6" href="http://hammockholidays.com/#">Enquire Now</a>
                                <div class="pack_enquire" id="pack_enquire23" style="display:none;background-color: #FFF; z-index: 10000;">
                                    <div class="pack_enquire_close"><a href="http://hammockholidays.com/#" data-hint="Close" onclick="return close_pack_enq_1(23)" data-wishid="557" data-placement="top" class="icon-remove btn-link pull-right hint--top"></a></div>
                                    <form class="pack_enq" name="form" method="post" action="http://hammockholidays.com/main/package_enquiry">
                                         <span></span>
                                         <input type="hidden" name="main_cat" value="India">
                                         <input type="hidden" name="sub_cat" value="Uttarkhand">
                                         <input type="hidden" name="pack_name" value="Nainital">
                                         <input type="text" placeholder="*Name" name="name" style="margin-right:10px" pattern="[a-zA-Z ]+" title="Please Enter only letters of the alphabet" value="" required="">
                                         <p class="err-msg"></p>
                                        <input type="email" placeholder="*Email" name="email" required="" title="Please Enter Valid Email ID" value="">
                                         <p class="err-msg"></p>
                                        <input type="text" placeholder="*Mobile (Enter Only Numbers)" name="mobile" style="margin-right:10px" value="" pattern="[0-9]+" required="" title="Please Enter only numbers">
                                         <p class="err-msg"></p>
                                        <textarea name="message" placeholder="Query"></textarea>
                                        <input class="btn2 margin_left0" value="Enqire Now" type="submit">
                         
                                  </form>
                            </div>
                            </div>
                          </div> 
                     <div style="width:90px; float:right" class="pull-right"><iframe id="twitter-widget-22" scrolling="no" frameborder="0" allowtransparency="true" src="/static/css/themes/touroperator4/images/tweet_button.1389999802(22).html" class="twitter-share-button twitter-tweet-button twitter-count-horizontal" title="Twitter Tweet Button" data-twttr-rendered="true" style="width: 107px; height: 20px;"></iframe>
                    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?"http":"https";if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document, "script", "twitter-wjs");</script></div>
                    <div style="width:73px; float:right" class="pull-right"><div class="fb-like fb_edge_widget_with_comment fb_iframe_widget" data-href="/tours/packages/92/India/Uttarkhand/Nainital" data-send="false" data-layout="button_count" data-width="450" data-show-faces="false" fb-xfbml-state="rendered"><span style="height: 20px; width: 76px;"><iframe id="f1784c574c" name="f3eac57604" scrolling="no" title="Like this content on Facebook." class="fb_ltr" src="/static/css/themes/touroperator4/images/like(20).html" style="border: none; overflow: hidden; height: 20px; width: 76px;"></iframe></span></div></div>
                    <div style="width:73px; float:right" class="pull-right"><div id="___plusone_22" style="text-indent: 0px; margin: 0px; padding: 0px; background-color: transparent; border-style: none; float: none; line-height: normal; font-size: 1px; vertical-align: baseline; display: inline-block; width: 90px; height: 20px; background-position: initial initial; background-repeat: initial initial;"><iframe frameborder="0" hspace="0" marginheight="0" marginwidth="0" scrolling="no" style="position: static; top: 0px; width: 90px; margin: 0px; border-style: none; left: 0px; visibility: visible; height: 20px;" tabindex="0" vspace="0" width="100%" id="I22_1390627134824" name="I22_1390627134824" src="/static/css/themes/touroperator4/images/fastbutton(22).html" data-gapiattached="true" title="+1"></iframe></div></div>
                  
                        </div><br> <div class="fb-comments fb_iframe_widget" data-href="/tours/packages/92/India/Uttarkhand/Nainital" data-width="520" data-num-posts="8" fb-xfbml-state="rendered"><span style="height: 160px; width: 520px;"><iframe id="f405e504c" name="f39c84793c" scrolling="no" title="Facebook Social Plugin" class="fb_ltr" src="/static/css/themes/touroperator4/images/comments(7).html" style="border: none; overflow: hidden; height: 160px; width: 520px;"></iframe></span></div></div></div> <a href="http://hammockholidays.com/#" class="read_more" data-href="main/packages/92/India/Uttarkhand/Nainital" data-view="92" data-pack_name="Nainital" data-collapse-id="colaps_92">Read More</a><br><br></div>       </div>
        </div>
      </div><div class="mCSB_scrollTools" style="position: absolute; display: block;"><a class="mCSB_buttonUp" oncontextmenu="return false;"></a><div class="mCSB_draggerContainer"><div class="mCSB_dragger" style="position: absolute; height: 46px; top: 0px;" oncontextmenu="return false;"><div class="mCSB_dragger_bar" style="position: relative; line-height: 46px;"></div></div><div class="mCSB_draggerRail"></div></div><a class="mCSB_buttonDown" oncontextmenu="return false;"></a></div></div></div>

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
