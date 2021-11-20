
--  CLEANING DATA IN SQL QUERIES

Select * 
from [dbo].[NashvilleHousing]

--STANDARIZE DATE FORMAT

Select SaleDate, CONVERT (Date, SaleDate)
from [dbo].[NashvilleHousing]

Update NashvilleHousing
SET SaleDate = CONVERT (Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT (Date,SaleDate)


-- POPULATE PROPERTY ADDRESS DATA

Select PropertyAddress
from [dbo].[NashvilleHousing]
--where PropertyAddress is Null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
from [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b  
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
from [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b  
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

Select PropertyAddress 
from NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
from NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select *
from NashvilleHousing 


Select OwnerAddress
from NashvilleHousing 

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from NashvilleHousing 

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

select * from NashvilleHousing


--CHANGE  Y AND N TO Yes AND No IN "SOLD AS VACANT" FIELD

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant
, CASE when SoldAsVacant = 'y' THEN 'Yes'
	   when SoldAsVacant = 'n' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing

update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'y' THEN 'Yes'
	   when SoldAsVacant = 'n' THEN 'No'
	   ELSE SoldAsVacant
	   END

	
--REMOVE DUPLICATES

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() over (
	Partition by ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from [dbo].[NashvilleHousing]
)



Select *
From RowNumCTE
where row_num > 1
order by PropertyAddress

Delete
From RowNumCTE
where row_num > 1
--order by PropertyAddress




-- DELETE UNUSED COLUMNS

Select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate