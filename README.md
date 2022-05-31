<h1 align = "center"> Case Study: Cyclistic Bike Share Company </h1>

<p align = "center"> The data used in this project: [Here](https://divvy-tripdata.s3.amazonaws.com/index.html)

    <br><br>
    **Note: The project contains 13-months worth of company data; dates range from April 2021 to April 2022.**
    <br>
    **Note: The datasets have a different name because Cyclistic is a fictional company. The data has been made available by Motivate International Inc. under this [license](https://divvy-tripdata.s3.amazonaws.com/index.html) This is public data that you can use to explore how different customer types are using Cyclistic bikes.**
    </b>
</p>


---


## Introduction:
---
Cyclistic: A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use them to commute to work each day.

## Goal:
---
Determine how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Identify trends in the historical bike trip data.

## Tools Used:
---

#### SQL (PostgreSQL, pgadmin4):
- I decided to go with PostgreSQL, because it’s the one I’m more comfortable with, and prefer. I went with the GUI interface, pgadmin4, because I wanted to have a visual representation of my query results; considering that the central table consists of over 6-million records, the biggest dataset I’ve worked with, I’d prefer to use a GUI to query the central table.

#### Python (Pandas, SQLAlchemy):
- pgAdmin4 doesn’t have a feature where you can simply pick a data file and import it into a database with the few clicks. There is one way to copy a table into a database, but you must manually create a shell-table, assign the column names and the datatypes exactly as it appears on the data file, in my case, a CSV file. If the attribute name and datatype don’t match, it doesn’t work. Furthermore, this might be simple for a sample table with few attributes, but when working with a table with ten plus columns, it’s not optimal.
  Therefore, I created a python script, using specified libraries—Pandas, SQLAlchemy— and imported all the CSV files into the desired server/database.

#### Tableau(Data visualization):
- Using the query results, from the Prepare Phase, I saved the query set tables into separate excel spreadsheet files. These spreadsheets are used in the Public Tableau software as the datasource; the free version doesn't allow for database data source connections, only the paid version does.

####	Excel Spreadsheets:
- Saved query tables saved into excel spreadsheets. These spreadsheets are used for the datasource connection to Public Tableau.
