/*

Cleaning data in SQL queries

*/

SELECT *
FROM PortofolioProject..HousingData

---------------------------------------------------------------------------------------------------------------------------------

--Standardize date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortofolioProject..HousingData

UPDATE PortofolioProject..HousingData
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE PortofolioProject..HousingData
ADD SaleDateConverted Date;


UPDATE PortofolioProject..HousingData
SET SaleDateConverted = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------------------------------------------------------------------

--Populate property address data

SELECT PropertyAddress
FROM PortofolioProject..HousingData
WHERE PropertyAddress is null


SELECT *
FROM PortofolioProject..HousingData
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM PortofolioProject..HousingData a
JOIN PortofolioProject..HousingData b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortofolioProject..HousingData a
JOIN PortofolioProject..HousingData b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortofolioProject..HousingData a
JOIN PortofolioProject..HousingData b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


----------------------------------------------------------------------------------------------------------------------------------

--Breaking out address into indivindual columns (Address, City, State)


SELECT PropertyAddress
FROM PortofolioProject..HousingData


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
FROM PortofolioProject..HousingData


ALTER TABLE PortofolioProject..HousingData
ADD PropertySplitAddress varchar(255);

UPDATE PortofolioProject..HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortofolioProject..HousingData
ADD PropertySplitCity varchar(255);

UPDATE PortofolioProject..HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT *
FROM PortofolioProject..HousingData


--Breaking down Owner Adress

SELECT OwnerAddress
FROM PortofolioProject..HousingData


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM PortofolioProject..HousingData


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortofolioProject..HousingData




ALTER TABLE PortofolioProject..HousingData
ADD OwnerSplitAddress varchar(255);

UPDATE PortofolioProject..HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortofolioProject..HousingData
ADD OwnerSplitCity varchar(255);

UPDATE PortofolioProject..HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortofolioProject..HousingData
ADD OwnerSplitState varchar(255);

UPDATE PortofolioProject..HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)







------------------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortofolioProject..HousingData
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM PortofolioProject..HousingData



UPDATE PortofolioProject..HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END





	----------------------------------------------------------------------------------------------------------------------------

	--Remove Duplicates

	WITH RowNumCTE AS(
	SELECT *,
	   ROW_NUMBER() OVER (
	   PARTITION BY ParcelId,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
					   UniqueID
					   ) row_num

FROM PortofolioProject..HousingData
--ORDER BY ParcelID
)
DELETE
From RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress




------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns



SELECT *
FROM PortofolioProject..HousingData


ALTER TABLE PortofolioProject..HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortofolioProject..HousingData
DROP COLUMN SaleDate






