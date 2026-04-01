# UEFA Champions League Finals Analysis

# Project Overview
This project analyzes historical UEFA Champions League finals data to uncover insights on team performance, goal trends, attendance patterns, and hosting distribution.
It follows a complete modern data analytics workflow:

Data Cleaning & Transformation (Staging → Warehouse)
Data Modeling (Warehouse Schema)
Data Analysis (Analytics Schema with Views)
Data Visualization (Power BI Dashboard) 

# Objectives
The project answers key analytical questions such as:
- Which clubs and countries dominate the competition?
- How have goals and attendance evolved over time?
- What are the most common match outcomes?
- Which locations host finals most frequently? 

# 🛠️ Tools & Technologies
- **PostgreSQL:** Data cleaning, transformation, and modeling
- **SQL:** Analytical queries and view creation
- **Power BI:** Interactive dashboard
- **AI Tools:** Static visuals for portfolio presentation 

# Data Architecture
This project follows a 3-layer data architecture:
```
staging → warehouse → analytics 
```
### 1. Staging Schema
- Raw data loaded from CSV
- Minimal transformation 
### 2. Warehouse Schema
- Cleaned and structured data

**Key transformations:** 
- Trimmed text fields
- Cleaned score values (* for penalties)

**Extracted:** 
- Closing year 
- Host country

**Created:** 
- Winner score 
- Loser score
- Goal difference
- Total goals 
### 3. Analytics Schema
- Contains views that answer business questions
- Optimized for reporting and visualization
- Each view corresponds to a specific analytical question 

# Analytics Views
Each business question is implemented as a SQL view in the analytics schema.
1. Top Five Clubs with the Most Wins
``` sql
-- Top 5 clubs with the most wins

CREATE VIEW analytics.most_win_clubs AS
SELECT
    winner_team,
    COUNT(*) AS total_win
FROM
    warehouse.ucl_finals
GROUP BY
    winner_team
ORDER BY 
    total_win DESC
LIMIT 5; 
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.barplot(x='total_win', y='winner_team', data=df, palette='viridis', hue='winner_team')
plt.title('Top 5 Clubs by Champions League Wins')
plt.xlabel('Total Wins')
plt.ylabel('Club')
plt.tight_layout()
plt.savefig('images/01_most_win_clubs.png')
plt.show()
```

Results
![Most_Win_Clubs](Images/01_most_win_clubs.png)

Insights
- Real Madrid dominates the competition with 15 Champions League titles, they are far ahead of every other club more than double some of the teams on the list.
- There’s a tight race for second place.AC Milan and Bayern Munich are tied at 7 titles each, showing strong but comparable European success.
- The gap narrows toward the bottom.Liverpool FC (6 titles) and FC Barcelona (5 titles) are close in performance, with only a 1 title difference separating them.

2. Top Five Nations by Number of Titles
``` sql
-- What is the top 5 nations with number of titles

CREATE VIEW analytics.nations_by_title AS
SELECT 
    winner_country,
    COUNT(*) AS total_title
FROM
    warehouse.ucl_finals
GROUP BY
    winner_country
ORDER BY
    total_title DESC
LIMIT 5;
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.barplot(x='total_title', y='winner_country', data=df, palette='magma', hue='winner_country')
plt.title('Top 5 Countries by Champions League Titles')
plt.xlabel('Total Titles')
plt.ylabel('Country')
plt.tight_layout()
plt.savefig('images/02_country_by_title.png')
plt.show()
```

Results
![Country_by_Title](Images/02_country_by_title.png)

Insights
- Spain dominates completely with 20 titles, 33% more than second-place England (15), reflecting Real Madrid and Barcelona's sustained European dominance.
- Western Europe holds a monopoly. All top 5 nations are from Western Europe, with no Eastern European country breaking through.
- West Germany (5) vs Netherlands (6) are tightly matched despite West Germany ceasing to exist as a football entity in 1990, showing how prolific their clubs were in a shorter window.

3. Average Attendance Over Time
``` sql
-- What is the average attendance over time

CREATE VIEW analytics.average_attendance AS
SELECT
    closing_year,
    ROUND(AVG(attendance), 0) AS average_attendance
FROM
    warehouse.ucl_finals
GROUP BY
    closing_year
ORDER BY
    closing_year DESC
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.lineplot(x='closing_year', y='average_attendance', data=df)
plt.title('Average Attendance Over Time')
plt.xlabel('Closing Year')
plt.ylabel('Average Attendance')
plt.tight_layout()
plt.savefig('images/03_average_attendance_by_season.png')
plt.show()
```

Results
![Average_Attendance_by_Season](Images/03_average_attendance_by_season.png)

Insights
- The 1950s–60s saw peak attendances, regularly exceeding 100,000 reflecting the era of massive open stadiums with few safety restrictions.
- A dramatic crash around 2020–2021 attendance dropped near zero, clearly attributable to the COVID-19 pandemic forcing behind closed doors matches.
- Post 2021 recovery is strong but has not returned to pre-2000 levels, suggesting modern stadium capacity limits and ticketing structures cap attendance around 70,000–90,000.

4. Most Common Scoreline
``` sql
-- What is the most common scoreline

CREATE VIEW analytics.common_scoreline AS
SELECT
    score,
    COUNT(*) AS frequency
FROM
    warehouse.ucl_finals
GROUP BY
    score
ORDER BY
    frequency DESC
LIMIT 10
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.barplot(x='frequency', y='score', data=df, palette='magma', hue='score')
plt.title('Most Common Scorelines')
plt.xlabel('Frequency')
plt.ylabel('Scoreline')
plt.tight_layout()
plt.savefig('images/04_common_scorelines.png')
plt.show()
```

Results
![Common_Scoreline](Images/04_common_scorelines.png)

Insights
- 1-0 is by far the most frequent final scoreline (18 times) nearly double the next most common, revealing how often Champions League finals are cagey, low-scoring affairs.
- 2-1 and 2-0 are equally common (9 times each), together with 1-0 accounting for the majority of finals outcomes, tight margins define these matches.
- Penalty shootout results (marked with *) like 1-1* and 0-0* appear 6 and 4 times respectively, showing that roughly 15% plus of finals are decided on penalties.

5. Average Goals per Final
``` sql
--What is the average goals per final

CREATE VIEW analytics.final_goals AS
SELECT
    ROUND(AVG(total_goals), 2) AS average_goals
FROM
    warehouse.ucl_finals
```

Visualized Data
``` python
plt.figure(figsize=(4, 4))
plt.text(0.5, 0.5, f"Average Goals in Finals:\n{df['average_goals'].iloc[0]:.2f}",
         fontsize=14, ha='center', va='center', color='black')
plt.axis('off') 
plt.tight_layout()
plt.savefig('images/05_average_goals_in_finals.png')
plt.show()
```

Results
![Average_Goals](Images/05_average_goals_in_finals.png)

Insights
- 2.66 average goals per final is relatively low, confirming that finals tend to be defensively disciplined encounters.
- This average is below the typical league match average of approximately 2.7–3.0 goals, reinforcing the "finals are tight" narrative.
- Combined with the scoreline data, it suggests most finals are decided by a single goal margin, making them closely contested.

6. Attendance Trend Over Time
``` sql
-- What is the attendance over time

CREATE VIEW analytics.attendance AS
SELECT
    closing_year,
    attendance
FROM
    warehouse.ucl_finals
ORDER BY
    closing_year DESC
```

Visualized Data

It is the same as average attendance chart

Insights
- Attendance hit its all-time high of 120,000–127,000, driven by unrestricted stadium capacities. This was the ceiling the trend never returned to.

- A consistent downward drift from 90,000 plus to approximately 50,000–70,000, driven by stricter safety regulations and the shift to all-seater stadiums.

- Attendance stabilized around 60,000–90,000, collapsed near zero in 2021 due to COVID, then recovered, settling into a permanently lower modern ceiling.

7. Country that Hosted the Most Finals
``` sql
-- Which country has hosted the most finals

CREATE VIEW analytics.host_country AS
SELECT
    host_country,
    COUNT(*) AS total_finals
FROM
    warehouse.ucl_finals
GROUP BY
    host_country
ORDER BY
    total_finals DESC
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.barplot(x='total_finals', y='host_country', data=df.head(10), palette='magma', hue='host_country')
plt.title('Top 5 Host Countries')
plt.xlabel('Finals Hosted')
plt.ylabel('Country')
plt.tight_layout()
plt.savefig('images/07_host_countries.png')
plt.show()
```

Results
![Host_Countries](Images/07_host_countries.png)

Insights
- England and Italy lead hosting with 9 finals, each reflecting their early dominance in European football infrastructure and prestige.
- Spain (8) follows closely, with the Santiago Bernabéu and other venues making it a favoured destination for UEFA finals.
- Smaller nations like Belgium (5), Austria (4), and Portugal (4) have hosted surprisingly frequently, showing UEFA's commitment to spreading the tournament across Europe.

8. Stadium that Hosted the Most Finals
``` sql
-- Which stadium has hosted the most finals

CREATE VIEW analytics.host_stadium AS
SELECT
    venue,
    host_stadium,
    COUNT(*) AS total_finals
FROM
    warehouse.ucl_finals
GROUP BY
    venue,
    host_stadium
ORDER BY
    total_finals DESC
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.barplot(x='total_finals', y='host_stadium', data=df.head(10), palette='viridis', hue='host_stadium')
plt.title('Top 10 Host Stadiums')
plt.xlabel('Finals Hosted')
plt.ylabel('Stadium')
plt.tight_layout()
plt.savefig('images/08_host_stadiums.png')
plt.show()
```

Results
![Host_Stadiums](Images/08_host_stadiums.png)

Insights
- Wembley Stadium leads decisively with 8 finals hosted, almost double the second-place Heysel Stadium (5), cementing its status as European football's most iconic venue.
- Heysel Stadium's 5 finals is notable given, it was the site of the 1985 disaster after which it was retired. All its finals were concentrated in a specific historical era.
- Four stadiums are tied at 4 finals (San Siro, Santiago Bernabéu, Stadio Olimpico, Olympic Stadium), showing a competitive cluster of world-class venues.

9. Trend of Total Goals Over Time
``` sql
-- What is the trend of goals over time

CREATE VIEW analytics.goals_over_time AS
SELECT
    closing_year,
    SUM(total_goals) AS total_goals
FROM
    warehouse.ucl_finals
GROUP BY
    closing_year
ORDER BY
    closing_year DESC
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.lineplot(x='closing_year', y='total_goals', data=df)
plt.title('Total Goals Over Time')
plt.xlabel('Closing Year')
plt.ylabel('Total Goals')
plt.tight_layout()
plt.savefig('images/09_goals_over_time.png')
plt.show()
```

Results
![Goals_Over_Time](Images/09_goals_over_time.png)

Insights
- The late 1950s early 1960s were the highest-scoring era with some finals producing 7–10 goals, a stark contrast to the modern era.
- A clear downward trend from the 1960s onward reflects the evolution of tactical football, with defensive organization becoming increasingly sophisticated.
- Modern finals (post-2000) rarely exceed 5 goals, clustering mostly between 2–4 confirming that elite defensive coaching has fundamentally changed the nature of finals.

10. Club with the Most Runner-Up Finishes
``` sql
-- Clubs with most runner-up finishes

CREATE VIEW analytics.runner_up AS 
SELECT
    runner_up_team,
    runner_up_country,
    COUNT(*) AS total_runner_up
FROM
    warehouse.ucl_finals
GROUP BY
    runner_up_team,
    runner_up_country
ORDER BY
    total_runner_up DESC
LIMIT 10
```

Visualized Data
``` python
plt.figure(figsize=(8, 5))
sns.barplot(x='total_runner_up', y='runner_up_team', data=df, palette='viridis', hue='runner_up_team')
plt.title('Top Runner-Up Teams')
plt.xlabel('Total Runner-Up Finishes')
plt.ylabel('Club')
plt.tight_layout()
plt.savefig('images/10_runner_up_teams.png')
plt.show()
```

Results
![Runner_Up_Teams](Images/10_runner_up_teams.png)

Insights
- Juventus holds the unfortunate record of 7 runner-up, finishes the most of any club, highlighting a painful pattern of near-misses despite their domestic dominance.
- Benfica's 5 runner-up finishes with 0 wins in those appearances is particularly striking, they are arguably the most "unlucky" club in European football history.
- Real Madrid and Bayern Munich appear as runner-ups only 3 times each, which compared to their title tallies shows their remarkable ability to convert final appearances into victories.

# Power BI Dashboard
An interactive dashboard was built using the warehouse and analytics layer to visualize key insights.
## Features:
**KPI Cards:**
- Total Finals
- Average Goals per Final

**Team Analysis:** 
- Top Clubs by Wins
- Runner-Up Clubs 
- Country Analysis: Top Countries by Titles 

**Trends:** 
- Goals Over Time
- Attendance Over Time 

**Hosting Insights:** 
- Host Countries 

**Dashboard Preview:**
![Images/UEFA_CHAMPIONS_LEAGUE_FINAL](Images/UEFA_CHAMPIONS_LEAGUE_FINAL.PNG)

# Key Insights
- Spain leads all countries with 20 titles, while Juventus ironically holds the record for most runner-up finishes (7) without a proportional title return, highlighting the gap between consistent contenders and true winners.
- Finals are tight, low-scoring affairs
with an average of 2.66 goals per final and 1-0 being the most common scoreline (18 times), Champions League finals are consistently defensive battles. Over 15% are decided by penalties, reinforcing how closely matched the finalists tend to be.
- England dominates hosting. England and Italy lead with 9 finals hosted each, and Wembley alone accounts for 8 finals nearly double any other single stadium. This reflects England's long-standing status as European football's premier infrastructure hub.
- Crowds have permanently shrunk. Attendance peaked at 127,000 in the late 1950s and has never recovered, settling into a modern plateau of 60,000–90,000. The COVID-induced crash to near zero in 2021 was a temporary shock, but the structural downward trend has been in place since the 1960s. 

# Project Highlights
- End-to-end data analytics workflow
- Structured data architecture (Staging → Warehouse → Analytics)
- Use of SQL views for scalable analysis
- Interactive Power BI dashboard
- Well-documented GitHub project 

# Conclusion
This project demonstrates:
- Data cleaning and transformation
- Data modeling and architecture design
- SQL-based analytical thinking
- Visualization and storytelling