/*

Cleaning Data in SQL Queries

*/
--=================================================
SELECT *
FROM portfolioproject_1..housecleaningdata

--===================================================
---- Standardize SALE  Date Format

SELECT SaleDate ,CONVERT(Date,SaleDate)
FROM portfolioproject_1..housecleaningdata


UPDATE portfolioproject_1..housecleaningdata
SET SaleDate = CONVERT(Date,SaleDate)

-- it did not work so we will use the other method that is by adding a new column  

ALTER TABLE housecleaningdata
ADD saledateconverted Date

UPDATE housecleaningdata
SET saledateconverted = CONVERT(Date,SaleDate)

SELECT saledateconverted
FROM portfolioproject_1..housecleaningdata

--=============================================================
--POPULATE PROPERTY ADDRESS DATA

SELECT PropertyAddress,ParcelID
FROM portfolioproject_1..housecleaningdata
--WHERE PropertyAddress is  NULL
ORDER BY ParcelID 

-- We notice that for same pracel ids the property address is also same
--so we can do is if there is a null for property address 
--lets check for the same parcel id and old property address and then fill it with that same address 

SELECT a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM portfolioproject_1..housecleaningdata AS a
JOIN  portfolioproject_1..housecleaningdata AS b
  ON a.ParcelID=b.ParcelID
  AND a.[UniqueID ]!=b.[UniqueID ]    --   not equal can also be represented as <>
WHERE a.PropertyAddress is NULL

-- Now let us update the property address

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM portfolioproject_1..housecleaningdata AS a
JOIN  portfolioproject_1..housecleaningdata AS b
  ON a.ParcelID=b.ParcelID
  AND a.[UniqueID ]!=b.[UniqueID ]    --   not equal can also be represented as <>
WHERE a.PropertyAddress is NULL 




-- CREATED A WRONG COLUMN  SO HAD TO REMOVE 
--ALTER TABLE housecleaningdata
--DROP COLUMN saledataconverted;

SELECT *
FROM portfolioproject_1..housecleaningdata

UPDATE portfolioproject_1..housecleaningdata
SET SaleDate  = saledateconverted

--========================================================================

--BREAKING OUT ADDRESS INTO DIFFERENT COLUMNS AS  HOUSE NUMBER CITY STATE   
-- Populate Property Address data

Select *
FROM portfolioproject_1..housecleaningdata
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM portfolioproject_1..housecleaningdata a
JOIN PortfolioProject.dbo.housecleaningdata b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM portfolioproject_1..housecleaningdata a
JOIN PortfolioProject.dbo.housecleaningdata b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
FROM portfolioproject_1..housecleaningdata
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

FROM portfolioproject_1..housecleaningdata


ALTER TABLE housecleaningdata
Add PropertySplitAddress Nvarchar(255);

Update housecleaningdata
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housecleaningdata
Add PropertySplitCity Nvarchar(255);

Update housecleaningdata
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
FROM portfolioproject_1..housecleaningdata





Select OwnerAddress
FROM portfolioproject_1..housecleaningdata


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM portfolioproject_1..housecleaningdata



ALTER TABLE housecleaningdata
Add OwnerSplitAddress Nvarchar(255);

Update housecleaningdata
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housecleaningdata
Add OwnerSplitCity Nvarchar(255);

Update housecleaningdata
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housecleaningdata
Add OwnerSplitState Nvarchar(255);

Update housecleaningdata
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
FROM portfolioproject_1..housecleaningdata




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM portfolioproject_1..housecleaningdata
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM portfolioproject_1..housecleaningdata


Update housecleaningdata
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM portfolioproject_1..housecleaningdata
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
FROM portfolioproject_1..housecleaningdata




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
FROM portfolioproject_1..housecleaningdata


ALTER TABLE PortfolioProject.dbo.housecleaningdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


