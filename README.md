# Healthcare Appointment Absenteeism Patient Risk Modeling SQL | MySQL Workbench | Tableau Public
---

  <img width="700" height="512" alt="Hospital" src="https://github.com/user-attachments/assets/089cef07-3997-4e3a-a104-c5ea34a018fd" />

---

## Executive Summary
Missed medical appointments significantly disrupt operational efficiency, result in sub-optimal resource utilization, and create gaps in patient care delivery. This project provides an end-to-end data pipeline solution—moving from raw, unstructured healthcare data to an interactive executive dashboard. Using MySQL for data transformation and Tableau Public for visualization, the solution implements data sanitization pipelines, exploratory hypothesis testing, window-function based historical tracking, and a dynamic patient-risk scoring model to identify high-risk appointments prior to their occurrence.

---

<div style="font-family: Arial, sans-serif; background-color: #0d1117; color: #c9d1d9; padding: 30px; border-radius: 12px; max-width: 800px; margin: auto;">
  
  <h2 style="text-align: center; color: #58a6ff; margin-bottom: 25px; letter-spacing: 1px;">HEALTHCARE NO-SHOW ANALYTICS SOLUTION</h2>

  <!-- Stage 1 -->
  <div style="background: #161b22; border: 1px solid #30363d; border-left: 5px solid #238636; border-radius: 8px; padding: 15px 20px; margin-bottom: 15px;">
    <span style="font-size: 12px; color: #8b949e; font-weight: bold;">STEP 01</span>
    <h3 style="margin: 5px 0 10px 0; color: #f0f6fc;">Raw Medical CSV Dataset</h3>
  </div>

  <div style="text-align: center; color: #58a6ff; font-size: 20px; margin: -5px 0 10px 0;">↓</div>

  <!-- Stage 2 -->
  <div style="background: #161b22; border: 1px solid #30363d; border-left: 5px solid #1f6feb; border-radius: 8px; padding: 15px 20px; margin-bottom: 15px;">
    <span style="font-size: 12px; color: #8b949e; font-weight: bold;">STEP 02</span>
    <h3 style="margin: 5px 0 10px 0; color: #f0f6fc;">MySQL Engine</h3>
    <ul style="margin: 0; padding-left: 20px; color: #8b949e; font-size: 14px;">
      <li>Schema Standardisation</li>
      <li>Datetime Formatting</li>
      <li>Data Anomaly Removal</li>
    </ul>
  </div>

  <div style="text-align: center; color: #58a6ff; font-size: 20px; margin: -5px 0 10px 0;">↓</div>

  <!-- Stage 3 -->
  <div style="background: #161b22; border: 1px solid #30363d; border-left: 5px solid #8957e5; border-radius: 8px; padding: 15px 20px; margin-bottom: 15px;">
    <span style="font-size: 12px; color: #8b949e; font-weight: bold;">STEP 03</span>
    <h3 style="margin: 5px 0 10px 0; color: #f0f6fc;">Exploratory SQL Analysis</h3>
    <ul style="margin: 0; padding-left: 20px; color: #8b949e; font-size: 14px;">
      <li>Lead-Time Bucketing</li>
      <li>Demographic Analysis</li>
      <li>Geographic Risk Ranking</li>
    </ul>
  </div>

  <div style="text-align: center; color: #58a6ff; font-size: 20px; margin: -5px 0 10px 0;">↓</div>

  <!-- Stage 4 -->
  <div style="background: #161b22; border: 1px solid #30363d; border-left: 5px solid #d29922; border-radius: 8px; padding: 15px 20px; margin-bottom: 15px;">
    <span style="font-size: 12px; color: #8b949e; font-weight: bold;">STEP 04</span>
    <h3 style="margin: 5px 0 10px 0; color: #f0f6fc;">Patient Risk Engine</h3>
    <ul style="margin: 0; padding-left: 20px; color: #8b949e; font-size: 14px;">
      <li>Window Functions</li>
      <li>Historical Partitioning</li>
      <li>Business Logic View</li>
    </ul>
  </div>

  <div style="text-align: center; color: #58a6ff; font-size: 20px; margin: -5px 0 10px 0;">↓</div>

  <!-- Stage 5 -->
  <div style="background: #161b22; border: 1px solid #30363d; border-left: 5px solid #f85149; border-radius: 8px; padding: 15px 20px;">
    <span style="font-size: 12px; color: #8b949e; font-weight: bold;">STEP 05</span>
    <h3 style="margin: 5px 0 10px 0; color: #f0f6fc;">Tableau Executive Board</h3>
    <ul style="margin: 0; padding-left: 20px; color: #8b949e; font-size: 14px;">
      <li>Risk Segmentation</li>
      <li>Operational Actioning</li>
    </ul>
  </div>

</div>

---

- *Database Schema & Data Cleansing*: Standardized variable naming, resolved string-to-datetime formatting errors, and removed invalid demographic and chronological entries.

- *Exploratory Analytics*: Analyzed correlation drivers for appointment absenteeism, including lead time, age brackets, day-of-week trends, and geographic distributions.

- *Advanced SQL Risk Modeling*: Created a rolling historical risk profile per patient utilizing MySQL window functions while preventing data leakage.

- *Data Delivery & Visualization*: Exported cleaned views into Tableau Public to build operational visual metrics and key performance indicator (KPI) tracking dashboards.

---

## Dashboard & Visual Insights

### Executive Dashboard Overview
---

*Figure 1*: Interactive Tableau Public dashboard displaying overall no-show KPIs, lead-time distribution, and operational risk tiers.
<img width="959" height="536" alt="Appointment No-Show Dashboard" src="https://github.com/user-attachments/assets/97c0460b-71f4-412e-849e-4ff12aa229da" />

---

*Figure 2*: This visualization details appointment absenteeism across the week, showing that no-show rates peak on Saturday (~23%) and Friday (~21%), while mid-week slots from Tuesday to Thursday maintain the highest attendance stability (~19–20%).

The trend suggests that weekend-adjacent appointments carry higher operational risk, indicating a clear opportunity for clinics to implement targeted engagement strategies or adjust scheduling capacity on these specific days.
<img width="757" height="329" alt="No -Show Rate by Day of Week" src="https://github.com/user-attachments/assets/15c7bd02-b334-4ef0-909c-aaf44f89936b" />

---

*Figure 3*: This bar chart illustrates a direct correlation between scheduling lead times and patient absenteeism, showing that no-show rates escalate from under *5%* for same-day bookings to over 30% for long-lead appointments scheduled 8 or more days in advance.

The significant surge in drop-offs past the 3-day mark underscores the need for automated reminder interventions and strategic schedule optimization for long-lead bookings.
<img width="755" height="327" alt="No Show Rate By Lead time" src="https://github.com/user-attachments/assets/fb062f4b-4995-422b-81e5-278f7e9a4b20" />

---

*Figure 4*: This Tableau dashboard segment isolates the High Risk patient tier, revealing a *31.27%* overall no-show rate across *22,188* flagged appointments with an average scheduling lead time of *17.05 days*.

The visual breakdown highlights that absenteeism in this high-risk cohort peaks with longer lead times (4–8+ days) and early-week scheduling, pinpointing specific geographic neighborhoods for targeted intervention.
<img width="959" height="539" alt="Filter showing high risk patients" src="https://github.com/user-attachments/assets/78398f20-1abd-41c5-8ecd-e39daca1f456" />

---

*Figure 5*: Neighborhood-level risk ranking identifying high-absenteeism locations with minimum sample thresholds.
<img width="757" height="326" alt="Top - 15 Highest Ranked Neighborhoods" src="https://github.com/user-attachments/assets/adf37cbc-4c49-4384-9db1-bb7d38d82a14" />

---

## Key Business InsightsLead
- **Lead-Time Impact**: Appointment default rates scale directly with scheduling lead times. Same-day appointments show a minimal **0.0%** default baseline, whereas bookings made 8+ days in advance account for the highest concentration of missed appointments.
  
- **Geographic Absenteeism**: Absenteeism is geographically concentrated. Filtering for high-volume locations (≥ 100 total appointments) highlights a distinct **top 15 high-risk neighborhood** cluster requiring localized intervention.

- **Demographic Stratification**: Attendance profiles vary across age groups. The Teen (13–19) and Young Adult (20–39) segments exhibit elevated drop-off rates compared to older adult and senior cohorts.

- **Predictive Risk Thresholds**: Historical attendance is the primary predictor of future behavior. Patients with a prior **≥ 50% absenteeism rate** or **≥ 8 days lead time** are classified under the High Risk operational tier, representing the target demographic for automated reminders. 

---

## Data Pipeline & SQL Development

1. Database Initialization & Schema Standardization
   <img width="959" height="509" alt="Database Initialization   Schema Standardization" src="https://github.com/user-attachments/assets/09c25611-f0d8-4fed-8a0f-3683c6c2d262" />

---

2. Data Cleaning & Anomaly Resolution: Standardized timestamp strings into Sequel-compliant temporal formats and eliminated invalid physical metrics *(Age = -1)* and temporal anomalies *(LeadTime < 0)*
<img width="959" height="504" alt="Data Cleaning   Anomaly Resolution" src="https://github.com/user-attachments/assets/4041e1f5-c45d-4f46-bc1d-fecd090476ba" />

---

3. Hypothesis Testing & Exploratory Queries
*Overall Absenteeism Rate*
<img width="959" height="503" alt="Overall Absenteeism Rate" src="https://github.com/user-attachments/assets/05fcd61f-fe44-4c15-9b6b-76bf86de1bf8" />

*Lead-Time Stratification*
<img width="959" height="502" alt="Lead-Time Stratification" src="https://github.com/user-attachments/assets/75c4fbe8-d1b2-451c-981d-304acbdc1a4f" />

*Neighborhood Risk Ranking*
<img width="959" height="501" alt="Neighborhood Risk Ranking" src="https://github.com/user-attachments/assets/d818f5f2-4bd9-4940-8828-f798c54e538a" />

---

4. Advanced Windowing & Predictive Risk Scoring Engine: To prevent data leakage, window frames restrict historical evaluation exclusively to prior events (ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING). Logic is encapsulated into a reusable database view (v_appointment_risk).
<img width="959" height="500" alt="Advanced Windowing" src="https://github.com/user-attachments/assets/f7b03064-56aa-4d61-a26d-57902635502b" />

---

## Business Applications & Operational Next Steps
- *Targeted Automated Reminders*: Prioritize automated voice calls and SMS confirmation workflows specifically for appointments classified under the High Risk tier and scheduling intervals exceeding 8 days.

- *Strategic Capacity Planning*: Implement controlled overbooking protocols during peak operational days and in geographic locations categorized within top-tier risk ranks to mitigate open schedule slots.

- *Interactive Clinic Dashboard*: Connect Tableau Public directly to exported datasets (v_appointment_risk) to deliver real-time operational visual tracking for clinic administrative staff.

---
