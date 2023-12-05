--cleaning Data in SqL

select*
from PortfolioProject.dbo.NashvilleHousing2



--standardize date format/ change sale date. changing the title of the column. COnvert the format

select SaleDate, convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing2


Update NashvilleHousing2
set saledate = convert(Date,SaleDate)

alter table Nashvillehousing2
Add SaleDateConverted date;  

update NashvilleHousing2
set saledateconverted= convert(date,saledate)


--to check to see if the column was converted
select saledateconverted, convert (date,saledate)
from PortfolioProject.dbo.NashvilleHousing2

--populate property address data

select propertyaddress
from PortfolioProject.dbo.NashvilleHousing2
where propertyaddress is null

Select *
from PortfolioProject.dbo.NashvilleHousing2
where propertyaddress is null
--research

Select *
from PortfolioProject.dbo.NashvilleHousing2
order by parcelid 


-- if the parcelid has an address populate it so that it does with that parcelid ran
-- we will be joining a table if this equals to this than that table needs to be equal to that

Select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress
from PortfolioProject.dbo.NashvilleHousing2 a
join   PortfolioProject.dbo.NashvilleHousing2 b
on a.parcelid= b.parcelid
and a.[uniqueID] <> b.[UniqueID]
where a.propertyaddress is null


--is null. added another column for the update
Select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull (a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing2 a
join   PortfolioProject.dbo.NashvilleHousing2 b
on a.parcelid= b.parcelid
and a.[uniqueID] <> b.[UniqueID]
where a.propertyaddress is null

--update info

update a 
set propertyaddress = isnull (a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing2 a
join   PortfolioProject.dbo.NashvilleHousing2 b
on a.parcelid= b.parcelid
and a.[uniqueID] <> b.[UniqueID]
where a.propertyaddress is null

--to check if there are any with null 
Select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull (a.propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing2 a
join   PortfolioProject.dbo.NashvilleHousing2 b
on a.parcelid= b.parcelid
and a.[uniqueID] <> b.[UniqueID]
where a.propertyaddress is null


-- breaking out address into individual columns (address, city, state)

select propertyaddress
from PortfolioProject.dbo.NashvilleHousing2

--substings and taking away the commas in the address line.

select
SUBSTRING(Propertyaddress, 1,CHARINDEX(',', propertyaddress)-1) as Address
from PortfolioProject.dbo.NashvilleHousing2

-- next one more tricky 
select
SUBSTRING(Propertyaddress, 1,CHARINDEX(',', propertyaddress)-1) as Address
, SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress)+1, Len(Propertyaddress)) as Address
from PortfolioProject.dbo.NashvilleHousing2


-- adding new chart to split the address and the city from apart from each other. 
alter table Nashvillehousing2
Add PropertySplitAddress Nvarchar(255);  

update NashvilleHousing2
set PropertySplitAddress = SUBSTRING(Propertyaddress, 1,CHARINDEX(',', propertyaddress)-1)

alter table Nashvillehousing2
Add PropertySplitecity Nvarchar(255);  

update NashvilleHousing2
set PropertySplitecity= SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress)+1, Len(Propertyaddress)) 
-- to check

select*
from PortfolioProject.dbo.NashvilleHousing2

--split owner address from city again. parsenmae looks for period .


select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing2
-- broken out the street city and state
select
parsename(replace(owneraddress,',', '.'),3)
,parsename(replace(owneraddress,',', '.'),2)
,parsename(replace(owneraddress,',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing2

alter table portfolioproject.dbo.nashvillehousing2
Add ownersplitaddress Nvarchar(255);  

update portfolioproject.dbo.nashvillehousing2
set ownersplitaddress = parsename(replace(owneraddress,',', '.'),3)

alter table portfolioproject.dbo.nashvillehousing2
Add ownersplitcity Nvarchar(255);  

update portfolioproject.dbo.nashvillehousing2
set ownersplitcity= parsename(replace(owneraddress,',', '.'),2)

alter table portfolioproject.dbo.nashvillehousing2
Add ownersplitstate Nvarchar(255);  

update portfolioproject.dbo.nashvillehousing2
set ownersplitstate= parsename(replace(owneraddress,',', '.'),1)

Select *
from portfolioproject.dbo.nashvillehousing2

--change y and N in sold as vacant field

select distinct(soldasvacant)
from portfolioproject.dbo.nashvillehousing2

select distinct(soldasvacant), count(soldasvacant)
from portfolioproject.dbo.nashvillehousing2
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' Then 'yes'
when SoldAsVacant = 'n' then 'no'
else SoldAsVacant
end
from portfolioproject.dbo.nashvillehousing2

update portfolioproject.dbo.nashvillehousing2
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'yes'
when SoldAsVacant = 'n' then 'no'
else SoldAsVacant
end

--removing Duplicates -- dont do it often

--creating a CTE

with rownumCTE as(
select *,
row_number() over (
Partition by parcelid,
propertyaddress,
saleprice,
SaleDate,
Legalreference
order by
uniqueID
) row_num

from portfolioproject.dbo.nashvillehousing2
)

select*
from rownumCTE
where row_num > 1
order by propertyaddress

-- to do it you can check above first
with rownumCTE as(
select *,
row_number() over (
Partition by parcelid,
propertyaddress,
saleprice,
SaleDate,
Legalreference
order by
uniqueID
) row_num

from portfolioproject.dbo.nashvillehousing2
)

delete 
from rownumCTE
where row_num > 1


--deleting unused columns.  Again happens when creating views. Dnt remove raw data. Having multidata columns that are unnessary 

select*
from PortfolioProject.dbo.NashvilleHousing2

alter table PortfolioProject.dbo.NashvilleHousing2
drop column owneraddress, taxdistrict, propertyaddress

alter table PortfolioProject.dbo.NashvilleHousing2
drop column saledate






