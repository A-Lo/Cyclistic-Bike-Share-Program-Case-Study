<h1 align = "center"> Case Study: Cyclistic Bike Share Company </h1>

<p align = "center"> The data used in this project: <a href = "https://divvy-tripdata.s3.amazonaws.com/index.html">Here</a>
</p>

<p align = "center">   
    <b>Note: The project contains 13-months worth of company data; dates range from April 2021 to April 2022.
    <br><br>
     Note: The datasets have a different name because Cyclistic is a fictional company. The data has been made available by Motivate International Inc. under this <a href = "https://divvy-tripdata.s3.amazonaws.com/index.html">license. </a> 
        <br><br>This is public data that you can use to explore how different customer types are using Cyclistic bikes. <b>
    </b>
</p>


---


## Introduction:
---
    
Cyclistic: A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use them to commute to work each day.

    
## Goal:
---
    
Determine how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Identify trends in the historical bike trip data.

    
### Tools Used:
---

- SQL (PostgreSQL, pgadmin4):
- Python (Pandas, SQLAlchemy):
- Tableau(Data visualization):
 - Excel Spreadsheets:
    
### Table Attributes: 

- RIDE_ID: Unique ride id; record of each bike ride 
- RIDEABLE_TYPE: The type of bike
- START_AT: The time the ride initiated 
- ENDED_AT: The time the ride finalized
- START_STATION_NAME: Name of the station that the ride initiated
- START_STARTION_ID: The ID associated with the start station.
- END_STATION_NAME: Name of the station that the ride finalized
- END_STARTION_ID: The ID associated with the end station
- START_LAT: The latitude coordinate where the ride started
- START_LNG: The longitude coordinate where the ride started
- END_LAT: The latitude coordinate where the ride ended
- END_LNG: The longitude coordinate where the ride ended
- MEMBER_CASUAL: The type of user; either membership or casual user.


