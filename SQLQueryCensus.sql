
--- We want to extract the median income per household from the Census Data, as well as the count of each household type in each area.
--- Additionally, we will divide these households by different types to extract the incomes by household type, as well as the 
--- count per Zipcode. As we'll see, the data is quite noisy, so we'll first clean it to ensure that data types are correct and that null 
--- values are being treated correctly.


--- First, how those data look? 
SELECT TOP 10 *
FROM Census_Data;

--- The Median is of special interest as we don't know the underlying shapes of the data. 
--- As medians are more resistant to outliers we will order by this value our table. 
--- Only the columns of interest will be kept, which are those that tell as the total
--- count, the count per family type, and the total median and mean per type of family
--- and total count. We are keeping the mean just in case some of the missing median values
--- can be imputed using this variable.
SELECT TOP 10000 Geographic_Area, Geographic_Area_Name, Total_Households_Estimate, 
Total_Households_Median_Income,Total_Households_Mean_Income,Total_Families_Estimate, 
Total_Families_Median_Income, Total_Families_Mean_Income,[Total_Married-couple_Families_Estimate], 
[Total_Married-couple_Families_Median_Income],[Total_Married-couple_Families_Mean_Income], 
Total_NonFamily_Households_Estimate, Total_NonFamily_Households_Median_Income, Total_NonFamily_Households_Mean_Income
FROM Census_Data
ORDER BY Total_Households_Median_Income;

SELECT TOP 4000 Geographic_Area, Geographic_Area_Name, Total_Households_Estimate, Total_Households_Median_Income,Total_Households_Mean_Income,Total_Families_Estimate, 
Total_Families_Median_Income, Total_Families_Mean_Income,[Total_Married-couple_Families_Estimate], [Total_Married-couple_Families_Median_Income],
[Total_Married-couple_Families_Mean_Income], Total_NonFamily_Households_Estimate, Total_NonFamily_Households_Median_Income, Total_NonFamily_Households_Mean_Income
FROM Census_Data
ORDER BY Total_Families_Estimate;

--- Missing values in the Median Columns are inputed as
--- "-", ** or even *** while in the Mean columns -, *** and N appear in the missing values. 
--- I the case of total families (X) appears instead of null values.

UPDATE Census_Data
SET Total_Households_Median_Income = NULLIF(Total_Households_Median_Income, '-'),
    Total_Households_Mean_Income = NULLIF(Total_Households_Mean_Income, '-'),
	Total_Families_Median_Income = NULLIF(Total_Families_Median_Income, '-'),
    Total_Families_Mean_Income = NULLIF(Total_Families_Mean_Income, '-'),
	[Total_Married-couple_Families_Median_Income] = NULLIF([Total_Married-couple_Families_Median_Income], '-'),
    [Total_Married-couple_Families_Mean_Income] = NULLIF([Total_Married-couple_Families_Mean_Income], '-'),
	Total_NonFamily_Households_Median_Income = NULLIF(Total_NonFamily_Households_Median_Income, '-');

UPDATE Census_Data
SET Total_Households_Median_Income = NULLIF(Total_Households_Median_Income, '**'),
    Total_Households_Mean_Income = NULLIF(Total_Households_Mean_Income, '**'),
	Total_Families_Median_Income = NULLIF(Total_Families_Median_Income, '**'),
    Total_Families_Mean_Income = NULLIF(Total_Families_Mean_Income, '**'),
	[Total_Married-couple_Families_Median_Income] = NULLIF([Total_Married-couple_Families_Median_Income], '**'),
    [Total_Married-couple_Families_Mean_Income] = NULLIF([Total_Married-couple_Families_Mean_Income], '**'),
	Total_NonFamily_Households_Median_Income = NULLIF(Total_NonFamily_Households_Median_Income, '**'),
	Total_NonFamily_Households_Mean_Income = NULLIF(Total_NonFamily_Households_Mean_Income, '**');

UPDATE Census_Data
SET Total_Households_Median_Income = NULLIF(Total_Households_Median_Income, '***'),
    Total_Households_Mean_Income = NULLIF(Total_Households_Mean_Income, '***'),
	Total_Families_Median_Income = NULLIF(Total_Families_Median_Income, '***'),
    Total_Families_Mean_Income = NULLIF(Total_Families_Mean_Income, '***'),
	[Total_Married-couple_Families_Median_Income] = NULLIF([Total_Married-couple_Families_Median_Income], '***'),
    [Total_Married-couple_Families_Mean_Income] = NULLIF([Total_Married-couple_Families_Mean_Income], '***'),
	Total_NonFamily_Households_Median_Income = NULLIF(Total_NonFamily_Households_Median_Income, '***'),
	Total_NonFamily_Households_Mean_Income = NULLIF(Total_NonFamily_Households_Mean_Income, '***');

UPDATE Census_Data
SET Total_Households_Mean_Income = NULLIF(Total_Households_Mean_Income, 'N'),
	Total_Families_Mean_Income = NULLIF(Total_Families_Mean_Income, 'N'),
	[Total_Married-couple_Families_Mean_Income] = NULLIF([Total_Married-couple_Families_Mean_Income], 'N'),
	Total_NonFamily_Households_Mean_Income = NULLIF(Total_NonFamily_Households_Mean_Income, 'N');


UPDATE Census_Data
SET Total_Households_Estimate = NULLIF(Total_Households_Estimate, '(X)'),
	Total_Families_Estimate = NULLIF(Total_Families_Estimate, '(X)'),
	[Total_Married-couple_Families_Estimate] = NULLIF([Total_Married-couple_Families_Estimate], '(X)'),
	Total_NonFamily_Households_Estimate = NULLIF(Total_NonFamily_Households_Estimate, '(X)');

SELECT TOP 10000 Geographic_Area, Geographic_Area_Name, Total_Households_Estimate, Total_Households_Median_Income,Total_Households_Mean_Income,Total_Families_Estimate, 
Total_Families_Median_Income, Total_Families_Mean_Income,[Total_Married-couple_Families_Estimate], [Total_Married-couple_Families_Median_Income],
[Total_Married-couple_Families_Mean_Income], Total_NonFamily_Households_Estimate, Total_NonFamily_Households_Median_Income, Total_NonFamily_Households_Mean_Income
FROM Census_Data
ORDER BY Total_Families_Estimate;


--- Median is a more reliable source for this data as the underlying shpe of the populations are unknown.
--- However some areas, only have available the mean data. In the case only mean value are available for 
--- a type of family or total count we will input this total count into the median column.
UPDATE Census_Data
SET Total_Households_Median_Income = CASE WHEN Total_Households_Median_Income IS NULL THEN Total_Households_Mean_Income ELSE Total_Households_Median_Income END,
    Total_Families_Median_Income = CASE WHEN Total_Families_Median_Income IS NULL THEN Total_Families_Mean_Income ELSE Total_Families_Median_Income END,
    [Total_Married-couple_Families_Median_Income] = CASE WHEN [Total_Married-couple_Families_Median_Income] IS NULL THEN [Total_Married-couple_Families_Mean_Income] ELSE [Total_Married-couple_Families_Median_Income] END,
    Total_NonFamily_Households_Median_Income = CASE WHEN Total_NonFamily_Households_Median_Income IS NULL THEN Total_NonFamily_Households_Mean_Income ELSE Total_NonFamily_Households_Median_Income END;


--- Now Median Columns, and total households columns will be transformed into the appropiate data type.
--- We will create a view that we can use to plot our maps. We will replace the ZCTA part of the Zip Code
--- and transform it into a INT to be able to use it correctly.
CREATE VIEW Final_data AS
SELECT Geographic_Area, 
CAST(REPLACE(Geographic_Area_Name,'ZCTA5 ','') AS INT) AS ZIPCode, 
CAST(Total_Households_Estimate AS FLOAT) AS Households, 
CAST(Total_Households_Median_Income AS FLOAT) AS Median_Per_Households,
CAST(Total_Families_Estimate AS FLOAT) AS Family_Household,
CAST(Total_Families_Median_Income AS FLOAT) AS Median_Per_Family_Households,
CAST([Total_Married-couple_Families_Estimate] AS FLOAT) AS Married_Households,
CAST([Total_Married-couple_Families_Median_Income] AS FLOAT) AS Median_Per_Married_Households,
CAST(Total_NonFamily_Households_Estimate AS FLOAT) AS NonFamily_Households,
CAST(Total_NonFamily_Households_Median_Income AS FLOAT) AS Median_Per_NonFamily_Households
FROM Census_Data;

SELECT  *
FROM    Final_data;


--- After this maps were created using Tableau. However, the specific family types give no
--- interesting information so the visualization will be limited to the total household visualizations. 
