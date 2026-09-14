import streamlit as st
import folium
from streamlit_folium import st_folium

# Page Configuration
st.set_page_config(
    page_title="Lanka Mobility GIS",
    page_icon="🌍",
    layout="wide"
)

# Header
st.title("🌍 Lanka Mobility GIS Platform")
st.caption("Sri Lanka's Open Spatial Intelligence & Transportation System | Pilot Area: Anuradhapura")

# Sidebar Controls
st.sidebar.header("🕹️ Map Controls & Layers")
show_bus_stops = st.sidebar.checkbox("🚌 Bus Stops & Hubs", value=True)
show_elephant_hazard = st.sidebar.checkbox("🐘 Elephant Corridor Hazard Zone", value=True)
show_reports = st.sidebar.checkbox("🕳️ Citizen Road Damage Reports", value=True)

st.sidebar.markdown("---")
st.sidebar.header("🚨 Citizen Road Damage Reporting")
with st.sidebar.form("report_form"):
    reporter_name = st.text_input("Name")
    damage_type = st.selectbox("Issue Type", ["Pothole", "Flooded Road", "Landslide", "Traffic Hazard"])
    description = st.text_area("Description")
    submit = st.form_submit_button("Submit Report")
    
    if submit:
        st.sidebar.success("Report Submitted Successfully! (Pending Verification)")

# Base Leaflet Map Centered on Anuradhapura
m = folium.Map(location=[8.3114, 80.4037], zoom_start=12, tiles="OpenStreetMap")

# Layer 1: Sample Bus Stops
if show_bus_stops:
    folium.Marker(
        [8.3114, 80.4037],
        popup="<b>Anuradhapura Central Bus Stand</b>",
        tooltip="Central Transit Hub",
        icon=folium.Icon(color="blue", icon="bus", prefix="fa")
    ).add_to(m)

# Layer 2: Sample Elephant Corridor Polygon
if show_elephant_hazard:
    elephant_zone = [
        [8.35, 80.42],
        [8.38, 80.45],
        [8.36, 80.48],
        [8.33, 80.44]
    ]
    folium.Polygon(
        locations=elephant_zone,
        color="red",
        fill=True,
        fill_color="orange",
        fill_opacity=0.4,
        popup="<b>⚠️ Active Wild Elephant Corridor</b><br>High risk during 6 PM - 6 AM."
    ).add_to(m)

# Layer 3: Sample Citizen Report Marker
if show_reports:
    folium.Marker(
        [8.3250, 80.3950],
        popup="<b>Severe Pothole Cluster</b><br>Status: Reported",
        icon=folium.Icon(color="red", icon="exclamation-triangle", prefix="fa")
    ).add_to(m)

# Display Map in Streamlit App
st_folium(m, width="100%", height=600)
