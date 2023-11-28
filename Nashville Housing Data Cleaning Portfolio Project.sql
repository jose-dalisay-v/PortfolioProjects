/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProject..NashvilleHousing


-------------------------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(date, SaleDate)
From PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)

-------------------------------------------------------------------------------------------------------

--Populate Property Address data

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select *
From PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID

-------------------------------------------------------------------------------------------------------

--Breaking out Property Address into Individual Columns (Address, City)

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
From PortfolioProject..NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255),
PropertySplitCity nvarchar(255)

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1),
PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

--Breaking out Owner Address into Individual Columns (Address, City, State)

Select 
PARSENAME(Replace(OwnerAddress, ',', '.'), 3) as OwnerAddress,
PARSENAME(Replace(OwnerAddress, ',', '.'), 2) as OwnerCity,
PARSENAME(Replace(OwnerAddress, ',', '.'), 1) as OwnerState
From PortfolioProject..NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255),
OwnerSplitCity nvarchar(255),
OwnerSplitState nvarchar(255)

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)


-------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" column

Select distinct(SoldAsVacant)
From PortfolioProject..NashvilleHousing

Select distinct(SoldAsVacant),
Case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
From PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = Case 
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

-------------------------------------------------------------------------------------------------------

--Remove Duplicates

--Using Row numbers

With RowNumCTE as(
Select *,
ROW_NUMBER() over (partition by 
	ParcelID, 
	PropertyAddress, 
	SalePrice, SaleDate, 
	LegalReference
	Order by UniqueID) as Row_Num
From PortfolioProject..NashvilleHousing
)
DELETE
From RowNumCTE
Where Row_Num > 1

