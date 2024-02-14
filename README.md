# FridgeSnap
FridgeSnap is a barcode iOS App that allows users to add products to a shopping list by simply scanning barcodes. It is an app developed during the Mobile Applications Development course in winter semester 2023 / 24 in university. Just by scanning the barcode you get the name, the photo of the product and the category from an API. The data is storaged locally with Swift Data. We also used SwiftUI. 

## Features 
FridgeSnap has the following features: 

- you can add products by scanning the barcode or doing a manual input
- by scanning the barcode you get the photo, an image and the category
- you can delete products or the whole list
- the products are sorted by categories
- you can choose a unity and an amount for each product by using our custom picker

## How to use
FridgeSnap isn't available in the Play Store for now. Until now you have to download the source and compile it on your own. For the Scan we declared a variable where you can choose whether you want to do a mock scan or do a real scan with a propper device. The variable is set when initialising the AddProductView.

## Technology used 
Travelbook was built using the following technologies:

- Swift
- Swift Data
- Swift UI

## TODOs
FridgeSnap isn't production ready, it still has some bugs, that need to be fixed, features that should be implemented and the UX/UI should be optimized for a better usability: 

**Bugs:**
- add UI tests
- the keys do not disappear by clicking somewhere else
- some barcodes are not covered by the API 

**Features:**
- the list should be exportable 
- the checked products should be showed in a second list "bought products"

**UX/UI:**
- optimize the rendering of the products
- optimize the way how we display the selected category and amount by the picker
  
## Contributers
The project was developed by a group of three students

