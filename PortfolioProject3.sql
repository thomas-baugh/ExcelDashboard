---------------------------------
--Cleaning Data in SQL Queries
Select *
From PortfolioProject.dbo.NashvilleHousing

Select SaleDateConverted,Convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = Convert(Date,Saledate)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = Convert(Date,Saledate)

-------------------------------------------------
--Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
Where PropertyAddress is null
Order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
Set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is Null
--------------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State)
--Using Substrings to seperate the Original into Address and City
Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress)) as Address2
From PortfolioProject..NashvilleHousing

--Adding New Columns so that we can append those those substrings to the table
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress NVarChar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity NVarChar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress))

--Checking all three columns
Select PropertyAddress, PropertySplitAddress, PropertySplitCity
From PortfolioProject.dbo.NashvilleHousing
-----------------------------------------------------------------------------
--Breaking out Owner Address into Individual Columns(Address, City, State)
--using parsename

Select
ParseName(Replace(OwnerAddress,',','.'),3),
ParseName(Replace(OwnerAddress,',','.'),2),
ParseName(Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress = ParseName(Replace(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = ParseName(Replace(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set OwnerSplitState = ParseName(Replace(OwnerAddress,',','.'),1)


Select OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
From PortfolioProject.dbo.NashvilleHousing
----------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct SoldAsVacant
From PortfolioProject..NashvilleHousing

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END
From PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
						When SoldAsVacant = 'N' THEN 'No'
						Else SoldAsVacant
						END
From PortfolioProject..NashvilleHousing

--------------------------------------------
--Remove Duplicates

WITH RowNumCTE AS(
	
Select *,
	ROW_NUMBER() OVER (
	PARTITION By 
		ParcelID,
		SalePrice,
		SaleDate,
		LegalReference
	ORDER BY UniqueID
	)
	 row_num
From PortfolioProject..NashvilleHousing

)
DELETE
From RowNumCTE
Where Row_num>1

----------------------------
--Delete Unused Columns

Alter TABLE PortfolioProject..NashvilleHousing
Drop COLUMN	OwnerAddress,TaxDistrict,PropertyAddress


Alter TABLE PortfolioProject..Nashvillehousing
Drop COlUMN SaleDate
---------------------------------------------