package com.eos.b2c.ui.page;

public enum PartnerPages {

    PARTNER_CONFIG_LIST("config/partner_config_list.jsp"), //
    PARTNER_CONFIG("config/partner_config.jsp"), //
    
    PARTNER_LIST_PRODUCT("partner_list_product.jsp"),
    CONFIGURE_PROFILE("configure_profile.jsp"),
    SELECT_HOTELS("select_hotels.jsp"),
    HOTEL_LEADS("hotel_leads.jsp"),
    ROOM_PACKAGES("room_packages.jsp"),
    ROOM_PRICING("room_pricing.jsp"),
    HOTEL_DEALS("hotel_deals.jsp"),
    AIRLINE_DEALS("airline_deals.jsp"),
    AIRPORT_DEALS("airport_deals.jsp"),
    HOTEL_INVENTORY("hotel_inventory.jsp"),
    MANAGE_INVENTORY("manage_inventory.jsp"),
    TOUR_PACKAGES("tour_packages.jsp"),
    HOTEL_PACKAGES("hotel_packages.jsp"),
    TOUR_PRICING("tour_pricing.jsp"),
    TRANSFERS("transfers.jsp"),
    HOTEL_RATES("hotel_rates.jsp"),
    PACKAGES("packages.jsp"),
    ITINERARIES("itineraries.jsp"),
    EDIT_ITINERARY("edit_itinerary.jsp"),
    EDIT_CONFIG("edit_config.jsp"),
    PRICE_GRID("price_grid.jsp"),
    ADD_PACKAGE("add_package.jsp"),
    ADD_UPGRADES("add_upgrades.jsp"),
    ADD_EXPERIENCE("add_experience.jsp"),
    EXPERIENCES("experiences.jsp"),
    EDIT_TRIP("edit_trip.jsp"),
    ADD_DEALS("add_deals.jsp"),
    CONTRIBUTE("contribute.jsp"),
    VIEW_KRS("view_krs.jsp"),
    ADD_KRS("add_krs.jsp"),
    VIEW_ADVISE("view_advise.jsp"),
    ADD_ADVISE("add_advise.jsp"),
    VIEW_EXPERT_ADVISE("view_expert_advise.jsp"),
    ADD_EXPERT_ADVISE("add_expert_advise.jsp"),
    EDIT_CR("add_cr.jsp"),
    VIEW_QUESTION("view_questions.jsp"),
    CONTENTS("contents.jsp"),
    KRS("krs.jsp"),
    EDIT_CONTENT("edit_content.jsp"),
    ADD_QUESTION("add_question.jsp"),
    TRIP_FLOWS("trip_flows.jsp"),
    ADD_TRIP_FLOWS("add_trip_flows.jsp"),
    DASHBOARD("dashboard.jsp"),
    SEARCH_NOT_FOUND("search_not_found.jsp"),
    TRENDS("trends.jsp"),
    PROMOTIONS("promotions.jsp"),
    OPPORTUNITIES("opportunities.jsp"),
    AIRLINE_RECOMMENDATIONS("airline_recommendations.jsp"),
    AIRLINE_SHOPPINGFLOWS("airline_shoppingflows.jsp"),
    SHOPPINGFLOWS("shoppingflows.jsp"),
    EDIT_PROMOTIONS("edit_promotions.jsp"),
    EDIT_OFFERS("edit_offers.jsp"),
    EDIT_AIRLINE_RECO("edit_airline_reco.jsp"),
    EDIT_SHOPPINGFLOW("edit_shoppingflow.jsp"),
    EDIT_AIRLINE_SHOPPINGFLOW("edit_airline_shoppingflow.jsp"),
    MANAGE_HOTELS("manage_hotels.jsp"),
    MANAGE_HOTELS2("manage_hotels2.jsp"),
    CONTACT_INFO("contact_info.jsp"),
    IMPORTANT_DESTINATIONS("important_destinations.jsp"),
    IMPORTANT_PACKAGES("important_packages.jsp"),
    TRAVEL_TIPS("travel_tips.jsp"),
    EDIT_TRAVEL_TIP("edit_travel_tip.jsp"),
    PRODUCT_TRENDS("product_trends.jsp"),
    GEO_PRODUCT_TRENDS("geo_product_trends.jsp"),
    BOOKING_SUMMARY("booking_summary.jsp"),
    BOOKING_SUMMARY_INSTANT("booking_summary_instant.jsp"),
    MANAGE_HOTEL("manage_hotel.jsp"), 
    PRODUCT_QUERY_PERFORMANCE_TRENDS("product_query_performance_trends.jsp"), 
    PRODUCT_QUERY_POSITION_TRENDS("product_query_position_trends.jsp"), 
    PRODUCT_RANKING_IMPROVEMENT("product_ranking_improvement.jsp"), 
    ATTACHED_OFFERS("attached_offers.jsp"); 

    public static final String PATH_PREPEND = "/partner/";

    private String             pageUrl;

    PartnerPages(String pageUrl) {
        this.pageUrl = pageUrl;
    }

    public String getPageURL() {
        return PATH_PREPEND + pageUrl;
    }

}
